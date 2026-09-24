// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/area_dropdown.dart';
import 'package:stsj/global/widget/weekly_report_table.dart';
import 'package:stsj/global/widget/province_dropdown.dart';
import 'package:stsj/router/router_const.dart';

class WeeklyActivitiesReport extends StatefulWidget {
  const WeeklyActivitiesReport({super.key});

  @override
  State<WeeklyActivitiesReport> createState() => _WeeklyActivitiesReportState();
}

class _WeeklyActivitiesReportState extends State<WeeklyActivitiesReport> {
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
    province = value;
    Provider.of<MenuState>(context, listen: false).fetchAreas(value);
    Provider.of<MenuState>(context, listen: false).setAreaNotifier('');
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
      // tgl = picked.toString().substring(0, 10);
      // setBeginDate(tgl);
      if (picked.weekday == DateTime.monday) {
        tgl = picked.toString().substring(0, 10);
        setBeginDate(tgl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Day should be set to Monday'),
          ),
        );
      }
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
      if (picked.weekday == DateTime.saturday) {
        tgl = picked.toString().substring(0, 10);
        setEndDate(tgl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Day should be set to Saturday'),
          ),
        );
      }
    } else {
      // Nothing happened
    }
  }

  // Get Data from Filter for further data processing
  void getFilterData(
    BuildContext context,
    MenuState state,
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

    print('Begin Data: $beginDate');
    print('End Data: $endDate');
  }

  void findData(MenuState state) {
    if (beginDate == '' && endDate == '') {
      beginDate = DateTime.now()
          .subtract(Duration(days: 5))
          .toString()
          .substring(0, 10);
      endDate = DateTime.now().toString().substring(0, 10);
    }

    // print('Begin Date: $beginDate');
    // print('End Date: $endDate');
    // print(
    //   'Date Difference in Days: ${DateTime.parse(endDate).difference(DateTime.parse(beginDate)).inDays}',
    // );

    if (DateTime.parse(endDate).difference(DateTime.parse(beginDate)).inDays ==
        5) {
      getFilterData(context, state);

      filterDataNotifier.value.clear();
      filterDataNotifier.value.add(state.provinceNotifier.value);
      filterDataNotifier.value.add(state.areaNotifier.value);
      filterDataNotifier.value.add(beginDateNotifier.value);
      filterDataNotifier.value.add(endDateNotifier.value);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dates must be set with a difference of 5 days',
          ),
        ),
      );
    }
  }

  // Reset Data from Filter to easily remove all current filter
  void resetData(
    MenuState state,
  ) {
    // print('Reset Data');
    print('Province before: $province');
    setState(() {
      province = '';
      area = '';
      beginDate = '';
      endDate = '';
      state.provinceNotifier.value = '';
      state.areaNotifier.value = '';
      beginDateNotifier.value = '';
      endDateNotifier.value = '';
      filterDataNotifier.value.clear();
    });
    print('Province after: $province');
  }

  @override
  void initState() {
    super.initState();

    Provider.of<MenuState>(context, listen: false).loadProvinces();
  }

  Widget computerView(BuildContext context) {
    final state = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
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
                  curve: state.isFilterOpen ? Curves.easeInOut : Curves.easeIn,
                  child: SizedBox(
                    // Note -> used for slide in and slide out animation
                    // but it didn't work because maybe it's a web based program
                    width: state.isFilterOpen
                        ? MediaQuery.of(context).size.width * 0.65
                        : 0.0,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Wrap(
                      spacing: 10.0,
                      children: [
                        // Area Dropdown
                        Consumer<MenuState>(
                          builder: (context, value, child) {
                            if (value.getProvinceList.isEmpty) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width:
                                    MediaQuery.of(context).size.width * 0.125,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.01,
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                child: ProvinceDropdown(
                                  listData: const [],
                                  inputan: '',
                                  hint: 'Provinsi',
                                  handle: () {},
                                  disable: true,
                                ),
                              );
                            } else {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width:
                                    MediaQuery.of(context).size.width * 0.125,
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
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                child: ProvinceDropdown(
                                  listData: value.getProvinceList,
                                  inputan: province,
                                  hint: 'Provinsi',
                                  handle: setProvince,
                                  disable: false,
                                ),
                              );
                            }
                          },
                        ),

                        // Wilayah Dropdown
                        ValueListenableBuilder(
                          valueListenable: state.provinceNotifier,
                          builder: (context, value, child) {
                            if (value == '') {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width:
                                    MediaQuery.of(context).size.width * 0.125,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.01,
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                child: AreaDropdown(
                                  listData: const [],
                                  inputan: '',
                                  hint: 'Wilayah',
                                  handle: () {},
                                  disable: true,
                                ),
                              );
                            } else {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width:
                                    MediaQuery.of(context).size.width * 0.125,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: (state.getAreaList.length > 1 &&
                                          province != '')
                                      ? Colors.grey[400]
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.01,
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                child: AreaDropdown(
                                  listData: state.getAreaList,
                                  inputan: area,
                                  hint: 'Wilayah',
                                  handle: setArea,
                                  disable: (value == province &&
                                          province != '' &&
                                          state.getAreaList.length > 1)
                                      ? false
                                      : true,
                                ),
                              );
                            }
                          },
                        ),

                        // Start Date Picker
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: InkWell(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.date_range_rounded),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.003,
                                  ),
                                  Text(
                                    beginDate == ''
                                        ? Format.tanggalFormat(
                                            DateTime.now()
                                                .subtract(Duration(days: 5))
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
                        ),

                        // Dash Text
                        Container(
                          width: MediaQuery.of(context).size.width * 0.008,
                          height: MediaQuery.of(context).size.height * 0.05,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ' - ',
                            style: GlobalFont.giantfontRBold,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // End Date Picker
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: InkWell(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.date_range_rounded),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.003,
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
                        ),

                        // Search Button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                          child: InkWell(
                            onTap: () => findData(state),
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
                        ),

                        // Reset Button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: InkWell(
                            onTap: () {
                              resetData(state);
                              state.setIsReset();
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
            // ====================== Report in Table ==========================
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
                      future: state.fetchWeeklyReport(
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
                          return Center(
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
                            child: WeeklyReportTable(),
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

  Widget mobileView(BuildContext context, double deviceWidth) {
    final state = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (deviceWidth <= 450)
              ? MediaQuery.of(context).size.height * 0.055
              : MediaQuery.of(context).size.height * 0.085,
        ),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
          imageSize: 35,
          profileRadius: 15,
          returnButtonSize: 20,
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: (deviceWidth <= 450)
                  ? MediaQuery.of(context).size.height * 0.0425
                  : 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
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
                            size: 17.5,
                            color: Colors.black,
                          ),
                          Text(
                            'Filter',
                            style: GlobalFont.mediumbigfontM,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Devider
                  SizedBox(width: 5.0),

                  // Filter's Expand and Collapse Animation
                  AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    reverseDuration: const Duration(milliseconds: 500),
                    curve:
                        state.isFilterOpen ? Curves.easeInOut : Curves.easeIn,
                    child: SizedBox(
                      // Note -> used for slide in and slide out animation
                      // but it didn't work because maybe it's a web based program
                      // width: state.isFilterOpen
                      //     ? MediaQuery.of(context).size.width * 0.65
                      //     : 0.0,
                      // height: MediaQuery.of(context).size.height * 0.05,
                      child: Wrap(
                        spacing: 10.0,
                        children: [
                          // Area Dropdown
                          Consumer<MenuState>(
                            builder: (context, value, child) {
                              if (value.getProvinceList.isEmpty) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: (deviceWidth <= 450)
                                      ? MediaQuery.of(context).size.width * 0.3
                                      : MediaQuery.of(context).size.width *
                                          0.16,
                                  height: (deviceWidth <= 450)
                                      ? MediaQuery.of(context).size.height *
                                          0.0425
                                      : MediaQuery.of(context).size.height *
                                          0.065,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.01,
                                  ),
                                  child: ProvinceDropdown(
                                    listData: const [],
                                    inputan: '',
                                    hint: 'Provinsi',
                                    handle: () {},
                                    disable: true,
                                    isMobile: true,
                                  ),
                                );
                              } else {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: (deviceWidth <= 450)
                                      ? MediaQuery.of(context).size.width * 0.3
                                      : MediaQuery.of(context).size.width *
                                          0.16,
                                  height: (deviceWidth <= 450)
                                      ? MediaQuery.of(context).size.height *
                                          0.0425
                                      : MediaQuery.of(context).size.height *
                                          0.065,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.01,
                                  ),
                                  child: ProvinceDropdown(
                                    listData: value.getProvinceList,
                                    inputan: province,
                                    hint: 'Provinsi',
                                    handle: setProvince,
                                    disable: false,
                                    isMobile: true,
                                  ),
                                );
                              }
                            },
                          ),

                          // Wilayah Dropdown
                          ValueListenableBuilder(
                            valueListenable: state.provinceNotifier,
                            builder: (context, value, child) {
                              if (value == '') {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: (deviceWidth <= 450)
                                      ? MediaQuery.of(context).size.width * 0.3
                                      : MediaQuery.of(context).size.width *
                                          0.16,
                                  height: (deviceWidth <= 450)
                                      ? MediaQuery.of(context).size.height *
                                          0.0425
                                      : MediaQuery.of(context).size.height *
                                          0.065,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
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
                                    listData: const [],
                                    inputan: '',
                                    hint: 'Wilayah',
                                    handle: () {},
                                    disable: true,
                                    isMobile: true,
                                  ),
                                );
                              } else {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: (deviceWidth <= 450)
                                      ? MediaQuery.of(context).size.width * 0.3
                                      : MediaQuery.of(context).size.width *
                                          0.16,
                                  height: (deviceWidth <= 450)
                                      ? MediaQuery.of(context).size.height *
                                          0.0425
                                      : MediaQuery.of(context).size.height *
                                          0.065,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: (state.getAreaList.length > 1 &&
                                            province != '')
                                        ? Colors.grey[400]
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
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
                                    listData: state.getAreaList,
                                    inputan: area,
                                    hint: 'Wilayah',
                                    handle: setArea,
                                    disable: (value == province &&
                                            province != '' &&
                                            state.getAreaList.length > 1)
                                        ? false
                                        : true,
                                    isMobile: true,
                                  ),
                                );
                              }
                            },
                          ),

                          // Start Date Picker
                          SizedBox(
                            child: InkWell(
                              onTap: () {
                                filterDataNotifier.value.clear();

                                setBeginDateByGoogle(
                                  context,
                                  beginDate,
                                );
                              },
                              child: Container(
                                // width: MediaQuery.of(context).size.width * 0.1,
                                height: (deviceWidth <= 450)
                                    ? MediaQuery.of(context).size.height *
                                        0.0425
                                    : MediaQuery.of(context).size.height *
                                        0.065,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.date_range_rounded,
                                      size: 17.5,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.003,
                                    ),
                                    Text(
                                      beginDate == ''
                                          ? Format.tanggalFormat(
                                              DateTime.now()
                                                  .subtract(Duration(days: 5))
                                                  .toString()
                                                  .substring(0, 10),
                                            )
                                          : Format.tanggalFormat(beginDate),
                                      style: GlobalFont.mediumbigfontR,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Dash Text
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.008,
                            // height: MediaQuery.of(context).size.height * 0.05,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ' - ',
                              style: GlobalFont.giantfontRBold,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // End Date Picker
                          SizedBox(
                            child: InkWell(
                              onTap: () {
                                filterDataNotifier.value.clear();

                                setEndDateByGoogle(
                                  context,
                                  endDate,
                                );
                              },
                              child: Container(
                                // width: MediaQuery.of(context).size.width * 0.1,
                                height: (deviceWidth <= 450)
                                    ? MediaQuery.of(context).size.height *
                                        0.0425
                                    : MediaQuery.of(context).size.height *
                                        0.065,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.date_range_rounded,
                                      size: 17.5,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.003,
                                    ),
                                    Text(
                                      endDate == ''
                                          ? Format.tanggalFormat(
                                              DateTime.now()
                                                  .toString()
                                                  .substring(0, 10),
                                            )
                                          : Format.tanggalFormat(endDate),
                                      style: GlobalFont.mediumbigfontR,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Search Button
                          SizedBox(
                            child: InkWell(
                              onTap: () => findData(state),
                              child: Container(
                                // width: MediaQuery.of(context).size.width * 0.03,
                                height: (deviceWidth <= 450)
                                    ? MediaQuery.of(context).size.height *
                                        0.0425
                                    : MediaQuery.of(context).size.height *
                                        0.065,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: const Icon(
                                  Icons.search_rounded,
                                  size: 17.5,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          // Reset Button
                          SizedBox(
                            child: InkWell(
                              onTap: () {
                                resetData(state);
                                state.setIsReset();
                              },
                              child: Container(
                                // width: MediaQuery.of(context).size.width * 0.05,
                                height: (deviceWidth <= 450)
                                    ? MediaQuery.of(context).size.height *
                                        0.0425
                                    : MediaQuery.of(context).size.height *
                                        0.065,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(
                                  'Reset',
                                  style: GlobalFont.mediumbigfontR,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            // =================================================================
            // ========================== Devider ==============================
            // =================================================================
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),

            // =================================================================
            // ====================== Report in Table ==========================
            // =================================================================
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.785,
              child: ValueListenableBuilder(
                valueListenable: filterDataNotifier,
                builder: (context, value, _) {
                  // print('Data notifier: ${filterDataNotifier.value.length}');

                  if (value.isNotEmpty) {
                    // Filter Date are not empty
                    return FutureBuilder(
                      future: state.fetchWeeklyReport(
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
                          return Center(
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
                            child: WeeklyReportTable(),
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return computerView(context);
        } else {
          return mobileView(context, constraints.maxWidth);
        }
      },
    );
  }
}
