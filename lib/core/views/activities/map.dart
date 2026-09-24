// ignore_for_file: must_be_immutable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/models/Activities/activity_route.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/nip_auto_complete.dart';
import 'package:stsj/router/router_const.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String employeeID = '';
  String date = '';
  ValueNotifier<String> employeeIDNotifier = ValueNotifier('');
  ValueNotifier<String> dateNotifier = ValueNotifier('');
  ValueNotifier<List<String>> filterDataNotifier = ValueNotifier([]);

  String get getEmployeeID => employeeID;

  String get getDate => date;

  void setEmployeeID(String value) {
    employeeID = value;
  }

  void setDate(String value) {
    setState(() {
      date = value;
    });
  }

  void setDateByGoogle(
    BuildContext context,
    String tgl,
  ) async {
    tgl = tgl == '' ? DateTime.now().toString().substring(0, 10) : tgl;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == '' ? DateTime.now() : DateTime.parse(tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1, 1, 0),
    );

    if (picked != null && picked != DateTime.parse(tgl)) {
      tgl = picked.toString().substring(0, 10);
      setDate(tgl);
    } else {
      // Nothing happened
    }
  }

  void pageNavigator(
    BuildContext context,
    int index,
    List<ModelActivityRoute> list,
  ) {
    if (list[index].detail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[400],
          content: Text(
            'Activity details are not available',
            style: GlobalFont.mediumgiantfontR,
          ),
        ),
      );
    } else {
      if (list[index].detail.length > 1) {
        print('more than 1');
        context.goNamed(RoutesConstant.carouselRouteDetails);
      } else {
        print('less than equal to 1');
        context.goNamed(RoutesConstant.routeDetails);
      }
    }
  }

  void getFilterData(
    BuildContext context,
    MenuState activitiesState,
  ) {
    setState(() {
      employeeIDNotifier.value = employeeID;

      // print('ID: ${employeeIDNotifier.value}');
      if (date == '') {
        setDate(
          DateTime.now().toString().substring(0, 10),
        );
        dateNotifier.value = date;
        // print('Date: ${dateNotifier.value}');
      } else {
        dateNotifier.value = date;
        // print('Date: ${dateNotifier.value}');
      }
    });
  }

  void resetData() {
    print('Reset Data');
    setState(() {
      employeeID = '';
      date = '';
      employeeIDNotifier.value = '';
      dateNotifier.value = '';
      filterDataNotifier.value.clear();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('Initiate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    print('Dispose');
    resetData();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: Stack(
        children: [
          // ==================================================================
          // =========================== Map UI ===============================
          // ==================================================================
          ValueListenableBuilder(
            valueListenable: filterDataNotifier,
            builder: (context, value, child) {
              if (value.isNotEmpty) {
                String id = value[0];
                // mapState.setRouteID(id);
                String date = value[1];
                // mapState.setRouteStartDate(date);

                return FutureBuilder(
                  future: mapState.fetchActivityRoute(id, date),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                            ),
                            Text(
                              'Loading...',
                              style: GlobalFont.mediumbigfontR,
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.data!.isEmpty) {
                      return Center(child: Text('Data not available'));
                    } else {
                      return FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            snapshot.data![mapState.getImageIndex].lat,
                            snapshot.data![mapState.getImageIndex].lng,
                          ),
                          initialZoom: 15.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.stsj.sipsales',
                          ),
                          MarkerLayer(
                            markers: [
                              for (int i = 0; i < snapshot.data!.length; i++)
                                Marker(
                                  width: 80.0,
                                  height: 110.0,
                                  point: LatLng(
                                    snapshot.data![i].lat,
                                    snapshot.data![i].lng,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      mapState.setImageIndex(i);

                                      mapState.fetchDetailsProcessing(
                                        mapState.getImageIndex,
                                      );

                                      mapState.resetIsActive();

                                      pageNavigator(
                                        context,
                                        mapState.getImageIndex,
                                        mapState.activityRouteList,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          color: (snapshot
                                                  .data![i].detail.isNotEmpty)
                                              ? Colors.red
                                              : Colors.black,
                                          size: 50.0,
                                        ),
                                        Text(
                                          snapshot.data![i].startTime
                                              .substring(0, 5),
                                          style: GlobalFont.giantfontRBold,
                                        ),
                                        Text(
                                          snapshot.data![i].endTime
                                              .substring(0, 5),
                                          style: GlobalFont.giantfontRBold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                );
              } else {
                return Center(child: Text('Data not available'));
              }
            },
          ),

          Container(
            // width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.01,
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ==================================================================
                // ========================= Map Filter =============================
                // ==================================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      // Note -> fix this feature later, Unable to expand & shrink
                      // onTap: () {
                      //   print('Filter button pressed');
                      //   mapState.toggleFilter();
                      //   setState(() {});
                      // },
                      onTap: null,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.filter_alt_rounded,
                              size: 25.0,
                              color: Colors.black,
                            ),
                            Text(
                              'Filter',
                              style: GlobalFont.mediumgiantfontR,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: 10.0),

                    // Filter's Expand and Collapse Animation
                    AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      reverseDuration: const Duration(milliseconds: 500),
                      curve: mapState.isFilterOpen
                          ? Curves.easeInOut
                          : Curves.easeIn,
                      child: SizedBox(
                        width: mapState.isFilterOpen
                            ? MediaQuery.of(context).size.width * 0.45
                            : 0.0,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Row(
                          children: [
                            // Note -> Old version of Employee ID TextField
                            // new version is using an Autocomplete widget
                            // Container(
                            //   width: MediaQuery.of(context).size.width * 0.125,
                            //   height: MediaQuery.of(context).size.height * 0.05,
                            //   alignment: Alignment.center,
                            //   decoration: BoxDecoration(
                            //     color: Colors.grey[400],
                            //     borderRadius: BorderRadius.circular(15.0),
                            //   ),
                            //   child: TextField(
                            //     textAlign: TextAlign.center,
                            //     inputFormatters: [
                            //       FilteringTextInputFormatter.allow(
                            //         RegExp(r'[a-zA-Z0-9./@\s]*'),
                            //       ),
                            //       UpperCaseText(),
                            //     ],
                            //     controller: TextEditingController(
                            //       text: employeeID,
                            //     ),
                            //     enabled: true,
                            //     style: GlobalFont.mediumgiantfontR,
                            //     decoration: InputDecoration(
                            //       filled: true,
                            //       fillColor: Colors.grey[400],
                            //       hintStyle: GlobalFont.mediumbigfontM,
                            //       hintText: 'Masukkan Employee ID',
                            //       border: OutlineInputBorder(
                            //         borderSide: BorderSide.none,
                            //         borderRadius: BorderRadius.circular(15.0),
                            //       ),
                            //     ),
                            //     onChanged: (newValues) =>
                            //         setEmployeeID(newValues),
                            //   ),
                            // ),
                            NIPAutoComplete(
                              employeeID,
                              setEmployeeID,
                            ),
                            SizedBox(width: 10.0),
                            InkWell(
                              onTap: () => setDateByGoogle(
                                context,
                                date,
                              ),
                              child: Container(
                                // width: MediaQuery.of(context).size.width * 0.1,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                child: Text(
                                  date != ''
                                      ? Format.tanggalFormat(date)
                                      : Format.tanggalFormat(
                                          DateTime.now()
                                              .toString()
                                              .substring(0, 10),
                                        ),
                                  style: GlobalFont.mediumgiantfontR,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            InkWell(
                              onTap: () {
                                getFilterData(context, mapState);

                                filterDataNotifier.value
                                    .add(employeeIDNotifier.value);
                                filterDataNotifier.value
                                    .add(dateNotifier.value);
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                child: const Icon(
                                  Icons.search_rounded,
                                  size: 25.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            InkWell(
                              onTap: () {
                                resetData();
                                mapState.activityRouteList.clear();
                                mapState.setIsReset();
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                child: Text(
                                  'Reset',
                                  style: GlobalFont.mediumgiantfontR,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                // ==================================================================
                // ========================== Devider ===============================
                // ==================================================================
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),

                // ==================================================================
                // ==================== Slidable Route List =========================
                // ==================================================================
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      reverseDuration: const Duration(milliseconds: 500),
                      curve: mapState.isRouteListOpen
                          ? Curves.easeIn
                          : Curves.easeInOut,
                      child: Container(
                        width: mapState.isRouteListOpen
                            ? MediaQuery.of(context).size.width * 0.35
                            : 0.0,
                        height: MediaQuery.of(context).size.height * 0.825,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.01,
                          vertical: MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: mapState.isRouteListOpen
                            ? FutureBuilder(
                                future: mapState.fetchActivityRoute(
                                  employeeID,
                                  date,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025,
                                          ),
                                          Text(
                                            'Loading...',
                                            style: GlobalFont.mediumbigfontR,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  } else if (snapshot.hasData &&
                                      snapshot.data!.isEmpty) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Data not available'),
                                        ElevatedButton(
                                          onPressed: mapState.refreshPage,
                                          child: Text('Reload'),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.025,
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.025,
                                      ),
                                      child: ListView(
                                        children: snapshot.data!
                                            .asMap()
                                            .entries
                                            .map((list) {
                                          final int index = list.key;
                                          final ModelActivityRoute activity =
                                              list.value;

                                          return InkWell(
                                            onTap: () {
                                              mapState.setImageIndex(index);

                                              mapState.fetchDetailsProcessing(
                                                mapState.getImageIndex,
                                              );

                                              mapState.resetIsActive();

                                              pageNavigator(
                                                context,
                                                mapState.getImageIndex,
                                                mapState.activityRouteList,
                                              );
                                            },
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 35,
                                                          height: 35,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child: Text(
                                                            '${index + 1}',
                                                            style: GlobalFont
                                                                .giantfontRBold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'Start and End time: ${activity.startTime}; ${activity.endTime}',
                                                          style: GlobalFont
                                                              .mediumgiantfontR,
                                                        ),
                                                        Text(
                                                          'Coordinate: (${activity.lat}, ${activity.lng})',
                                                          style: GlobalFont
                                                              .mediumgiantfontR,
                                                        ),
                                                        Text(
                                                          activity.detail
                                                                  .isNotEmpty
                                                              ? 'Details are available'
                                                              : 'Details are not available',
                                                          style: (activity
                                                                  .detail
                                                                  .isNotEmpty)
                                                              ? (activity.detail
                                                                          .length >
                                                                      1)
                                                                  ? GlobalFont
                                                                      .mediumgiantfontRRed
                                                                  : GlobalFont
                                                                      .mediumgiantfontRYellow
                                                              : GlobalFont
                                                                  .mediumgiantfontRGrey,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }
                                },
                              )
                            : SizedBox(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.01,
                      ),
                      child: InkWell(
                        onTap: () {
                          // Note -> unable to expand and shrink
                          // print('Arrow pressed');
                          // mapState.toggleRouteList();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Coming Soon')),
                          );
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Icon(
                            mapState.isRouteListOpen
                                ? Icons.arrow_left_rounded
                                : Icons.arrow_right_rounded,
                            size: 24.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
