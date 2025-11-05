import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/models/Dashboard/delivery.dart';
import 'package:stsj/core/models/Dashboard/delivery_history.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/delivery_map_button.dart';

class TruckLiveMap extends StatefulWidget {
  const TruckLiveMap(
    this.detail,
    this.centerLat,
    this.centerLng, {
    super.key,
  });

  final List<CheckListDetailsModel> detail;
  final double centerLat;
  final double centerLng;

  @override
  State<TruckLiveMap> createState() => _TruckLiveMapState();
}

class _TruckLiveMapState extends State<TruckLiveMap> {
  Timer? updateTimer;
  final MapController mapController = MapController();

  void startAutoUpdate(MenuState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    updateTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      // Fetch the latest truck and polyline data
      await state
          .fetchDeliveryChecklist(
              prefs.getString('CompanyName')!,
              prefs.getString('branchId')!,
              prefs.getString('shopId')!,
              prefs.getString('employeeId')!,
              prefs.getString('date')!)
          .then((list) {
        print('Delivery map length: ${list.length}');
        print('Is truck camera focus: ${state.getIsTruckCameraFocus}');
        print('History length: ${state.getDeliveryHistoryList.length}');
        if (state.getDeliveryHistoryList.isNotEmpty &&
            state.getIsTruckCameraFocus) {
          final length = state.getDeliveryHistoryList.length;
          mapController.move(
            LatLng(
              double.parse(state.getDeliveryHistoryList[length - 1].lat),
              double.parse(state.getDeliveryHistoryList[length - 1].lng),
            ),
            15.0,
          );
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startAutoUpdate(Provider.of<MenuState>(context, listen: false));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = Provider.of<MenuState>(context);
    List<DeliveryHistoryModel> history = menuState.getDeliveryHistoryList;

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(
          // detail[0].lat,
          // detail[0].lng,
          // double.parse(
          //   history[menuState.getDeliveryHistoryList.length - 1].lat,
          // ),
          // double.parse(
          //   history[menuState.getDeliveryHistoryList.length - 1].lng,
          // ),
          widget.centerLat,
          widget.centerLng,
        ),
        initialZoom: 15.0,
      ),
      children: [
        // ~:Map Layer or Image:~
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.stsj',
        ),

        // ~:Delivery Polylines:~
        PolylineLayer(
          polylines: [
            Polyline(
              points: history.map((e) {
                return LatLng(
                  double.parse(e.lat),
                  double.parse(e.lng),
                );
              }).toList(),
              strokeWidth: 5.0,
              color: Colors.blue[700]!,
            ),
          ],
        ),

        // ~:Branches Location:~
        MarkerLayer(
          markers: widget.detail.asMap().entries.map(
            (e) {
              int index = e.key;
              CheckListDetailsModel detail = e.value;
              print('Delivery Time: ${detail.deliveryTime}');

              if (detail.deliveryStatus == 0) {
                if (detail.deliveryTime.isNotEmpty) {
                  return Marker(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.2,
                    point: LatLng(
                      detail.lat,
                      detail.lng,
                    ),
                    child: deliveryMapButton(
                      detail.customerName,
                      0,
                      // counter: detail.deliveryOrder != 99
                      //     ? detail.deliveryOrder.toString()
                      //     : '0',
                      counter: (index + 1).toString(),
                    ),
                  );
                } else {
                  return Marker(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.2,
                    point: LatLng(
                      detail.lat,
                      detail.lng,
                    ),
                    child: deliveryMapButton(
                      detail.customerName,
                      2,
                      // counter: detail.deliveryOrder != 99
                      //     ? detail.deliveryOrder.toString()
                      //     : '0',
                      counter: (index + 1).toString(),
                    ),
                  );
                }
              } else {
                return Marker(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 0.2,
                  point: LatLng(
                    detail.lat,
                    detail.lng,
                  ),
                  child: deliveryMapButton(
                    detail.customerName,
                    1,
                    // counter: detail.deliveryOrder != 99
                    //     ? detail.deliveryOrder.toString()
                    //     : '0',
                    counter: (index + 1).toString(),
                  ),
                );
              }
            },
          ).toList(),
        ),

        // ~:Truck Last Position:~
        MarkerLayer(
          markers: [
            Marker(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.height * 0.2,
              point: LatLng(
                double.parse(
                  history[menuState.getDeliveryHistoryList.length - 1].lat,
                ),
                double.parse(
                  history[menuState.getDeliveryHistoryList.length - 1].lng,
                ),
              ),
              child: Icon(
                Icons.local_shipping,
                color: Colors.grey[800],
                size: 50.0,
              ),
            ),
          ],
        ),

        // ~:Legend:~
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ~:Text Legend:~
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.125,
                    // height: MediaQuery.of(context).size.height * 0.2,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: EdgeInsets.only(top: 10, right: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GlobalFunction.showLegend(
                          Colors.green,
                          'Berhasil terkirim',
                        ),
                        SizedBox(height: 5),
                        GlobalFunction.showLegend(
                          Colors.red,
                          'Gagal terkirim',
                        ),
                        SizedBox(height: 5),
                        GlobalFunction.showLegend(
                          Colors.black,
                          'Belum terkirim',
                        ),
                        SizedBox(height: 5),
                        GlobalFunction.showLegend(
                          Colors.blue[700]!,
                          'Jalur pengiriman',
                          icon: Icons.turn_right_rounded,
                        ),
                      ],
                    ),
                  ),
                ),

                // ~:Devider:~
                SizedBox(height: 10),

                // ~:Map Utilities:~
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      // ~:Pause Truck Movement:~
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            menuState.setMovementPaused();

                            if (menuState.getIsMovementPaused) {
                              print('Timer paused');
                              updateTimer?.cancel();
                            } else {
                              print('Timer resumed');
                              startAutoUpdate(menuState);
                            }
                            setState(() {});
                          },
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            // width: MediaQuery.of(context).size.width * 0.05,
                            // height: MediaQuery.of(context).size.height * 0.075,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 7.5, vertical: 7.5),
                            child: Builder(
                              builder: (context) {
                                if (menuState.getIsMovementPaused) {
                                  return Icon(
                                    Icons.play_arrow_rounded,
                                    fill: 1,
                                  );
                                } else {
                                  return Icon(
                                    Icons.pause_rounded,
                                    color: Colors.black,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      // ~:Camera Focus:~
                      Expanded(
                        child: GestureDetector(
                          onTap: () => menuState.setTruckCameraFocus(),
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            // width: MediaQuery.of(context).size.width * 0.05,
                            // height: MediaQuery.of(context).size.height * 0.075,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 7.5, vertical: 7.5),
                            child: Builder(
                              builder: (context) {
                                if (menuState.getIsTruckCameraFocus) {
                                  return Icon(
                                    Icons.lock_outlined,
                                    fill: 1,
                                  );
                                } else {
                                  return Icon(
                                    Icons.lock_open_outlined,
                                    color: Colors.black,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
