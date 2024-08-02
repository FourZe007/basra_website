import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/widget/activities_point_table.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/area_dropdown.dart';
import 'package:stsj/global/widget/province_dropdown.dart';
import 'package:stsj/router/router_const.dart';

class ActivitiesPoint extends StatefulWidget {
  const ActivitiesPoint({super.key});

  @override
  State<ActivitiesPoint> createState() => _ActivitiesPointState();
}

class _ActivitiesPointState extends State<ActivitiesPoint> {
  String province = '';
  String area = '';
  String beginDate = '';
  String endDate = '';

  // Value Listener
  ValueNotifier<String> beginDateNotifier = ValueNotifier('');
  ValueNotifier<String> endDateNotifier = ValueNotifier('');
  ValueNotifier<List<String>> filterDataNotifier = ValueNotifier([]);

  // Set Province (same as Area as the placeholder of the UI)
  void setProvince(String value) {
    setState(() {
      province = value;
    });
  }

  // Set Area (same as Wilayah as the placeholder of the UI)
  void setArea(String value) {
    area = value;
  }

  // Set Begin Date
  void setBeginDate(String value) {
    setState(() {
      beginDate = value;
    });
  }

  // Set End Date
  void setEndDate(String value) {
    setState(() {
      endDate = value;
    });
  }

  // Start Date Function
  void setBeginDateByGoogle(
    BuildContext context,
    String tgl,
  ) async {
    tgl = tgl == ''
        ? DateTime.now().subtract(Duration(days: 6)).toString().substring(0, 10)
        : tgl;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == ''
          ? DateTime.now().subtract(Duration(days: 6))
          : DateTime.parse(tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1, 1, 0),
      selectableDayPredicate: (DateTime day) {
        if (day.weekday == DateTime.sunday) {
          return false;
        }

        return true;
      },
    );

    if (picked != null && picked != DateTime.parse(tgl)) {
      tgl = picked.toString().substring(0, 10);
      setBeginDate(tgl);
    } else {
      // Nothing happened
    }
  }

  // End Date Function
  void setEndDateByGoogle(
    BuildContext context,
    String tgl,
  ) async {
    tgl = tgl == '' ? DateTime.now().toString().substring(0, 10) : tgl;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == '' ? DateTime.now() : DateTime.parse(tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1, 1, 0),
      selectableDayPredicate: (DateTime day) {
        if (day.weekday == DateTime.sunday) {
          return false;
        }

        return true;
      },
    );

    if (picked != null && picked != DateTime.parse(tgl)) {
      tgl = picked.toString().substring(0, 10);
      setEndDate(tgl);
    } else {
      // Nothing happened
    }
  }

  // Get Data from Filter for further data processing
  void getFilterData(
    BuildContext context,
    MapState state,
  ) {
    setState(() {
      state.provinceNotifier.value = province;
      state.areaNotifier.value = area;

      if (beginDate == '') {
        setBeginDate(
          DateTime.now()
              .subtract(Duration(days: 7))
              .toString()
              .substring(0, 10),
        );
        beginDateNotifier.value = beginDate;
      } else {
        beginDateNotifier.value = beginDate;
      }

      if (endDate == '') {
        setEndDate(
          DateTime.now()
              .subtract(Duration(days: 7))
              .toString()
              .substring(0, 10),
        );
        endDateNotifier.value = endDate;
      } else {
        endDateNotifier.value = endDate;
      }
    });
  }

  void resetData(
    MapState state,
  ) {
    setState(() {
      province = '';
      area = '';
      beginDate = '';
      endDate = '';
      beginDateNotifier.value = '';
      endDateNotifier.value = '';
      filterDataNotifier.value.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final activitiesPointState = Provider.of<MapState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Column(
          children: [
            // ==================================================================
            // =========================== Filter ===============================
            // ==================================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Filter text
                InkWell(
                  onTap: null,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
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

                // Devider
                SizedBox(width: 10.0),

                // Filter's Expand and Collapse Animation
                AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  reverseDuration: const Duration(milliseconds: 500),
                  curve: activitiesPointState.isFilterOpen
                      ? Curves.easeInOut
                      : Curves.easeIn,
                  child: SizedBox(
                    // Note -> used for slide in and slide out animation
                    // but it didn't work because maybe it's a web based program
                    // width: activitiesPointState.isFilterOpen
                    //     ? MediaQuery.of(context).size.width * 0.5
                    //     : 0.0,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                      children: [
                        // Area Dropdown
                        Container(
                          width: MediaQuery.of(context).size.width * 0.125,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01,
                            vertical: MediaQuery.of(context).size.height * 0.01,
                          ),
                          child: ProvinceDropdown(
                            listData: activitiesPointState.provinceList,
                            inputan: province,
                            hint: 'Area',
                            handle: setProvince,
                          ),
                        ),

                        // Devider
                        SizedBox(width: 10.0),

                        // Wilayah Dropdown
                        ValueListenableBuilder(
                          valueListenable:
                              activitiesPointState.provinceNotifier,
                          builder: (context, value, _) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.125,
                              child: FutureBuilder(
                                future: activitiesPointState.fetchAreas(value),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  } else {
                                    return AnimatedContainer(
                                      duration: const Duration(seconds: 1),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: (snapshot.data!.isNotEmpty &&
                                                snapshot.data!.length > 2)
                                            ? Colors.grey[400]
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      child: AreaDropdown(
                                        listData: snapshot.data!,
                                        inputan: area,
                                        hint: 'Wilayah',
                                        handle: setArea,
                                        disable: (value == province &&
                                                snapshot.data!.length > 2)
                                            ? false
                                            : true,
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),

                        // Devider
                        SizedBox(width: 10.0),

                        // Start Date Picker
                        InkWell(
                          onTap: () {
                            filterDataNotifier.value.clear();

                            setBeginDateByGoogle(
                              context,
                              beginDate,
                            );
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.height * 0.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.date_range_rounded),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.003,
                                ),
                                Text(
                                  beginDate == ''
                                      ? Format.tanggalFormat(
                                          DateTime.now()
                                              .subtract(Duration(days: 6))
                                              .toString()
                                              .substring(0, 10),
                                        )
                                      : Format.tanggalFormat(beginDate),
                                  style: GlobalFont.mediumgiantfontR,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Devider
                        SizedBox(width: 10.0),

                        // Dash Text
                        Text(
                          ' - ',
                          style: GlobalFont.giantfontRBold,
                        ),

                        // Devider
                        SizedBox(width: 10.0),

                        // End Date Picker
                        InkWell(
                          onTap: () {
                            filterDataNotifier.value.clear();

                            setEndDateByGoogle(
                              context,
                              endDate,
                            );
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.height * 0.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.date_range_rounded),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.003,
                                ),
                                Text(
                                  endDate == ''
                                      ? Format.tanggalFormat(
                                          DateTime.now()
                                              .toString()
                                              .substring(0, 10),
                                        )
                                      : Format.tanggalFormat(endDate),
                                  style: GlobalFont.mediumgiantfontR,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Devider
                        SizedBox(width: 10.0),

                        // Search Button
                        InkWell(
                          onTap: () {
                            getFilterData(
                              context,
                              activitiesPointState,
                            );

                            filterDataNotifier.value.clear();
                            filterDataNotifier.value.add(
                                activitiesPointState.provinceNotifier.value);
                            filterDataNotifier.value
                                .add(activitiesPointState.areaNotifier.value);
                            filterDataNotifier.value
                                .add(beginDateNotifier.value);
                            filterDataNotifier.value.add(endDateNotifier.value);
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.03,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: const Icon(
                              Icons.search_rounded,
                              size: 25.0,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        // Devider
                        SizedBox(width: 10.0),

                        // Reset Button
                        InkWell(
                          onTap: () {
                            resetData(activitiesPointState);
                            activitiesPointState.setIsReset();
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.05,
                            height: MediaQuery.of(context).size.height * 0.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              'Reset',
                              style: GlobalFont.mediumgiantfontR,
                            ),
                          ),
                        ),

                        // Devider
                        SizedBox(width: 10.0),

                        // Reset Button
                        InkWell(
                          onTap: () => context.goNamed(
                            RoutesConstant.editActivitiesPoint,
                          ),
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.05,
                            height: MediaQuery.of(context).size.height * 0.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              'Edit',
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

            // =================================================================
            // ========================== Devider ==============================
            // =================================================================
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),

            // =================================================================
            // ====================== Points in Table ==========================
            // =================================================================
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.82,
              child: ValueListenableBuilder(
                valueListenable: filterDataNotifier,
                builder: (context, value, _) {
                  // print('Data notifier: ${filterDataNotifier.value.length}');

                  if (value.isNotEmpty) {
                    // Filter Date are not empty
                    return FutureBuilder(
                      future: activitiesPointState.fetchActivitiesPoint(
                        province,
                        area,
                        beginDate,
                        endDate,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.02,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.black),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Text(
                                  'Loading...',
                                  style: GlobalFont.mediumgiantfontR,
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.02,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: Text('Data not available'),
                          );
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.02,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: ActivitiesPointTable(),
                          );
                        }
                      },
                    );
                  } else {
                    // Filter Date are empty
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02,
                        vertical: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Text('Data not available'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}