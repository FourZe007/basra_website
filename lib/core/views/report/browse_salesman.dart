import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/models/Report/mbrowse_salesman.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/autocomplete/salesman.dart';
import 'package:stsj/global/widget/dropdown/sales_status_dropdown.dart';
import 'package:stsj/global/widget/dropdown/sip_branch_dropdown.dart';
import 'package:stsj/global/widget/dropdown/sip_location_dropdown.dart';
import 'package:stsj/global/widget/dropdown/sip_shop_dropdown.dart';
import 'package:stsj/global/widget/list/salesman_list.dart';
import 'package:stsj/global/widget/static/days_converter.dart';
import 'package:stsj/global/widget/static/month_converter.dart';

import 'package:stsj/router/router_const.dart';

class BrowseSalesmanPage extends StatefulWidget {
  const BrowseSalesmanPage({super.key});

  @override
  State<BrowseSalesmanPage> createState() => _BrowseSalesmanPageState();
}

class _BrowseSalesmanPageState extends State<BrowseSalesmanPage> {
  String branch = '';
  String shop = '';
  String location = '';
  String employee = '';
  String isActive = '';
  bool isLoading = false;
  DateTimeRange selectedRangeDate = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );
  String startDate = '';
  String endDate = '';
  String formattedStartDate = '';
  String formattedEndDate = '';

  bool isLoadMasterData = false;

  void setIsLoadMasterData() {
    setState(() {
      isLoadMasterData = !isLoadMasterData;
    });
  }

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
    isActive = state.getSelectedStatus;
    state.getBrowseSalesmanList.clear();
  }

  void search(BuildContext context, MenuState state) {
    if (isLoading) {
      GlobalFunction.showSnackbar(
        context,
        'Mohon Tunggu.',
      );
    } else {
      state.setSearchTriggerNotifier(false);
      getFilter(context, state);
      state.setSearchTriggerNotifier(true);
    }
  }

  @override
  void initState() {
    super.initState();
    print(
        'Branch length: ${Provider.of<MenuState>(context, listen: false).getSipBranchNameList.length}');

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

    Widget _searchButton() => InkWell(
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
        );

    // Build the list of filter widgets
    List<Widget> filterWidgets = [
      // Branch
      Consumer<MenuState>(builder: (context, value, _) {
        return _filterDropdown(
          child: SipBranchDropdown(
            listData: value.getSipBranchNameList,
            inputan: value.getSelectedBranch,
            hint: 'Cabang',
            handle: value.getSipBranchNameList.isEmpty ? () {} : value.setSelectedBranch,
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
            inputan: value.getSelectedShop,
            hint: 'Toko',
            handle: value.getSipShopNameList.isEmpty ? () {} : value.setSelectedShop,
            branch: value.getSelectedBranch,
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
            inputan: value.getSelectedLocation,
            hint: 'Lokasi',
            handle: value.getSipLocationNameList.isEmpty ? () {} : value.setSelectedLocation,
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

      // Status
      _filterDropdown(
        child: SalesStatusDropdown(
          listData: const ['', 'Aktif', 'Tidak Aktif'],
          inputan: state.getSelectedStatus,
          hint: 'Status',
          handle: state.setSelectedStatus,
        ),
      ),
      const SizedBox(width: 8.0, height: 8.0),

      // Search button
      _searchButton(),
    ];

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
              // Filter bar — horizontal scroll on mobile, inline on desktop
              // ================================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: isMobileLayout
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "Filter" badge on top
                          Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.filter_alt_rounded,
                                    size: 14.0, color: Colors.white),
                                SizedBox(width: 6.0),
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          // Scrollable filter row
                          SizedBox(
                            height: 48,
                            child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: filterWidgets)),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // "Filter" badge
                          Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.filter_alt_rounded,
                                    size: 16.0, color: Colors.white),
                                SizedBox(width: 6.0),
                                Text(
                                  'Filter',
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
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: filterWidgets)),
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 12.0),

              // ================================================================
              // Content — data grid
              // ================================================================
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: state.getSearchTriggerNotifier,
                  builder: (context, value, _) {
                    if (value) {
                      if (state.getBrowseSalesmanList.isNotEmpty) {
                        return SalesmanList(state.getBrowseSalesmanList);
                      } else {
                        isLoading = true;
                        return FutureBuilder<Map<String, dynamic>>(
                          future: state.fetchBrowseSalesman(
                            branch,
                            shop,
                            location,
                            employee,
                            isActive == 'Aktif'
                                ? '1'
                                : isActive == 'Tidak Aktif'
                                    ? '0'
                                    : '',
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
                                  Text('Loading...', style: GlobalFont.bigfontR),
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
                                List<MBrowseSalesman> salesman =
                                    snapshot.data!['data'];
                                return SalesmanList(salesman);
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
                      if (state.getBrowseSalesmanList.isNotEmpty) {
                        return SalesmanList(state.getBrowseSalesmanList);
                      } else {
                        return const Center(child: Text('Data tidak tersedia.'));
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
