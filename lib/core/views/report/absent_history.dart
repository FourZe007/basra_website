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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobileLayout = screenWidth < 600;

    // Responsive dropdown width: at least 120px, at most 160px
    final dropdownW = (screenWidth * 0.125).clamp(120.0, 160.0);

    Widget _filterDropdown({
      required Widget child,
      Color bgColor = const Color(0xFFE2E8F0),
    }) {
      return Container(
        width: dropdownW,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: child,
      );
    }

    // Build the filter widgets list
    List<Widget> filterWidgets = [
      // Branch
      Consumer<MenuState>(builder: (context, value, _) {
        return _filterDropdown(
          child: SipBranchDropdown(
            listData: value.getSipBranchNameList,
            inputan: value.selectedBranch,
            hint: 'Cabang',
            handle: value.getSipBranchNameList.isEmpty ? () {} : state.setSelectedBranch,
            disable: value.getSipBranchNameList.isEmpty,
          ),
          bgColor: value.getSipBranchNameList.isEmpty
              ? const Color(0xFFE2E8F0)
              : const Color(0xFFE2E8F0),
        );
      }),
      const SizedBox(width: 8.0, height: 8.0),

      // Shop
      Consumer<MenuState>(builder: (context, value, _) {
        return _filterDropdown(
          child: SipShopDropdown(
            listData: value.getSipShopNameList,
            inputan: value.selectedShop,
            hint: 'Toko',
            handle: value.getSipShopNameList.isEmpty ? () {} : state.setSelectedShop,
            branch: state.getSelectedBranch,
            disable: value.getSipShopNameList.isEmpty,
          ),
          bgColor: value.getSipShopNameList.isEmpty
              ? const Color(0xFFCBD5E1)
              : const Color(0xFFE2E8F0),
        );
      }),
      const SizedBox(width: 8.0, height: 8.0),

      // Location
      Consumer<MenuState>(builder: (context, value, _) {
        return _filterDropdown(
          child: SipLocationDropdown(
            listData: value.getSipLocationNameList,
            inputan: value.selectedLocation,
            hint: 'Lokasi',
            handle: value.getSipLocationNameList.isEmpty ? () {} : state.setSelectedLocation,
            disable: value.getSipLocationNameList.isEmpty,
          ),
          bgColor: value.getSipLocationNameList.isEmpty
              ? const Color(0xFFCBD5E1)
              : const Color(0xFFE2E8F0),
        );
      }),
      const SizedBox(width: 8.0, height: 8.0),

      // Salesman autocomplete
      SalesmanAutoComplete(
        state.getSelectedSalesman,
        state.setSelectedSalesman,
      ),
      const SizedBox(width: 8.0, height: 8.0),

      // Date picker
      InkWell(
        onTap: () => pickDate(state),
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.date_range_rounded,
                  size: 16.0, color: Color(0xFF475569)),
              const SizedBox(width: 6.0),
              Text(
                '$formattedStartDate  -  $formattedEndDate',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 8.0, height: 8.0),

      // Search button
      InkWell(
        onTap: () => search(context, state),
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_rounded, size: 16.0, color: Colors.white),
              SizedBox(width: 6.0),
              Text(
                'Cari',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 8.0, height: 8.0),

      // Export button
      InkWell(
        onTap: () => showFloatingWidget(context, state),
        borderRadius: BorderRadius.circular(10.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          decoration: BoxDecoration(
            color: const Color(0xFF334155),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_rounded, size: 16.0, color: Colors.white),
              SizedBox(width: 6.0),
              Text(
                'Export',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    Widget _filterBadge({double height = 36, double fontSize = 13}) =>
        Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_alt_rounded,
                  size: fontSize - 1, color: Colors.white),
              const SizedBox(width: 6.0),
              Text(
                'Filter',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppBar(goBack: RoutesConstant.menu),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Column(
            children: [
              // ================================================================
              // Filter bar
              // ================================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: isMobileLayout
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _filterBadge(height: 32, fontSize: 12),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 48,
                            child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: filterWidgets)),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _filterBadge(),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child:
                                  SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: filterWidgets)),
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 12.0),

              // ================================================================
              // Content â€” data grid
              // ================================================================
              Expanded(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ValueListenableBuilder(
                    valueListenable: state.getSearchTriggerNotifier,
                    builder: (context, value, _) {
                      if (value) {
                        if (state.getSipSalesmanHistoryList.isNotEmpty) {
                          isLoading = false;
                          List<SipSalesmanHistoryModel> history =
                              state.getSipSalesmanHistoryList;
                          return AbsentList(history);
                        } else {
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
                                    const CircularProgressIndicator(
                                        color: Colors.black),
                                    const SizedBox(height: 10.0),
                                    Text('Loading...',
                                        style: GlobalFont.bigfontR),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                isLoading = false;
                                return const Center(
                                    child: Text('Terjadi kesalahan.'));
                              } else if (!snapshot.hasData) {
                                isLoading = false;
                                return const Center(
                                    child: Text('Data tidak tersedia.'));
                              } else {
                                isLoading = false;
                                if (snapshot.data!['status'] == 'success') {
                                  List<SipSalesmanHistoryModel> history =
                                      snapshot.data!['data'];
                                  return AbsentList(history);
                                } else {
                                  return const Center(
                                      child: Text('Data tidak tersedia.'));
                                }
                              }
                            },
                          );
                        }
                      } else {
                        isLoading = false;
                        if (state.getSipSalesmanHistoryList.isNotEmpty) {
                          List<SipSalesmanHistoryModel> history =
                              state.getSipSalesmanHistoryList;
                          return AbsentList(history);
                        } else {
                          return const Center(
                              child: Text('Data tidak tersedia.'));
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
