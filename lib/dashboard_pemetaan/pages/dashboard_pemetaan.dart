import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/models/AuthModel/Auth_Model.dart';
import 'package:stsj/dashboard-fixup/utilities/format.dart';
import 'package:stsj/dashboard_pemetaan/models/geo_dt.dart';
import 'package:stsj/dashboard_pemetaan/models/geo_hd.dart';
import 'package:stsj/dashboard_pemetaan/pages/dialog_visit.dart';
import 'package:stsj/dashboard_pemetaan/utilities/global.dart';
import 'package:stsj/global/globalVar.dart';
import 'package:stsj/router/router_const.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPemetaan extends StatefulWidget {
  const DashboardPemetaan(this.listDatas, this.tgl1, this.tgl2, {super.key});
  final List<GeoHD> listDatas;
  final String tgl1;
  final String tgl2;

  @override
  State<DashboardPemetaan> createState() => _DashboardPemetaanState();
}

class _DashboardPemetaanState extends State<DashboardPemetaan> {
  late MapZoomPanBehavior _zoomPanBehavior;
  late MapTileLayerController _mapController;
  late int mainIdx;
  late bool btnPlus, btnMin;
  late bool loading;
  late List<double> animSize;

  @override
  void initState() {
    _zoomPanBehavior = MapZoomPanBehavior();
    _mapController = MapTileLayerController();
    mainIdx = 0;
    btnPlus = false;
    btnMin = false;
    loading = false;
    animSize = [];

    setAwal();
    resetListDetail();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void setAwal() {
    _zoomPanBehavior = MapZoomPanBehavior(
      focalLatLng: MapLatLng(widget.listDatas[mainIdx].latDealer, widget.listDatas[mainIdx].lngDealer),
      zoomLevel: 12,
      minZoomLevel: 10,
      maxZoomLevel: 15,
      showToolbar: false,
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
      enablePanning: true,
      enablePinching: true,
    );
  }

  void resetListDetail() {
    animSize = [];
    List.generate(widget.listDatas[mainIdx].detail.length, (index) => animSize.add(50));
  }

  void goToPetak(int idx, double lat, double lng) async {
    _zoomPanBehavior.focalLatLng = MapLatLng(lat, lng);
    _zoomPanBehavior.zoomLevel = 15;
    setState(() {});

    do {
      await Future.delayed(Duration(milliseconds: 100));
    } while (_zoomPanBehavior.focalLatLng != MapLatLng(lat, lng));

    setState(() => animSize[idx] = animSize[idx] == 50 ? 80 : 50);
    _mapController.updateMarkers([idx]);

    await Future.delayed(Duration(milliseconds: 600));

    setState(() => animSize[idx] = animSize[idx] == 80 ? 50 : 50);
    _mapController.updateMarkers([idx]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF9EDDFF),
          toolbarHeight: MediaQuery.of(context).size.height * 0.065,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 25),
            onPressed: () => Navigator.pop(context),
          ),
          title: Image.asset('assets/images/stsj.png', width: 50),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(GlobalVar.username, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(width: 10),
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    radius: 20,
                  ),
                  Positioned(
                    right: 0,
                    child: PopupMenuButton<String>(
                      icon: Icon(null),
                      onSelected: (value) {
                        if (value == 'logout') {
                          return;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Logout'),
                          onTap: () async {
                            // ~:Reset User Auth:~
                            await Auth.resetAuth();

                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.clear();

                            if (context.mounted) context.go(RoutesConstant.login);

                            Fluttertoast.showToast(
                              msg: 'Logout berhasil!', // message
                              textColor: Colors.black,
                              toastLength: Toast.LENGTH_LONG, // length
                              gravity: ToastGravity.CENTER, // location
                              webPosition: 'center',
                              webBgColor: 'linear-gradient(to right, #00FF00, #00FF00)',
                              timeInSecForIosWeb: 2, // duration
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          loading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.indigo,
                    valueColor: AlwaysStoppedAnimation(Colors.cyan.shade200),
                    strokeWidth: 5.0,
                    padding: EdgeInsets.all(5),
                  ),
                )
              : SfMaps(
                  layers: [
                    MapTileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      zoomPanBehavior: _zoomPanBehavior,
                      controller: _mapController,
                      initialMarkersCount: widget.listDatas[mainIdx].detail.length + 1,
                      markerBuilder: (BuildContext context, int index) {
                        List<GeoDT> tmpDet = widget.listDatas[mainIdx].detail;
                        if (index == widget.listDatas[mainIdx].detail.length) {
                          return MapMarker(
                            latitude: widget.listDatas[mainIdx].latDealer,
                            longitude: widget.listDatas[mainIdx].lngDealer,
                            child: Tooltip(
                              padding: const EdgeInsets.all(5),
                              message: widget.listDatas[mainIdx].bsName,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  border: Border.all(color: Colors.white70, width: 2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.corporate_fare_outlined, color: Colors.white, size: 20),
                              ),
                            ),
                          );
                        } else {
                          return MapMarker(
                            latitude: tmpDet[index].lat,
                            longitude: tmpDet[index].lng,
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              mouseCursor: MouseCursor.defer,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => DialogVisit(
                                    widget.listDatas[mainIdx].branch,
                                    widget.listDatas[mainIdx].shop,
                                    widget.tgl1,
                                    widget.tgl2,
                                    tmpDet[index].lat,
                                    tmpDet[index].lng,
                                  ),
                                );
                              },
                              child: Tooltip(
                                padding: const EdgeInsets.all(5),
                                message:
                                    'Lokasi ${index + 1}\nDikunjungi sebanyak ${tmpDet[index].qty}x pada:\n${tmpDet[index].detailDate.map((e) => Format.tanggalFormat(e.currentDate)).toList()}',
                                child: AnimatedContainer(
                                  width: animSize[index],
                                  height: animSize[index],
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: tmpDet[index].warna == 1
                                        ? bg1
                                        : tmpDet[index].warna == 2
                                            ? bg2
                                            : tmpDet[index].warna == 3
                                                ? bg3
                                                : bg4,
                                    border: Border.all(
                                      width: 5,
                                      color: tmpDet[index].warna == 1
                                          ? br1
                                          : tmpDet[index].warna == 2
                                              ? br2
                                              : tmpDet[index].warna == 3
                                                  ? br3
                                                  : br4,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn,
                                  child: Center(child: Icon(Icons.person_pin_circle_outlined, size: 25, color: Colors.black54)),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      //*ZOOM CONTROL
                      onWillZoom: (MapZoomDetails details) {
                        if (details.newZoomLevel! >= _zoomPanBehavior.maxZoomLevel) {
                          setState(() {
                            btnPlus = true;
                            btnMin = false;
                          });
                        }
                        if (details.newZoomLevel! <= _zoomPanBehavior.minZoomLevel) {
                          setState(() {
                            btnMin = true;
                            btnPlus = false;
                          });
                        }
                        if (details.newZoomLevel! < _zoomPanBehavior.maxZoomLevel &&
                            details.newZoomLevel! > _zoomPanBehavior.minZoomLevel &&
                            (btnPlus || btnMin)) {
                          setState(() {
                            btnPlus = false;
                            btnMin = false;
                          });
                        }
                        return true;
                      },
                    ),
                  ],
                ),
          //*FOOTBAR
          loading
              ? SizedBox()
              : Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('\u00a9 ', style: TextStyle(fontSize: 10)),
                        TextButton(
                          onPressed: () async => await launchUrl(Uri.parse('https://www.openstreetmap.org/copyright')),
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), overlayColor: Colors.transparent),
                          child: const Text('OpenStreetMap', style: TextStyle(fontSize: 10, decoration: TextDecoration.underline)),
                        ),
                        const Text(' constributors     2026     IT Basra Corporation', style: TextStyle(fontSize: 10))
                      ],
                    ),
                  ),
                ),
          //*TOOLBAR SETTING
          loading
              ? SizedBox()
              : Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //RESTART
                        Container(
                          width: 30,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          child: InkWell(
                            onTap: _zoomPanBehavior.zoomLevel != _zoomPanBehavior.minZoomLevel
                                ? () {
                                    _zoomPanBehavior.zoomLevel = 10;
                                    setState(() {
                                      btnPlus = false;
                                      btnMin = true;
                                    });
                                  }
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(CupertinoIcons.restart.codePoint),
                                  style: TextStyle(
                                    color: btnMin ? Colors.black38 : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.5,
                                    fontFamily: CupertinoIcons.exclamationmark_circle.fontFamily,
                                    package: CupertinoIcons.exclamationmark_circle.fontPackage,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 30,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //ZOOM IN
                              InkWell(
                                onTap: _zoomPanBehavior.zoomLevel < _zoomPanBehavior.maxZoomLevel
                                    ? () {
                                        if (_zoomPanBehavior.zoomLevel + 1 > _zoomPanBehavior.maxZoomLevel) {
                                          _zoomPanBehavior.zoomLevel = 15;
                                        } else {
                                          _zoomPanBehavior.zoomLevel++;
                                        }
                                      }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                      color: btnPlus ? Colors.black38 : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    textHeightBehavior: const TextHeightBehavior(applyHeightToLastDescent: false, applyHeightToFirstAscent: false),
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Divider(height: 0)),
                              //ZOOM OUT
                              InkWell(
                                onTap: _zoomPanBehavior.zoomLevel > _zoomPanBehavior.minZoomLevel
                                    ? () {
                                        if (_zoomPanBehavior.zoomLevel - 1 < _zoomPanBehavior.minZoomLevel) {
                                          _zoomPanBehavior.zoomLevel = 10;
                                        } else {
                                          _zoomPanBehavior.zoomLevel--;
                                        }
                                      }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      color: btnMin ? Colors.black38 : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
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
          //*LEGEND
          loading
              ? SizedBox()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Info Pola Kunjungan', style: TextStyle(fontSize: 12)),
                          VerticalDivider(),
                          Text('Jarang', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                          const SizedBox(width: 3),
                          Container(width: 13, color: br1),
                          const SizedBox(width: 1.5),
                          Container(width: 13, color: br2),
                          const SizedBox(width: 1.5),
                          Container(width: 13, color: br3),
                          const SizedBox(width: 1.5),
                          Container(width: 13, color: br4),
                          const SizedBox(width: 1),
                          Text('Sering', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  ),
                ),
          //*LIST DEALER & LIST LOKASI
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.zero,
                    child: SingleChildScrollView(
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        minTileHeight: 25,
                        tilePadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: Colors.white,
                        title: Text('DEALER', style: TextStyle(fontSize: 13.5, color: Colors.black)),
                        children: [
                          Divider(height: 1),
                          const SizedBox(height: 5),
                          ...widget.listDatas.asMap().map((idx, value) {
                            return MapEntry(
                              idx,
                              GestureDetector(
                                onTap: () async {
                                  mainIdx = idx;
                                  resetListDetail();

                                  setState(() => loading = true);
                                  await Future.delayed(Duration(milliseconds: 500));
                                  setState(() => loading = false);

                                  await Future.delayed(Duration(milliseconds: 300));
                                  _zoomPanBehavior.focalLatLng = MapLatLng(widget.listDatas[mainIdx].latDealer, widget.listDatas[mainIdx].lngDealer);
                                  _zoomPanBehavior.zoomLevel = 12;
                                  setState(() {});
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: mainIdx == idx ? Colors.indigo.shade50 : Colors.transparent,
                                    border: mainIdx == idx ? Border.all(color: Colors.indigo) : Border(),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(value.bsName, style: TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            );
                          }).values,
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: loading
                    ? SizedBox()
                    : ScrollConfiguration(
                        behavior: MaterialScrollBehavior().copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          scrollDirection: Axis.horizontal,
                          hitTestBehavior: HitTestBehavior.deferToChild,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 10,
                            children: List.generate(widget.listDatas[mainIdx].detail.length, (index) {
                              List<GeoDT> tmpDet = widget.listDatas[mainIdx].detail;
                              return ElevatedButton(
                                onPressed: () => goToPetak(index, tmpDet[index].lat, tmpDet[index].lng),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), elevation: 5),
                                child: Text('Lokasi ${index + 1}', style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
