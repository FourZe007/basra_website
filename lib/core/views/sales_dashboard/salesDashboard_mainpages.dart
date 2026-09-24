import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:stsj/core/controller/SalesDashboardController/STUbypages1_controller.dart';
import 'package:stsj/core/models/SalesDashboardModel/STUModelbypage1.dart';
import 'package:stsj/core/service/ReusableService.dart';

import 'package:stsj/router/router_const.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterArea.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterDatesUpdate.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategori.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterTahunBelow.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/core/views/errorHandling_pages.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/wSummary.dart';
import 'package:stsj/static/dataArea.const.dart';
import 'package:intl/intl.dart' as intl;
import 'package:stsj/core/views/Sales_Dashboard/subpages/STUpages1_pages/listSTU_mainpages.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    intl.NumberFormat currencyFormatter = intl.NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}

class SalesPages extends StatefulWidget {
  @override
  _SalesPagesState createState() => _SalesPagesState();
}

class _SalesPagesState extends State<SalesPages> {
  final ValueNotifier<String> selectedServices =
      ValueNotifier<String>('STU By Leasing Area');
  List<String> selectedArea = DataSalesConst.listarea;
  List<int> listTanggal = [];
  bool isError = false;
  bool isLoading1 = true;
  bool isError1 = false;

  bool isLoading = true;

  var tanggalsekarang = DateTime.now().day;
  var bulansekarang = DateTime.now().month;
  var tahunsekarang = DateTime.now().year;

  bool isReset = false;

  List<DataSTUBYKategori> STUbykategoridata = [];

  Future<void> fetchDatafirst() async {
    STUbykategoridata.clear();
    print('fetchDataDashboardSales');

    setState(() {
      isLoading1 = true;
    });

    try {
      await STUbyPages1.fetchSTUPages1(
        "1",
        FilterbyArea.selectedArea,
        FilterbyTahunBelow.selectedTahunBelow,
        FilterKategori.selectedKategori,
        FilterDatesV2.currentSelectionMode ==
                DateRangePickerSelectionMode.multiple
            ? FilterDatesV2.selectedDates
            : (FilterDatesV2.currentSelectionMode ==
                    DateRangePickerSelectionMode.range
                ? FilterDatesV2.rangeDate
                : null),
      ).then((value) {
        setState(() {
          isError1 = false;
          isLoading1 = false;
          isLoading = false;
          STUbykategoridata.addAll(value);

          print(value);
        });
      });
    } catch (e) {
      setState(() {
        isError = true;

        isError1 = true;
        isLoading = false;

        isLoading1 = false;
      });
    }
  }

  Future<void> fetchData() async {
    STUbykategoridata.clear();
    print('fetchDataDashboardSales');

    setState(() {
      isLoading = true;
    });

    try {
      await STUbyPages1.fetchSTUPages1(
        "1",
        FilterbyArea.selectedArea,
        FilterbyTahunBelow.selectedTahunBelow,
        FilterKategori.selectedKategori,
        FilterDatesV2.currentSelectionMode ==
                DateRangePickerSelectionMode.multiple
            ? FilterDatesV2.selectedDates
            : (FilterDatesV2.currentSelectionMode ==
                    DateRangePickerSelectionMode.range
                ? FilterDatesV2.rangeDate
                : null),
      ).then((value) {
        setState(() {
          isError = false;
          isLoading = false;
          STUbykategoridata.addAll(value);

          print(value);
        });
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    print('==================SalesAreaPages==================');
    fetchDatafirst(); // Panggil fetchDataDT di dalam initState
  }

  @override
  Widget build(BuildContext context) {
    const double _kSize = 100;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            56,
          ),
          child: CustomAppBar(
            goBack: RoutesConstant.menu,
          ),
        ),
        body: isError1
            ? ErrorWidgetComponent(
                message: 'Terjadi Kesalahan saat mengambil data',
                onRetry: fetchData,
              )
            : isLoading1
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: wSummary(
                                    title: ServiceReusable.cekbulan(
                                            ServiceReusable.bulanBeforeCheck(
                                                int.parse(STUbyPages1.bulan)))
                                        .toString(),
                                    desc: isLoading
                                        ? STUbyPages1.sumQty2
                                        : STUbyPages1.sumQty2,
                                    warna: Colors.green,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: wSummary(
                                    title: ServiceReusable.cekbulan(
                                            int.parse(STUbyPages1.bulan))
                                        .toString(),
                                    desc: isLoading
                                        ? STUbyPages1.sumQty3
                                        : STUbyPages1.sumQty3,
                                    warna: Colors.green,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: wSummary(
                                    title: "LAST YEAR",
                                    desc: isLoading
                                        ? STUbyPages1.sumQtyLY
                                        : STUbyPages1.sumQtyLY,
                                    warna: Color.fromARGB(255, 242, 242, 3),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.blue,
                                            width: 5,
                                          ),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),

                                      padding: EdgeInsets.fromLTRB(5, 10, 0, 0),

                                      // Add padding to control content spacing
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align content to the left
                                        children: [
                                          Row(
                                            children: [
                                              Text('VS LM',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.lightBlue)),
                                              isLoading
                                                  ? SizedBox()
                                                  : Image.asset(
                                                      STUbyPages1.urlGambarVZLM,
                                                      width: 20,
                                                    )
                                            ],
                                          ),
                                          Center(
                                            child: Countup(
                                              begin: 0,
                                              end: isLoading
                                                  ? ServiceReusable
                                                      .parseAndHandleNaNPercent(
                                                          ((STUbyPages1
                                                                      .sumQty3 /
                                                                  STUbyPages1
                                                                      .sumQty2) *
                                                              100))
                                                  : ServiceReusable
                                                      .parseAndHandleNaNPercent(
                                                          ((STUbyPages1
                                                                      .sumQty3 /
                                                                  STUbyPages1
                                                                      .sumQty2) *
                                                              100)),
                                              duration: Duration(seconds: 3),
                                              suffix: ' %',
                                              separator: '.',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),

                                            // Text(
                                            //   STUbyPages1.sumQty3 == 0
                                            //       ? "0 %"
                                            //       : STUbyPages1.sumQty3 == 0
                                            //           ? "0 %"
                                            //           : '${ServiceReusable.parseAndHandleNaNPercent(((STUbyPages1.sumQty3 / STUbyPages1.sumQty2) * 100))} %',
                                            //   style: TextStyle(
                                            //     fontSize:
                                            //         16, // Customize text style as needed
                                            //   ),
                                            // ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.blue,
                                            width: 5,
                                          ),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),

                                      padding: EdgeInsets.fromLTRB(5, 10, 0, 0),

                                      // Add padding to control content spacing
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align content to the left
                                        children: [
                                          Row(
                                            children: [
                                              Text('VS LY',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.lightBlue)),
                                              isLoading
                                                  ? SizedBox()
                                                  : Image.asset(
                                                      STUbyPages1.urlGambarVZLY,
                                                      width: 20,
                                                    )
                                            ],
                                          ),
                                          Center(
                                            child: Countup(
                                              begin: 0,
                                              end: isLoading
                                                  ? ServiceReusable
                                                      .parseAndHandleNaNPercent(
                                                          ((STUbyPages1
                                                                      .sumQty3 /
                                                                  STUbyPages1
                                                                      .sumQtyLY) *
                                                              100))
                                                  : ServiceReusable
                                                      .parseAndHandleNaNPercent(
                                                          ((STUbyPages1
                                                                      .sumQty3 /
                                                                  STUbyPages1
                                                                      .sumQtyLY) *
                                                              100)),
                                              duration: Duration(seconds: 3),
                                              suffix: ' %',
                                              separator: '.',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),

                                            // Text(
                                            //   STUbyPages1.sumQty3 == 0
                                            //       ? "0 %"
                                            //       : '${ServiceReusable.parseAndHandleNaNPercent(((STUbyPages1.sumQty3 / STUbyPages1.sumQtyLY) * 100))} %',
                                            //   style: TextStyle(
                                            //     fontSize:
                                            //         16, // Customize text style as needed
                                            //   ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: wSummary(
                                    title: "TARGET",
                                    desc: isLoading
                                        ? STUbyPages1.sumTarget
                                        : STUbyPages1.sumTarget,
                                    warna: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (isReset == false)
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                child: Row(
                                  children: [
                                    if (isReset == false) FilterbyArea(),
                                    SizedBox(width: 5),
                                    FilterKategori(),
                                    SizedBox(width: 5),
                                    FilterbyTahunBelow(),
                                    SizedBox(width: 5),
                                    FilterDatesV2(),
                                    Expanded(child: SizedBox()),
                                    Container(
                                      alignment: Alignment.topRight,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: 40,
                                                  vertical: 20)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            fetchData();
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.filter_alt,
                                                color: Colors.black54),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text('Filter')
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 20)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isReset = true;
                                        });
                                        ServiceReusable.resetFilter(
                                            FilterDatesV2.selectedDates,
                                            DateTime.now().day,
                                            bulansekarang,
                                            tahunsekarang, () {
                                          setState(() {
                                            isReset = false;
                                          });
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.clear,
                                              color: Colors.black54),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Reset All Filter')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                                child: isError
                                    ? ErrorWidgetComponent(
                                        message:
                                            'Terjadi Kesalahan saat mengambil data',
                                        onRetry: fetchData,
                                      )
                                    : isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : ListSTU(
                                            listDataArea: STUbykategoridata,
                                            fetchData: fetchData))
                          ],
                        )),
                  ));
  }
}
