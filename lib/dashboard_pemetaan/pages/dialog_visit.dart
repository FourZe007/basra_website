import 'dart:convert';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stsj/dashboard-fixup/utilities/extension.dart';
import 'package:stsj/dashboard-fixup/utilities/format.dart';
import 'package:stsj/dashboard_pemetaan/models/geo_visit.dart';
import 'package:stsj/dashboard_pemetaan/services/api.dart';

class DialogVisit extends StatefulWidget {
  const DialogVisit(this.branch, this.shop, this.tgl1, this.tgl2, this.lat, this.lng, {super.key});
  final String branch;
  final String shop;
  final String tgl1;
  final String tgl2;
  final double lat;
  final double lng;

  @override
  State<DialogVisit> createState() => _DialogVisitState();
}

class _DialogVisitState extends State<DialogVisit> {
  final ScrollController _scrollController = ScrollController();
  late bool loading;
  late bool error;
  late String pesanError;
  late List<GeoVisit> listVisit;

  @override
  void initState() {
    loading = true;
    error = false;
    pesanError = '';

    setAwal();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void setAwal() async {
    await getListApi();
  }

  Future<void> getListApi() async {
    try {
      await ApiPemetaan.getDetailVisit(widget.branch, widget.shop, widget.tgl1, widget.tgl2, '01', widget.lat, widget.lng).then((value) {
        setState(() {
          loading = false;
          error = false;
          listVisit = value;
        });
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
        pesanError = 'ERROR: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.indigo,
              valueColor: AlwaysStoppedAnimation(Colors.cyan.shade200),
              strokeWidth: 5.0,
              padding: EdgeInsets.all(5),
            ),
          )
        : error
            ? Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: Text(pesanError, style: TextStyle(fontSize: 12, color: Colors.white))),
              )
            : Stack(
                children: [
                  Center(
                    child: Listener(
                      onPointerSignal: (event) {
                        if (event is PointerScrollEvent) {
                          _scrollController.animateTo(_scrollController.offset + event.scrollDelta.dy,
                              duration: Duration(milliseconds: 2), curve: Curves.bounceIn);
                        }
                      },
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: 40, top: 40, bottom: 30, right: 20),
                          itemCount: listVisit.length,
                          itemBuilder: (context, index) {
                            GeoVisit data = listVisit[index];
                            return AspectRatio(
                              aspectRatio: 2 / 4,
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 4 / 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                        child: Image.memory(base64Decode(data.pic), fit: BoxFit.contain),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Text(
                                        'Detail Informasi',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Jenis Aktivitas', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(width: 20),
                                          Flexible(
                                            child: Text(
                                              data.jenisAktivitas == '' ? '-' : data.jenisAktivitas,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Lokasi', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(width: 20),
                                          Flexible(
                                            child: Text(
                                              data.lokasi == '' ? '-' : data.lokasi,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Tanggal', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(width: 20),
                                          Text(Format.kalenderFormat(data.currentDate).toCapitalized, style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Waktu', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(width: 20),
                                          Text(data.currentTime, style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Jumlah Sales', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(width: 20),
                                          Text('${data.salesman} orang', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Unit Display', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(width: 20),
                                          Flexible(
                                            child: Text(
                                              data.unitDisplay == '' ? '-' : data.unitDisplay,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Database', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(width: 20),
                                          Text('${data.database}', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Hot Prospek', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(width: 20),
                                          Text('${data.hotprospek}', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Deal', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(width: 20),
                                          Text('${data.deal}', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Unit Test Ride', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(width: 20),
                                          Flexible(
                                            child: Text(
                                              data.unitTestRide == '' ? '-' : data.unitTestRide,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Peserta Test Ride', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(width: 20),
                                          Text('${data.deal} orang', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentGeometry.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, right: 5),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 15,
                          child: Icon(
                            Icons.close_rounded,
                            size: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }
}
