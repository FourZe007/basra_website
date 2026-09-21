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
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Filter Badge
                      Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.filter_alt_rounded,
                              size: 16.0,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6.0),
                            const Text(
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

                      // Filter Content
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              // ~:Branch:~
                              Consumer<MenuState>(
                                builder: (context, value, _) {
                                  if (value.getSipBranchNameList.isEmpty) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      width: MediaQuery.of(context).size.width *
                                          0.125,
                                      height: 36,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE2E8F0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
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
                                      duration:
                                          const Duration(milliseconds: 500),
                                      width: MediaQuery.of(context).size.width *
                                          0.125,
                                      height: 36,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE2E8F0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      child: SipBranchDropdown(
                                        listData: value.getSipBranchNameList,
                                        inputan: value.getSelectedBranch,
                                        hint: 'Cabang',
                                        handle: value.setSelectedBranch,
                                        disable: false,
                                      ),
                                    );
                                  }
                                },
                              ),

                              const SizedBox(width: 8.0),

                              // ~:Shop:~
                              Consumer<MenuState>(
                                builder: (context, value, _) {
                                  if (value.getSipShopNameList.isEmpty) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      width: MediaQuery.of(context).size.width *
                                          0.125,
                                      height: 36,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFCBD5E1),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
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
                                      duration:
                                          const Duration(milliseconds: 500),
                                      width: MediaQuery.of(context).size.width *
                                          0.125,
                                      height: 36,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE2E8F0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      child: SipShopDropdown(
                                        listData: value.getSipShopNameList,
                                        inputan: value.getSelectedShop,
                                        hint: 'Toko',
                                        handle: value.setSelectedShop,
                                        branch: value.getSelectedBranch,
                                        disable: false,
                                      ),
                                    );
                                  }
                                },
                              ),

                              const SizedBox(width: 8.0),

                              // ~:Location:~
                              Consumer<MenuState>(
                                builder: (context, value, _) {
                                  if (value.getSipLocationNameList.isEmpty) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      width: MediaQuery.of(context).size.width *
                                          0.125,
                                      height: 36,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFCBD5E1),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
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
                                      duration:
                                          const Duration(milliseconds: 500),
                                      width: MediaQuery.of(context).size.width *
                                          0.125,
                                      height: 36,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE2E8F0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      child: SipLocationDropdown(
                                        listData: value.getSipLocationNameList,
                                        inputan: value.getSelectedLocation,
                                        hint: 'Lokasi',
                                        handle: value.setSelectedLocation,
                                        disable: false,
                                      ),
                                    );
                                  }
                                },
                              ),

                              const SizedBox(width: 8.0),

                              // ~:Salesman Autocomplete:~
                              SalesmanAutoComplete(
                                state.getSelectedSalesman,
                                state.setSelectedSalesman,
                              ),

                              const SizedBox(width: 8.0),

                              // ~:Status Dropdown:~
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                child: SalesStatusDropdown(
                                  listData: const [
                                    '',
                                    'Aktif',
                                    'Tidak Aktif',
                                  ],
                                  inputan: state.getSelectedStatus,
                                  hint: 'Status',
                                  handle: state.setSelectedStatus,
                                ),
                              ),

                              const SizedBox(width: 8.0),

                              // ~:Search Button:~
                              InkWell(
                                onTap: () => search(context, state),
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  height: 36,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.search_rounded,
                                        size: 16.0,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6.0),
                                      const Text(
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

                              // ~:Reset Button is Under Development:~
                              // InkWell(
                              //   onTap: () => state.resetAbsentHistory(),
                              //   ...
                              // ),
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
                  child: ValueListenableBuilder(
                    valueListenable: state.getSearchTriggerNotifier,
                    builder: (context, value, _) {
                      if (value) {
                        if (state.getBrowseSalesmanList.isNotEmpty) {
                          List<MBrowseSalesman> salesman =
                              state.getBrowseSalesmanList;

                          return SalesmanList(salesman);
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
                                  List<MBrowseSalesman> salesman =
                                      snapshot.data!['data'];

                                  return SalesmanList(salesman);
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
                        if (state.getBrowseSalesmanList.isNotEmpty) {
                          List<MBrowseSalesman> salesman =
                              state.getBrowseSalesmanList;

                          return SalesmanList(salesman);
                        } else {
                          return Center(
                            child: Text('Data tidak tersedia.'),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
