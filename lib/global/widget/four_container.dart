// ignore_for_file: must_be_immutable

import 'dart:convert';
// Add this line

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/models/Activities/manager_activities.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/router/router_const.dart';

class FourContainer extends StatefulWidget {
  FourContainer(
    this.morningBriefing,
    this.visitMarket,
    this.recruitmentInterview,
    this.dailyReport,
    this.date, {
    this.isMobile = false,
    this.deviceWidth = 0,
    super.key,
  });

  List<ModelManagerActivities> morningBriefing;
  List<ModelManagerActivities> visitMarket;
  List<ModelManagerActivities> recruitmentInterview;
  List<ModelManagerActivities> dailyReport;
  String date;
  bool isMobile;
  double deviceWidth;

  @override
  State<FourContainer> createState() => _FourContainerState();
}

class _FourContainerState extends State<FourContainer> {
  void configMapData(
    BuildContext context,
    MenuState state,
    double lat,
    double lng,
  ) {
    // print('Lat: $lat');
    // print('Lng: $lng');

    if (lat != 0 && lng != 0) {
      state.setLat(lat);
      state.setLng(lng);

      // 1st Approach to prevent Load Process take a long time in Web
      context.goNamed(RoutesConstant.managerActivitiesInMap);

      // 2nd Approach to prevent Load Process take a long time in Web
      // final url = Uri.encodeFull(
      //   '${window.location.href}/${RoutesConstant.managerActivitiesInMap}?lat=$lat&lng=$lng',
      // );
      //
      // print('URL: $url');
      //
      // window.open(url, 'Maps');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Coordinate ($lat, $lng)'),
        ),
      );
    }
  }

  void viewImage(
    MenuState state,
    String date,
    double lat,
    double lng,
    String eId,
    String aId, {
    String time = '',
    bool isMobile = false,
  }) {
    if (!isMobile) {
      GlobalFunction.tampilkanDialog(
        context,
        true,
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * 0.975,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.025,
            vertical: MediaQuery.of(context).size.height * 0.025,
          ),
          child: FutureBuilder(
            future: state.fetchImageDir(date, eId, aId, lat, lng),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 10.0),
                    Text('Loading...'),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if ((!snapshot.hasData && snapshot.data!.isEmpty) ||
                  snapshot.data![0] == '') {
                return Center(
                  child: Text('Data not available'),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      // width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.825,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Image.memory(base64Decode(snapshot.data![0])),
                            (time != '')
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                      vertical: 2.5,
                                    ),
                                    margin: EdgeInsets.all(5.0),
                                    child: Text(
                                      'Pukul $time',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  )
                                : SizedBox(),
                            (snapshot.data![1] != '')
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                      vertical: 2.5,
                                    ),
                                    margin: EdgeInsets.all(5.0),
                                    child: Text(
                                      snapshot.data![1],
                                      style: GlobalFont.bigfontR,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                      child: Text('Tap to dismiss'),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      );
    } else {
      GlobalFunction.tampilkanDialog(
        context,
        true,
        Container(
          // width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.025,
            vertical: MediaQuery.of(context).size.height * 0.025,
          ),
          child: FutureBuilder(
            future: state.fetchImageDir(date, eId, aId, lat, lng),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 10.0),
                    Text('Loading...'),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if ((!snapshot.hasData && snapshot.data!.isEmpty) ||
                  snapshot.data![0] == '') {
                return Center(
                  child: Text('Data not available'),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        // width: MediaQuery.of(context).size.width * 0.75,
                        // height: MediaQuery.of(context).size.height * 0.775,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Image.memory(
                                base64Decode(snapshot.data![0]),
                                scale: 0.75,
                              ),
                              (time != '')
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                        vertical: 2.5,
                                      ),
                                      margin: EdgeInsets.all(5.0),
                                      child: Text(
                                        'Pukul $time',
                                        style: GlobalFont.bigfontR,
                                      ),
                                    )
                                  : SizedBox(),
                              (snapshot.data![1] != '')
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                        vertical: 2.5,
                                      ),
                                      margin: EdgeInsets.all(5.0),
                                      child: Text(
                                        snapshot.data![1],
                                        style: GlobalFont.bigfontR,
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Text(
                        'Tap to dismiss',
                        style: GlobalFont.smallfontR,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      );
    }
  }

  Widget computerView(BuildContext context) {
    final state = Provider.of<MenuState>(context);

    return ListView(
      children: widget.morningBriefing.asMap().entries.map((entry) {
        final int index = entry.key;
        final ModelManagerActivities briefing = entry.value;

        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Note -> title of the page based on template
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Text(
                  briefing.shopName,
                  style: GlobalFont.gigafontRBold,
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),

              // ==============================================================
              // ====================== FILTER RESULT =========================
              // ==============================================================
              Row(
                children: [
                  // ===========================================================
                  // =================== MORNING BRIEFING ======================
                  // ===========================================================
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.625,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.yellow,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.01,
                            right: MediaQuery.of(context).size.width * 0.01,
                            top: 25.0,
                            bottom: MediaQuery.of(context).size.height * 0.01,
                          ),
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.01,
                            right: MediaQuery.of(context).size.width * 0.01,
                            top: 15.0,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                (briefing.imageThumb == '' ||
                                        briefing.image != '1')
                                    ? SizedBox()
                                    : GestureDetector(
                                        onTap: () => viewImage(
                                          state,
                                          widget.date,
                                          briefing.lat,
                                          briefing.lng,
                                          briefing.employeeId,
                                          briefing.actId,
                                          time: briefing.currentTime != ''
                                              ? briefing.currentTime
                                              : '',
                                        ),
                                        child: Image.memory(
                                          base64Decode(briefing.imageThumb),
                                        ),
                                      ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: briefing.actDesc != ''
                                      ? Text(
                                          briefing.actDesc,
                                          style: GlobalFont.bigfontR,
                                        )
                                      : Text(
                                          'Description not available',
                                          style: GlobalFont.bigfontR,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (briefing.lat != 0 && briefing.lng != 0)
                                        ? Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      configMapData(
                                                    context,
                                                    state,
                                                    briefing.lat,
                                                    briefing.lng,
                                                  ),
                                                  child: Text('Buka Map'),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 32.5,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.025,
                            right: MediaQuery.of(context).size.width * 0.025,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Morning Briefing',
                                textAlign: TextAlign.center,
                                style: GlobalFont.giantfontRBold,
                              ),
                              // (briefing.currentTime != '')
                              //     ? (briefingHour == 08 &&
                              //             (briefingMinute >= 00 &&
                              //                 briefingMinute <= 15))
                              (briefing.currentTime != '')
                                  ? (briefing.isLate == 0)
                                      ? SizedBox()
                                      : Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            Icon(
                                              Icons.warning_rounded,
                                              color: Colors.red,
                                              size: 25,
                                            ),
                                          ],
                                        )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===========================================================
                  // ===================== VISIT MARKET ========================
                  // ===========================================================
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.625,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue[200]!,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.01,
                            right: MediaQuery.of(context).size.width * 0.01,
                            top: 25.0,
                            bottom: MediaQuery.of(context).size.height * 0.01,
                          ),
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.01,
                            right: MediaQuery.of(context).size.width * 0.01,
                            top: 15.0,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                widget.visitMarket[index].imageThumb.isEmpty
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () => viewImage(
                                          state,
                                          widget.date,
                                          widget.visitMarket[index].lat,
                                          widget.visitMarket[index].lng,
                                          widget.visitMarket[index].employeeId,
                                          widget.visitMarket[index].actId,
                                          time: widget.visitMarket[index]
                                                      .currentTime !=
                                                  ''
                                              ? widget.visitMarket[index]
                                                  .currentTime
                                              : '',
                                        ),
                                        child: Image.memory(
                                          base64Decode(widget
                                              .visitMarket[index].imageThumb),
                                        ),
                                      ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: widget.visitMarket[index].actDesc != ''
                                      ? Text(
                                          widget.visitMarket[index].actDesc,
                                          style: GlobalFont.bigfontR,
                                        )
                                      : Text(
                                          'Description not available',
                                          style: GlobalFont.bigfontR,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (widget.visitMarket[index].lat != 0 &&
                                            widget.visitMarket[index].lng != 0)
                                        ? Expanded(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      configMapData(
                                                    context,
                                                    state,
                                                    widget
                                                        .visitMarket[index].lat,
                                                    widget
                                                        .visitMarket[index].lng,
                                                  ),
                                                  child: Text('Buka Map'),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 32.5,
                          decoration: BoxDecoration(
                            color: Colors.blue[200]!,
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.025,
                            right: MediaQuery.of(context).size.width * 0.025,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Visit Market',
                                textAlign: TextAlign.center,
                                style: GlobalFont.giantfontRBold,
                              ),
                              (widget.visitMarket[index].currentTime != '')
                                  ? (widget.visitMarket[index].isLate == 0)
                                      ? SizedBox()
                                      : Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            Icon(
                                              Icons.warning_rounded,
                                              color: Colors.red,
                                              size: 25,
                                            ),
                                          ],
                                        )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===========================================================
                  // ================ RECRUITMENT & INTERVIEW ==================
                  // ===========================================================
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.625,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green[300]!,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.01,
                            right: MediaQuery.of(context).size.width * 0.01,
                            top: 25.0,
                            bottom: MediaQuery.of(context).size.height * 0.01,
                          ),
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.01,
                            right: MediaQuery.of(context).size.width * 0.01,
                            top: 15.0,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                widget.recruitmentInterview[index].imageThumb
                                        .isEmpty
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () => viewImage(
                                          state,
                                          widget.date,
                                          widget
                                              .recruitmentInterview[index].lat,
                                          widget
                                              .recruitmentInterview[index].lng,
                                          widget.recruitmentInterview[index]
                                              .employeeId,
                                          widget.recruitmentInterview[index]
                                              .actId,
                                          time: widget
                                                      .recruitmentInterview[
                                                          index]
                                                      .currentTime !=
                                                  ''
                                              ? widget
                                                  .recruitmentInterview[index]
                                                  .currentTime
                                              : '',
                                        ),
                                        child: Image.memory(
                                          base64Decode(widget
                                              .recruitmentInterview[index]
                                              .imageThumb),
                                        ),
                                      ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: widget.recruitmentInterview[index]
                                              .actDesc !=
                                          ''
                                      ? Text(
                                          widget.recruitmentInterview[index]
                                              .actDesc,
                                          style: GlobalFont.bigfontR,
                                        )
                                      : Text(
                                          'Description not available',
                                          style: GlobalFont.bigfontR,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    (widget.recruitmentInterview[index].lat !=
                                                0 &&
                                            widget.recruitmentInterview[index]
                                                    .lng !=
                                                0)
                                        ? Expanded(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      configMapData(
                                                    context,
                                                    state,
                                                    widget
                                                        .recruitmentInterview[
                                                            index]
                                                        .lat,
                                                    widget
                                                        .recruitmentInterview[
                                                            index]
                                                        .lng,
                                                  ),
                                                  child: Text('Buka Map'),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 32.5,
                          decoration: BoxDecoration(
                            color: Colors.green[300]!,
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.025,
                            right: MediaQuery.of(context).size.width * 0.025,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Recruitment & Interview',
                                textAlign: TextAlign.center,
                                style: GlobalFont.giantfontRBold,
                              ),
                              (widget.recruitmentInterview[index].currentTime !=
                                      '')
                                  ? (widget.recruitmentInterview[index]
                                              .isLate ==
                                          0)
                                      ? SizedBox()
                                      : Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            Icon(
                                              Icons.warning_rounded,
                                              color: Colors.red,
                                              size: 25,
                                            ),
                                          ],
                                        )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===========================================================
                  // ====================== DAILY REPORT =======================
                  // ===========================================================
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.625,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.purple[200]!,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.01,
                            right: MediaQuery.of(context).size.width * 0.01,
                            top: 25.0,
                            bottom: MediaQuery.of(context).size.height * 0.01,
                          ),
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.01,
                            right: MediaQuery.of(context).size.width * 0.01,
                            top: 15.0,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                widget.dailyReport[index].imageThumb.isEmpty
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () => viewImage(
                                          state,
                                          widget.date,
                                          widget.dailyReport[index].lat,
                                          widget.dailyReport[index].lng,
                                          widget.dailyReport[index].employeeId,
                                          widget.dailyReport[index].actId,
                                          time: widget.dailyReport[index]
                                                      .currentTime !=
                                                  ''
                                              ? widget.dailyReport[index]
                                                  .currentTime
                                              : '',
                                        ),
                                        child: Image.memory(
                                          base64Decode(widget
                                              .dailyReport[index].imageThumb),
                                        ),
                                      ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: widget.dailyReport[index].actDesc != ''
                                      ? Text(
                                          widget.dailyReport[index].actDesc,
                                          style: GlobalFont.bigfontR,
                                        )
                                      : Text(
                                          'Description not available',
                                          style: GlobalFont.bigfontR,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    (widget.dailyReport[index].lat != 0 &&
                                            widget.dailyReport[index].lng != 0)
                                        ? Expanded(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      configMapData(
                                                    context,
                                                    state,
                                                    widget
                                                        .dailyReport[index].lat,
                                                    widget
                                                        .dailyReport[index].lng,
                                                  ),
                                                  child: Text('Buka Map'),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 32.5,
                          decoration: BoxDecoration(
                            color: Colors.purple[200],
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.025,
                            right: MediaQuery.of(context).size.width * 0.025,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Daily Report',
                                textAlign: TextAlign.center,
                                style: GlobalFont.giantfontRBold,
                              ),
                              (widget.dailyReport[index].currentTime != '')
                                  ? (widget.dailyReport[index].isLate == 0)
                                      ? SizedBox()
                                      : Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            Icon(
                                              Icons.warning_rounded,
                                              color: Colors.red,
                                              size: 25,
                                            ),
                                          ],
                                        )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget mobileView(BuildContext context, double deviceWidth) {
    final state = Provider.of<MenuState>(context);

    return ListView(
      children: widget.morningBriefing.asMap().entries.map((entry) {
        final int index = entry.key;
        final ModelManagerActivities briefing = entry.value;

        return Container(
          width: MediaQuery.of(context).size.width,
          height: (deviceWidth <= 450)
              ? MediaQuery.of(context).size.height * 0.55
              : MediaQuery.of(context).size.height * 0.82,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.center,
                child: Text(
                  briefing.shopName,
                  style: GlobalFont.giantfontRBold,
                ),
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.01,
              // ),
              Expanded(
                flex: 4,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.625,
                  alignment: Alignment.center,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      // ===========================================================
                      // =================== MORNING BRIEFING ======================
                      // ===========================================================
                      SizedBox(
                        width: (deviceWidth <= 450)
                            ? MediaQuery.of(context).size.width * 0.75
                            : MediaQuery.of(context).size.width * 0.3,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: (deviceWidth <= 450)
                                  ? MediaQuery.of(context).size.height * 0.425
                                  : MediaQuery.of(context).size.height * 0.625,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.yellow,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.01,
                                right: MediaQuery.of(context).size.width * 0.01,
                                top: 25.0,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.01,
                                right: MediaQuery.of(context).size.width * 0.01,
                                top: 15.0,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: briefing.actDesc != ''
                                          ? Text(
                                              briefing.actDesc,
                                              style: GlobalFont.bigfontR,
                                            )
                                          : Text(
                                              'Description not available',
                                              style: GlobalFont.bigfontR,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                    ),
                                    Row(
                                      children: [
                                        (briefing.lat != 0 && briefing.lng != 0)
                                            ? Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          configMapData(
                                                        context,
                                                        state,
                                                        briefing.lat,
                                                        briefing.lng,
                                                      ),
                                                      child: Text('Buka Map'),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        (briefing.image == '' ||
                                                briefing.image != '1')
                                            ? SizedBox()
                                            : Expanded(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          viewImage(
                                                        state,
                                                        widget.date,
                                                        briefing.lat,
                                                        briefing.lng,
                                                        briefing.employeeId,
                                                        briefing.actId,
                                                        time:
                                                            briefing.currentTime !=
                                                                    ''
                                                                ? briefing
                                                                    .currentTime
                                                                : '',
                                                        isMobile: true,
                                                      ),
                                                      child: Text('Lihat Foto'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 32.5,
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(12.5),
                              ),
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.025,
                                right:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Morning Briefing',
                                    textAlign: TextAlign.center,
                                    style: GlobalFont.bigfontRBold,
                                  ),
                                  (briefing.currentTime != '')
                                      ? (briefing.isLate == 0)
                                          ? SizedBox()
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                ),
                                                Icon(
                                                  Icons.warning_rounded,
                                                  color: Colors.red,
                                                  size: 25,
                                                ),
                                              ],
                                            )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ===========================================================
                      // ===================== VISIT MARKET ========================
                      // ===========================================================
                      SizedBox(
                        width: (deviceWidth <= 450)
                            ? MediaQuery.of(context).size.width * 0.75
                            : MediaQuery.of(context).size.width * 0.3,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: (deviceWidth <= 450)
                                  ? MediaQuery.of(context).size.height * 0.425
                                  : MediaQuery.of(context).size.height * 0.625,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue[200]!,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.01,
                                right: MediaQuery.of(context).size.width * 0.01,
                                top: 25.0,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.01,
                                right: MediaQuery.of(context).size.width * 0.01,
                                top: 15.0,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: widget
                                                  .visitMarket[index].actDesc !=
                                              ''
                                          ? Text(
                                              widget.visitMarket[index].actDesc,
                                              style: GlobalFont.bigfontR,
                                            )
                                          : Text(
                                              'Description not available',
                                              style: GlobalFont.bigfontR,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        (widget.visitMarket[index].lat != 0 &&
                                                widget.visitMarket[index].lng !=
                                                    0)
                                            ? Expanded(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          configMapData(
                                                        context,
                                                        state,
                                                        widget
                                                            .visitMarket[index]
                                                            .lat,
                                                        widget
                                                            .visitMarket[index]
                                                            .lng,
                                                      ),
                                                      child: Text('Buka Map'),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        (widget.visitMarket[index].image ==
                                                    '' ||
                                                widget.visitMarket[index]
                                                        .image !=
                                                    '1')
                                            ? SizedBox()
                                            : Expanded(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          viewImage(
                                                        state,
                                                        widget.date,
                                                        widget
                                                            .visitMarket[index]
                                                            .lat,
                                                        widget
                                                            .visitMarket[index]
                                                            .lng,
                                                        widget
                                                            .visitMarket[index]
                                                            .employeeId,
                                                        widget
                                                            .visitMarket[index]
                                                            .actId,
                                                        time: widget
                                                                    .visitMarket[
                                                                        index]
                                                                    .currentTime !=
                                                                ''
                                                            ? widget
                                                                .visitMarket[
                                                                    index]
                                                                .currentTime
                                                            : '',
                                                        isMobile: true,
                                                      ),
                                                      child: Text('Lihat Foto'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 32.5,
                              decoration: BoxDecoration(
                                color: Colors.blue[200]!,
                                borderRadius: BorderRadius.circular(12.5),
                              ),
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.025,
                                right:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Visit Market',
                                    textAlign: TextAlign.center,
                                    style: GlobalFont.bigfontRBold,
                                  ),
                                  (widget.visitMarket[index].currentTime != '')
                                      ? (widget.visitMarket[index].isLate == 0)
                                          ? SizedBox()
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                ),
                                                Icon(
                                                  Icons.warning_rounded,
                                                  color: Colors.red,
                                                  size: 25,
                                                ),
                                              ],
                                            )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ===========================================================
                      // ================ RECRUITMENT & INTERVIEW ==================
                      // ===========================================================
                      SizedBox(
                        width: (deviceWidth <= 450)
                            ? MediaQuery.of(context).size.width * 0.75
                            : MediaQuery.of(context).size.width * 0.3,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: (deviceWidth <= 450)
                                  ? MediaQuery.of(context).size.height * 0.425
                                  : MediaQuery.of(context).size.height * 0.625,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green[300]!,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.01,
                                right: MediaQuery.of(context).size.width * 0.01,
                                top: 25.0,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.01,
                                right: MediaQuery.of(context).size.width * 0.01,
                                top: 15.0,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: widget.recruitmentInterview[index]
                                                  .actDesc !=
                                              ''
                                          ? Text(
                                              widget.recruitmentInterview[index]
                                                  .actDesc,
                                              style: GlobalFont.bigfontR,
                                            )
                                          : Text(
                                              'Description not available',
                                              style: GlobalFont.bigfontR,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        (widget.recruitmentInterview[index]
                                                        .lat !=
                                                    0 &&
                                                widget
                                                        .recruitmentInterview[
                                                            index]
                                                        .lng !=
                                                    0)
                                            ? Expanded(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          configMapData(
                                                        context,
                                                        state,
                                                        widget
                                                            .recruitmentInterview[
                                                                index]
                                                            .lat,
                                                        widget
                                                            .recruitmentInterview[
                                                                index]
                                                            .lng,
                                                      ),
                                                      child: Text('Buka Map'),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        (widget.recruitmentInterview[index]
                                                        .image ==
                                                    '' ||
                                                widget
                                                        .recruitmentInterview[
                                                            index]
                                                        .image !=
                                                    '1')
                                            ? SizedBox()
                                            : Expanded(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          viewImage(
                                                        state,
                                                        widget.date,
                                                        widget
                                                            .recruitmentInterview[
                                                                index]
                                                            .lat,
                                                        widget
                                                            .recruitmentInterview[
                                                                index]
                                                            .lng,
                                                        widget
                                                            .recruitmentInterview[
                                                                index]
                                                            .employeeId,
                                                        widget
                                                            .recruitmentInterview[
                                                                index]
                                                            .actId,
                                                        time: widget
                                                                    .recruitmentInterview[
                                                                        index]
                                                                    .currentTime !=
                                                                ''
                                                            ? widget
                                                                .recruitmentInterview[
                                                                    index]
                                                                .currentTime
                                                            : '',
                                                        isMobile: true,
                                                      ),
                                                      child: Text('Lihat Foto'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 32.5,
                              decoration: BoxDecoration(
                                color: Colors.green[300]!,
                                borderRadius: BorderRadius.circular(12.5),
                              ),
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.025,
                                right:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Recruitment & Interview',
                                    textAlign: TextAlign.center,
                                    style: GlobalFont.bigfontRBold,
                                  ),
                                  (widget.recruitmentInterview[index]
                                              .currentTime !=
                                          '')
                                      ? (widget.recruitmentInterview[index]
                                                  .isLate ==
                                              0)
                                          ? SizedBox()
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                ),
                                                Icon(
                                                  Icons.warning_rounded,
                                                  color: Colors.red,
                                                  size: 25,
                                                ),
                                              ],
                                            )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ===========================================================
                      // ====================== DAILY REPORT =======================
                      // ===========================================================
                      SizedBox(
                        width: (deviceWidth <= 450)
                            ? MediaQuery.of(context).size.width * 0.75
                            : MediaQuery.of(context).size.width * 0.3,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: (deviceWidth <= 450)
                                  ? MediaQuery.of(context).size.height * 0.425
                                  : MediaQuery.of(context).size.height * 0.625,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.purple[200]!,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.01,
                                right: MediaQuery.of(context).size.width * 0.01,
                                top: 25.0,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.01,
                                right: MediaQuery.of(context).size.width * 0.01,
                                top: 15.0,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: widget
                                                  .dailyReport[index].actDesc !=
                                              ''
                                          ? Text(
                                              widget.dailyReport[index].actDesc,
                                              style: GlobalFont.bigfontR,
                                            )
                                          : Text(
                                              'Description not available',
                                              style: GlobalFont.bigfontR,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        (widget.dailyReport[index].lat != 0 &&
                                                widget.dailyReport[index].lng !=
                                                    0)
                                            ? Expanded(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          configMapData(
                                                        context,
                                                        state,
                                                        widget
                                                            .dailyReport[index]
                                                            .lat,
                                                        widget
                                                            .dailyReport[index]
                                                            .lng,
                                                      ),
                                                      child: Text('Buka Map'),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        (widget.dailyReport[index].image ==
                                                    '' ||
                                                widget.dailyReport[index]
                                                        .image !=
                                                    '1')
                                            ? SizedBox()
                                            : Expanded(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          viewImage(
                                                        state,
                                                        widget.date,
                                                        widget
                                                            .dailyReport[index]
                                                            .lat,
                                                        widget
                                                            .dailyReport[index]
                                                            .lng,
                                                        widget
                                                            .dailyReport[index]
                                                            .employeeId,
                                                        widget
                                                            .dailyReport[index]
                                                            .actId,
                                                        time: widget
                                                                    .dailyReport[
                                                                        index]
                                                                    .currentTime !=
                                                                ''
                                                            ? widget
                                                                .dailyReport[
                                                                    index]
                                                                .currentTime
                                                            : '',
                                                        isMobile: true,
                                                      ),
                                                      child: Text('Lihat Foto'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 32.5,
                              decoration: BoxDecoration(
                                color: Colors.purple[200],
                                borderRadius: BorderRadius.circular(12.5),
                              ),
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.025,
                                right:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Daily Report',
                                    textAlign: TextAlign.center,
                                    style: GlobalFont.bigfontRBold,
                                  ),
                                  (widget.dailyReport[index].currentTime != '')
                                      ? (widget.dailyReport[index].isLate == 0)
                                          ? SizedBox()
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                ),
                                                Icon(
                                                  Icons.warning_rounded,
                                                  color: Colors.red,
                                                  size: 25,
                                                ),
                                              ],
                                            )
                                      : SizedBox(),
                                ],
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
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isMobile) {
      return computerView(context);
    } else {
      return mobileView(context, widget.deviceWidth);
    }
  }
}
