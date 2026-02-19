import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stsj/activity_point/models/activity.dart';
import 'package:stsj/activity_point/models/activity00.dart';
import 'package:stsj/activity_point/models/activity01.dart';
import 'package:stsj/activity_point/models/activity02.dart';
import 'package:stsj/activity_point/models/activity03.dart';
import 'package:stsj/activity_point/models/activity04.dart';
import 'package:stsj/activity_point/models/model_manager_activities.dart';
import 'package:stsj/activity_point/services/api.dart';
import 'package:stsj/activity_point/widgets/container_score.dart';
import 'package:stsj/activity_point/widgets/image_fullscreen.dart';
import 'package:stsj/activity_point/widgets/view_activity00.dart';
import 'package:stsj/activity_point/widgets/view_activity01.dart';
import 'package:stsj/activity_point/widgets/view_activity02.dart';
import 'package:stsj/activity_point/widgets/view_activity03.dart';
import 'package:stsj/activity_point/widgets/view_activity04.dart';
import 'package:stsj/activity_point/widgets/view_map.dart';
import 'package:stsj/dashboard-fixup/utilities/extension.dart';
import 'package:stsj/dashboard-fixup/utilities/format.dart';
import 'package:stsj/dashboard-fixup/widgets/snackbar_info.dart';

class CardActivity extends StatefulWidget {
  const CardActivity(this.judul, this.warna, this.model, {super.key});
  final String judul;
  final Color warna;
  final ModelManagerActivities model;

  @override
  State<CardActivity> createState() => _CardActivityState();
}

class _CardActivityState extends State<CardActivity> {
  final ScrollController _scrollController = ScrollController();
  late Activity? caption;
  late bool loading;
  late bool error;
  late String pesanError;

  @override
  void initState() {
    caption = null;
    loading = false;
    error = false;
    pesanError = '';

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void updatePoin1(bool val) async {
    try {
      await ApiPoint.updateScore(val ? 1 : 0, null, null, widget.model, 'ARMA VIEYYA').then(
        (_) => setState(() => widget.model.point1Final = val ? 1 : 0),
      );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
    }
  }

  void updatePoint2(bool val) async {
    try {
      await ApiPoint.updateScore(null, val ? 1 : 0, null, widget.model, 'ARMA VIEYYA').then(
        (_) => setState(() => widget.model.point2Final = val ? 1 : 0),
      );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
    }
  }

  void updatePoint3(bool val) async {
    try {
      await ApiPoint.updateScore(null, null, val ? 1 : 0, widget.model, 'ARMA VIEYYA').then(
        (_) => setState(() => widget.model.point3Final = val ? 1 : 0),
      );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            color: widget.warna,
          ),
          child: Text(
            widget.judul,
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        widget.model.employeeId == ''
            ? Center(
                heightFactor: 1.5,
                child: Text(
                  'Belum ada data diupload',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              )
            : Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ImageFS(
                              widget.model.currentTime,
                              widget.model.branch,
                              widget.model.shop,
                              widget.model.actId,
                              widget.model.currentDate,
                            );
                          },
                        );
                      },
                      child: AspectRatio(
                        //aspectRatio: 16 / 9,
                        aspectRatio: 4 / 3,
                        child: Hero(
                          tag: widget.model.currentTime,
                          child: Image.memory(base64Decode(widget.model.picThumb), fit: BoxFit.contain),
                        ),
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
                    Expanded(
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            ListTile(
                              minTileHeight: 15,
                              contentPadding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 0),
                              titleAlignment: ListTileTitleAlignment.top,
                              leading: Icon(Icons.person_outline, size: 23, color: Colors.indigo.shade600),
                              title: Text(
                                widget.model.eName.toCapitalized,
                                style: TextStyle(fontSize: 13.5, color: Colors.black),
                              ),
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: widget.model.eName.toCapitalized));
                                ScaffoldMessenger.of(context).showSnackBar(info(false, 'BERHASIL DISALIN'));
                              },
                            ),
                            ListTile(
                              minTileHeight: 15,
                              contentPadding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 0),
                              titleAlignment: ListTileTitleAlignment.top,
                              leading: Icon(Icons.date_range_outlined, size: 22, color: Colors.indigo.shade600),
                              title: Text(
                                '${Format.kalenderFormat(widget.model.currentDate).toCapitalized}, ${widget.model.currentTime}',
                                style: TextStyle(fontSize: 13.5, color: Colors.black),
                              ),
                              trailing: widget.model.flag == 1
                                  ? Icon(
                                      Icons.warning_rounded,
                                      color: Colors.red,
                                      size: 20,
                                    )
                                  : const SizedBox(),
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: '${Format.kalenderFormat(widget.model.currentDate).toCapitalized}, ${widget.model.currentTime}',
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(info(false, 'BERHASIL DISALIN'));
                              },
                            ),
                            ListTile(
                              minTileHeight: 15,
                              contentPadding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 0),
                              titleAlignment: ListTileTitleAlignment.top,
                              leading: Icon(Icons.location_on_outlined, size: 23, color: Colors.indigo.shade600),
                              title: Text(
                                '${widget.model.lat}, ${widget.model.lng}',
                                style: TextStyle(fontSize: 13.5, color: Colors.black),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => ViewMap(widget.model.lat, widget.model.lng),
                                );
                              },
                            ),
                            ExpansionTile(
                              minTileHeight: 15,
                              tilePadding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 0),
                              leading: Icon(Icons.description_outlined, size: 23, color: Colors.indigo.shade600),
                              title: Row(
                                children: const [
                                  Text(
                                    'Lihat Laporan',
                                    style: TextStyle(fontSize: 13.5, color: Colors.black),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black45)
                                ],
                              ),
                              trailing: widget.model.flag == 1
                                  ? Icon(
                                      Icons.warning_rounded,
                                      color: Colors.red,
                                      size: 20,
                                    )
                                  : const SizedBox(),
                              onExpansionChanged: (value) async {
                                if (value) {
                                  if (caption == null) {
                                    try {
                                      setState(() => loading = true);
                                      await ApiPoint.getActivityCaption(
                                              widget.model.actId, widget.model.branch, widget.model.shop, widget.model.currentDate)
                                          .then((value) {
                                        setState(() {
                                          loading = false;
                                          error = false;
                                          caption = value;
                                        });
                                      });
                                    } catch (e) {
                                      setState(() {
                                        loading = false;
                                        error = true;
                                        pesanError = e.toString();
                                      });
                                    }
                                  }
                                }
                              },
                              children: [
                                loading
                                    ? CircularProgressIndicator(
                                        backgroundColor: Colors.indigo,
                                        valueColor: AlwaysStoppedAnimation(Colors.cyan.shade200),
                                        strokeWidth: 5.0,
                                        padding: EdgeInsets.all(5),
                                      )
                                    : error
                                        ? Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Text(pesanError, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                                          )
                                        : caption != null
                                            ? widget.model.actId == '00'
                                                ? viewActivity00(caption as Activity00)
                                                : widget.model.actId == '01'
                                                    ? viewActivity01(caption as Activity01)
                                                    : widget.model.actId == '02'
                                                        ? viewActivity02(caption as Activity02)
                                                        : widget.model.actId == '03'
                                                            ? viewActivity03(caption as Activity03)
                                                            : viewActivity04(caption as Activity04)
                                            : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Poin Aktivitas',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 3),
                    IntrinsicHeight(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Expanded(child: ContainerScore(widget.model.point1Final == 1 ? true : false, 'Waktu', updatePoin1)),
                            VerticalDivider(),
                            Expanded(child: ContainerScore(widget.model.point2Final == 1 ? true : false, 'Foto', updatePoint2)),
                            VerticalDivider(),
                            Expanded(child: ContainerScore(widget.model.point3Final == 1 ? true : false, 'Caption', updatePoint3)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
      ],
    );
  }
}
