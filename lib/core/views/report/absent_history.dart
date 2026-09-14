import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/models/Report/absent_history.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/autocomplete/salesman.dart';
import 'package:stsj/global/widget/dropdown/sip_branch_dropdown.dart';
import 'package:stsj/global/widget/dropdown/sip_location_dropdown.dart';
import 'package:stsj/global/widget/dropdown/sip_shop_dropdown.dart';
import 'package:stsj/global/widget/list/absent_list.dart';
import 'package:stsj/global/widget/static/days_converter.dart';
import 'package:stsj/global/widget/static/month_converter.dart';
import 'package:stsj/router/router_const.dart';

class AbsentHistoryPage extends StatefulWidget {
  const AbsentHistoryPage({super.key});

  @override
  State<AbsentHistoryPage> createState() => _AbsentHistoryPageState();
}

class _AbsentHistoryPageState extends State<AbsentHistoryPage> {
  String userId = '';
  String branch = '';
  String shop = '';
  String location = '';
  String employee = '';
  String startDate = '';
  String endDate = '';
  String formattedStartDate = '';
  String formattedEndDate = '';
  DateTimeRange selectedRangeDate = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );

  bool isLoading = false;
  bool isHover = false;

  void preprocessingDate() {
    final startDay = selectedRangeDate.start;
    final endDay = selectedRangeDate.end;
    final tempStartDate =
        '${startDay.day} ${MonthConverter.getMonthAbbrFromInt(startDay.month)}';
    final tempEndDate =
        '${endDay.day} ${MonthConverter.getMonthAbbrFromInt(endDay.month)}';

    startDate = selectedRangeDate.start.toString().split(' ')[0];
    endDate = selectedRangeDate.end.toString().split(' ')[0];
    formattedStartDate =
        '${DaysConverter.switchDays(startDay.weekday)}, $tempStartDate';
    formattedEndDate =
        '${DaysConverter.switchDays(endDay.weekday)}, $tempEndDate';
  }

  Future<void> pickDate(MenuState state) async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime(2100), // Latest selectable date
      initialDateRange: selectedRangeDate, // Previously selected range
      saveText: 'Done', // Text for the save button
    );

    if (pickedDateRange != null) {
      setState(() {
        selectedRangeDate = pickedDateRange;
        preprocessingDate();
      });

      state.setSearchTriggerNotifier(false);
    }
  }

  void getFilter(BuildContext context, MenuState state) {
    branch = state.getSelectedBranch;
    print('Selected Branch: ${state.getSelectedBranch}');
    shop = state.getSelectedShop;
    location = state.getSelectedLocation;
    employee = state.getSelectedSalesman;
    state.sipSalesmanHistoryList.clear();
  }

  void search(BuildContext context, MenuState state) {
    // ~:Prevent user press the search button multiple times:~
    if (isLoading) {
      GlobalFunction.showSnackbar(
        context,
        'Mohon Tunggu.',
      );
    } else {
      state.setSearchTriggerNotifier(false);
      getFilter(context, state);
      state.setSearchTriggerNotifier(true);

      print('Branch: $branch');
      print('Shop: $shop');
      print('Location: $location');
      print('Employee: $employee');
      print('Start date: $startDate');
      print('End date: $endDate');
      // if (state.getSelectedBranch.isEmpty) {
      //   GlobalFunction.showSnackbar(
      //     context,
      //     'Mohon periksa kembali filter cabang anda.',
      //   );
      // } else {
      //   state.setSearchTriggerNotifier(false);
      //   getFilter(context, state);
      //   state.setSearchTriggerNotifier(true);
      // }
    }
  }

  void exportHistory(
    MenuState state,
    String branch,
    String shop,
    String location,
    String employee,
    String startDate,
    String endDate, {
    bool isAttendance = false,
  }) {
    if (isAttendance) {
      state.getExportData(
        'ATTENDANCE HISTORY',
        branch,
        shop,
        location,
        employee,
        startDate,
        endDate,
      );
    } else {
      state.getExportData(
        'REKAP UANG MAKAN/TRANSPORT',
        branch,
        shop,
        location,
        employee,
        startDate,
        endDate,
      );
    }
  }

  // Function to show the floating popup
  void showFloatingWidget(
    BuildContext context,
    MenuState state,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero, // Remove default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Container(
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Make the dialog compact
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Jenis Laporan'),
                ),
                ListTile(
                  title: Text('Absensi'),
                  onTap: () {
                    print('Absensi selected');
                    exportHistory(
                      state,
                      branch,
                      shop,
                      location,
                      employee,
                      startDate,
                      endDate,
                      isAttendance: true,
                    );
                    Navigator.pop(context); // Close the dialog
                  },
                ),
                ListTile(
                  title: Text('Uang Makan & Transport'),
                  onTap: () {
                    print('Uang Makan selected');
                    exportHistory(
                      state,
                      branch,
                      shop,
                      location,
                      employee,
                      startDate,
                      endDate,
                    );
                    Navigator.pop(context); // Close the dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<MenuState>(context, listen: false).resetAbsentHistory();
    preprocessingDate();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.01,
            right: MediaQuery.of(context).size.width * 0.01,
            top: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Column(
            children: [
              // ==================================================================
              // =========================== Filter ===============================
              // ==================================================================
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Filter Title
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

                    // Filter Content
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            // ~:Branch:~
                            Consumer<MenuState>(
                              builder: (context, value, _) {
                                if (value.getSipBranchNameList.isEmpty) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: MediaQuery.of(context).size.width *
                                        0.125,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
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
                                    child: SipBranchDropdown(
                                      listData: const [],
                                      inputan: '',
                                      hint: 'Cabang',
                                      handle: () {},
                                      disable: true,
                                    ),
                                  );
                                } else {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: MediaQuery.of(context).size.width *
                                        0.125,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
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
                                    child: SipBranchDropdown(
                                      listData: value.getSipBranchNameList,
                                      inputan: value.selectedBranch,
                                      hint: 'Cabang',
                                      handle: state.setSelectedBranch,
                                      disable: false,
                                    ),
                                  );
                                }
                              },
                            ),

                            // ~:Devider:~
                            SizedBox(width: 10.0),

                            // ~:Shop:~
                            Consumer<MenuState>(
                              builder: (context, value, _) {
                                if (value.getSipShopNameList.isEmpty) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: MediaQuery.of(context).size.width *
                                        0.125,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
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
                                    child: SipShopDropdown(
                                      listData: const [],
                                      inputan: '',
                                      hint: 'Toko',
                                      handle: () {},
                                      branch: '',
                                      disable: true,
                                    ),
                                  );
                                } else {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: MediaQuery.of(context).size.width *
                                        0.125,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
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
                                    child: SipShopDropdown(
                                      listData: value.getSipShopNameList,
                                      inputan: value.selectedShop,
                                      hint: 'Toko',
                                      handle: state.setSelectedShop,
                                      branch: state.getSelectedBranch,
                                      disable: false,
                                    ),
                                  );
                                }
                              },
                            ),

                            // ~:Devider:~
                            SizedBox(width: 10.0),

                            // ~:Location:~
                            Consumer<MenuState>(
                              builder: (context, value, _) {
                                if (value.getSipLocationNameList.isEmpty) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: MediaQuery.of(context).size.width *
                                        0.125,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
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
                                    child: SipLocationDropdown(
                                      listData: const [],
                                      inputan: '',
                                      hint: 'Lokasi',
                                      handle: () {},
                                      disable: true,
                                    ),
                                  );
                                } else {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: MediaQuery.of(context).size.width *
                                        0.125,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
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
                                    child: SipLocationDropdown(
                                      listData: value.getSipLocationNameList,
                                      inputan: value.selectedLocation,
                                      hint: 'Lokasi',
                                      handle: state.setSelectedLocation,
                                      disable: false,
                                    ),
                                  );
                                }
                              },
                            ),

                            // ~:Devider:~
                            SizedBox(width: 10.0),

                            // ~:Salesman Autocomplete:~
                            SalesmanAutoComplete(
                              state.getSelectedSalesman,
                              state.setSelectedSalesman,
                            ),

                            // ~:Devider:~
                            SizedBox(width: 10.0),

                            // ~:Date:~
                            InkWell(
                              onTap: () => pickDate(state),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
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
                                      '$formattedStartDate to $formattedEndDate',
                                      style: GlobalFont.mediumgiantfontR,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ~:Devider:~
                            SizedBox(width: 10.0),

                            // ~:Search Button:~
                            InkWell(
                              onTap: () => search(context, state),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
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

                            // ~:Devider:~
                            SizedBox(width: 10.0),

                            // ~:Reset Button is Under Development:~
                            // InkWell(
                            //   onTap: () => state.resetAbsentHistory(),
                            //   child: Container(
                            //     height:
                            //         MediaQuery.of(context).size.height * 0.05,
                            //     alignment: Alignment.center,
                            //     decoration: BoxDecoration(
                            //       color: Colors.grey[400],
                            //       borderRadius: BorderRadius.circular(15.0),
                            //     ),
                            //     padding: EdgeInsets.symmetric(horizontal: 10.0),
                            //     child: Text(
                            //       'Reset',
                            //       style: GlobalFont.mediumgiantfontR,
                            //     ),
                            //   ),
                            // ),
                            //
                            // ~:Devider:~
                            // SizedBox(width: 10.0),

                            // ~:Export to Download Button:~
                            InkWell(
                              onTap: () => showFloatingWidget(context, state),
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'Export',
                                  style: GlobalFont.mediumgiantfontR,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
              // ========================== Content ==============================
              // =================================================================
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: ValueListenableBuilder(
                    valueListenable: state.getSearchTriggerNotifier,
                    builder: (context, value, _) {
                      if (value) {
                        // print('Widget searchTrigger true');
                        if (state.getSipSalesmanHistoryList.isNotEmpty) {
                          isLoading = false;
                          // print('Data available');
                          List<SipSalesmanHistoryModel> history =
                              state.getSipSalesmanHistoryList;

                          return AbsentList(history);
                        } else {
                          // print('Data not available, fetching data');
                          isLoading = true;
                          return FutureBuilder<Map<String, dynamic>>(
                            future: state.fetchSipSalesmanHistory(
                              branch,
                              shop,
                              location,
                              employee,
                              startDate,
                              endDate,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                isLoading = false;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      'Loading...',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                isLoading = false;
                                return Center(
                                  child: Text('Terjadi kesalahan.'),
                                );
                              } else if (!snapshot.hasData) {
                                isLoading = false;
                                return Center(
                                  child: Text('Data tidak tersedia.'),
                                );
                              } else {
                                isLoading = false;
                                if (snapshot.data!['status'] == 'success') {
                                  List<SipSalesmanHistoryModel> history =
                                      snapshot.data!['data'];

                                  return AbsentList(history);
                                } else {
                                  if (snapshot.data!['status'] == 'failed') {
                                    return Center(
                                      child: Text('Data tidak tersedia.'),
                                    );
                                  } else {
                                    return Center(
                                      child: Text('Terjadi kesalahan.'),
                                    );
                                  }
                                }
                              }
                            },
                          );
                        }
                      } else {
                        isLoading = false;
                        // print('Widget searchTrigger false');
                        if (state.getSipSalesmanHistoryList.isNotEmpty) {
                          // print('Data available');
                          List<SipSalesmanHistoryModel> history =
                              state.getSipSalesmanHistoryList;

                          return AbsentList(history);
                        } else {
                          return Center(
                            child: Text('Data tidak tersedia.'),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
