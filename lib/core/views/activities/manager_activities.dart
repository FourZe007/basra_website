// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/area_dropdown.dart';
import 'package:stsj/global/widget/four_container.dart';
import 'package:stsj/global/widget/province_dropdown.dart';
import 'package:stsj/router/router_const.dart';

class ManagerActivitiesPage extends StatefulWidget {
  const ManagerActivitiesPage({super.key});

  @override
  State<ManagerActivitiesPage> createState() => _ManagerActivitiesPageState();
}

class _ManagerActivitiesPageState extends State<ManagerActivitiesPage> {
  String province = '';
  String area = '';
  String date = '';
  ValueNotifier<String> dateNotifier = ValueNotifier('');
  ValueNotifier<List<String>> filterDataNotifier = ValueNotifier([]);

  String get getProvince => province;

  String get getArea => area;

  String get getDate => date;

  void setProvince(String value) {
    province = value;
    Provider.of<MenuState>(context, listen: false).fetchAreas(value);
    Provider.of<MenuState>(context, listen: false).setAreaNotifier('');
  }

  void setArea(String value) {
    area = value;
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
    );

    if (picked != null && picked != DateTime.parse(tgl)) {
      tgl = picked.toString().substring(0, 10);
      setDate(tgl);
    } else {
      // Nothing happened
    }
  }

  void previewImage(String value) {
    GlobalFunction.tampilkanDialog(
      context,
      true,
      Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.55,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: PhotoView(
                maxScale: PhotoViewComputedScale.covered * 2,
                minScale: PhotoViewComputedScale.contained,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                imageProvider: MemoryImage(
                  base64Decode(value),
                ),
              ),
            ),
            Text('Press anywhere to dismiss'),
          ],
        ),
      ),
    );
  }

  void getFilterData(
    BuildContext context,
    MenuState managerActivitiesState,
  ) {
    setState(() {
      managerActivitiesState.provinceNotifier.value = province;
      managerActivitiesState.areaNotifier.value = area;

      if (date == '') {
        setDate(
          DateTime.now().toString().substring(0, 10),
        );
        dateNotifier.value = date;
      } else {
        dateNotifier.value = date;
      }
    });
  }

  void resetData(
    MenuState managerActivitiesState,
  ) {
    print('Reset Data');
    setState(() {
      setProvince('');
      area = '';
      date = '';
      managerActivitiesState.provinceNotifier.value = '';
      managerActivitiesState.areaNotifier.value = '';
      dateNotifier.value = '';
      filterDataNotifier.value.clear();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
            // =================================================================
            // =========================== Filter ==============================
            // =================================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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

                SizedBox(width: 10.0),

                // Filter's Expand and Collapse Animation
                AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  reverseDuration: const Duration(milliseconds: 500),
                  curve: state.isFilterOpen ? Curves.easeInOut : Curves.easeIn,
                  child: SizedBox(
                    // width: state.isFilterOpen
                    //     ? MediaQuery.of(context).size.width * 0.5
                    //     : 0.0,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Wrap(
                      spacing: 10.0,
                      children: [
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
                        // SizedBox(width: 10.0),
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.1,
                          child: InkWell(
                            onTap: () {
                              filterDataNotifier.value.clear();

                              setDateByGoogle(
                                context,
                                date,
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
                                    date == ''
                                        ? Format.tanggalFormat(
                                            DateTime.now()
                                                .toString()
                                                .substring(0, 10),
                                          )
                                        : Format.tanggalFormat(date),
                                    style: GlobalFont.mediumgiantfontR,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(width: 10.0),
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.03,
                          child: InkWell(
                            onTap: () {
                              getFilterData(
                                context,
                                state,
                              );

                              filterDataNotifier.value.clear();
                              filterDataNotifier.value
                                  .add(state.provinceNotifier.value);
                              filterDataNotifier.value
                                  .add(state.areaNotifier.value);
                              filterDataNotifier.value.add(dateNotifier.value);

                              // print(
                              //   'Filter Data length: ${filterDataNotifier.value.length}',
                              // );
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
                        ),
                        // SizedBox(width: 10.0),
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.05,
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
            // ====================== Routes List View =========================
            // =================================================================
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.82,
              child: ValueListenableBuilder(
                valueListenable: filterDataNotifier,
                builder: (context, value, child) {
                  if (value.isNotEmpty) {
                    String filterProvince = value[0];
                    String filterArea = value[1];
                    String filterDate = value[2];

                    return FutureBuilder(
                      future: state.fetchManagerActivities(
                        filterProvince,
                        filterArea,
                        filterDate,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.82,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.black,
                                ),
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
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.width * 0.01,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.01,
                            ),
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.82,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text('Data not available'),
                          );
                        } else {
                          return FourContainer(
                            snapshot.data![0],
                            snapshot.data![1],
                            snapshot.data![2],
                            snapshot.data![3],
                            filterDate,
                          );
                        }
                      },
                    );
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.82,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text('Data are not available'),
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
            // =================================================================
            // =========================== Filter ==============================
            // =================================================================
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: (deviceWidth <= 450)
                  ? MediaQuery.of(context).size.height * 0.0425
                  : 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
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

                  SizedBox(width: 5.0),

                  // Filter's Expand and Collapse Animation
                  AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    reverseDuration: const Duration(milliseconds: 500),
                    curve:
                        state.isFilterOpen ? Curves.easeInOut : Curves.easeIn,
                    child: SizedBox(
                      // width: state.isFilterOpen
                      //     ? MediaQuery.of(context).size.width * 0.5
                      //     : 0.0,
                      // height: 56,
                      child: Wrap(
                        spacing: 10.0,
                        children: [
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
                          SizedBox(
                            child: InkWell(
                              onTap: () {
                                filterDataNotifier.value.clear();

                                setDateByGoogle(
                                  context,
                                  date,
                                );
                              },
                              child: Container(
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
                                      date == ''
                                          ? Format.tanggalFormat(
                                              DateTime.now()
                                                  .toString()
                                                  .substring(0, 10),
                                            )
                                          : Format.tanggalFormat(date),
                                      style: GlobalFont.mediumbigfontR,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: InkWell(
                              onTap: () {
                                getFilterData(
                                  context,
                                  state,
                                );

                                filterDataNotifier.value.clear();
                                filterDataNotifier.value
                                    .add(state.provinceNotifier.value);
                                filterDataNotifier.value
                                    .add(state.areaNotifier.value);
                                filterDataNotifier.value
                                    .add(dateNotifier.value);
                              },
                              child: Container(
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
                          SizedBox(
                            child: InkWell(
                              onTap: () {
                                resetData(state);
                                state.setIsReset();
                              },
                              child: Container(
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
            // ====================== Routes List View =========================
            // =================================================================
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.785,
              child: ValueListenableBuilder(
                valueListenable: filterDataNotifier,
                builder: (context, value, child) {
                  if (value.isNotEmpty) {
                    String filterProvince = value[0];
                    String filterArea = value[1];
                    String filterDate = value[2];

                    return FutureBuilder(
                      future: state.fetchManagerActivities(
                        filterProvince,
                        filterArea,
                        filterDate,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.82,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20.0, // Set the desired width
                                  height: 20.0, // Set the desired height
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
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.width * 0.01,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.01,
                            ),
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              'Data not available',
                              style: GlobalFont.smallfontR,
                            ),
                          );
                        } else {
                          return FourContainer(
                            snapshot.data![0],
                            snapshot.data![1],
                            snapshot.data![2],
                            snapshot.data![3],
                            filterDate,
                            isMobile: true,
                            deviceWidth: deviceWidth,
                          );
                        }
                      },
                    );
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Data not available',
                        style: GlobalFont.smallfontR,
                      ),
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
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 1024) {
        return computerView(context);
      } else {
        return mobileView(context, constraints.maxWidth);
      }
    });
  }
}
