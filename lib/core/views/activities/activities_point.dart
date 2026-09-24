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
        ? DateTime.now().subtract(Duration(days: 7)).toString().substring(0, 10)
        : tgl;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == ''
          ? DateTime.now().subtract(Duration(days: 7))
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
          DateTime.now().toString().substring(0, 10),
        );
        endDateNotifier.value = endDate;
      } else {
        endDateNotifier.value = endDate;
      }
    });
  }

  void findData(MenuState state) {
    getFilterData(context, state);

    filterDataNotifier.value.clear();
    filterDataNotifier.value.add(state.provinceNotifier.value);
    filterDataNotifier.value.add(state.areaNotifier.value);
    filterDataNotifier.value.add(beginDateNotifier.value);
    filterDataNotifier.value.add(endDateNotifier.value);
  }

  void resetData(
    MenuState state,
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

  Widget computerView(BuildContext context, double deviceWidth) {
    final state = Provider.of<MenuState>(context);
    print('Device Width: $deviceWidth');

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
                    // width: state.isFilterOpen
                    //     ? MediaQuery.of(context).size.width * 0.5
                    //     : 0.0,
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
                                              .subtract(Duration(days: 7))
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

                        // Dash Text
                        Text(
                          ' - ',
                          style: GlobalFont.giantfontRBold,
                        ),

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

                        // Search Button
                        InkWell(
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

                        // Reset Button
                        InkWell(
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
                      future: state.fetchActivitiesPoint(
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
                        } else if (!snapshot.hasData) {
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

  Widget mobileView(BuildContext context, double deviceWidth) {
    final state = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0
            // (deviceWidth <= 450)
            //     ? MediaQuery.of(context).size.height * 0.055
            //     : MediaQuery.of(context).size.height * 0.085,
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
                      height: (deviceWidth <= 450)
                          ? MediaQuery.of(context).size.height * 0.0425
                          : 56,
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
                      //     ? MediaQuery.of(context).size.width * 0.5
                      //     : 0.0,
                      // height: 56,
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
                          InkWell(
                            onTap: () {
                              filterDataNotifier.value.clear();

                              setBeginDateByGoogle(
                                context,
                                beginDate,
                              );
                            },
                            child: Container(
                              height: (deviceWidth <= 450)
                                  ? MediaQuery.of(context).size.height * 0.0425
                                  : 56,
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
                                                .subtract(Duration(days: 7))
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

                          // Dash Text
                          SizedBox(
                            height: (deviceWidth <= 450)
                                ? MediaQuery.of(context).size.height * 0.0425
                                : 56,
                            child: Text(
                              ' - ',
                              style: GlobalFont.giantfontRBold,
                            ),
                          ),

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
                              height: (deviceWidth <= 450)
                                  ? MediaQuery.of(context).size.height * 0.0425
                                  : 56,
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

                          // Search Button
                          InkWell(
                            onTap: () => findData(state),
                            child: Container(
                              height: (deviceWidth <= 450)
                                  ? MediaQuery.of(context).size.height * 0.0425
                                  : 56,
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

                          // Reset Button
                          InkWell(
                            onTap: () {
                              resetData(state);
                              state.setIsReset();
                            },
                            child: Container(
                              height: (deviceWidth <= 450)
                                  ? MediaQuery.of(context).size.height * 0.0425
                                  : 56,
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

                          // Reset Button
                          InkWell(
                            onTap: () => context.goNamed(
                              RoutesConstant.editActivitiesPoint,
                            ),
                            child: Container(
                              height: (deviceWidth <= 450)
                                  ? MediaQuery.of(context).size.height * 0.0425
                                  : 56,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'Edit',
                                style: GlobalFont.mediumbigfontR,
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
            // ====================== Points in Table ==========================
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
                      future: state.fetchActivitiesPoint(
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
                                SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 3.0,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
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
                        } else if (!snapshot.hasData) {
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
                            child: ActivitiesPointTable(
                              isMobile: true,
                            ),
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
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<MenuState>(context, listen: false).loadProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return computerView(context, constraints.maxWidth);
        } else {
          return mobileView(context, constraints.maxWidth);
        }
      },
    );
  }
}
