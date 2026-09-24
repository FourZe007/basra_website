// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Import package untuk menggunakan groupBy
import 'package:simple_grid/simple_grid.dart';
import 'package:stsj/core/controller/SalesDashboardController/STUbyCategory_controller.dart';
import 'package:stsj/core/models/SalesDashboardModel/STUModelCategoryTotal.dart';
import 'package:stsj/core/service/ReusableService.dart';

import 'package:stsj/router/router_const.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell6.dart';
import 'package:stsj/core/views/Sales_Dashboard/subpages/STUpages1_pages/STUareaGraphLY.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/core/views/errorHandling_pages.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell2.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterArea.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterDatesUpdate.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterGroupName.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategori.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterTahunBelow.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipefilterByKab.dart';

import 'package:intl/intl.dart' as intl;
import 'package:stsj/core/views/sales_dashboard/components/dataCell_image.dart';
import 'package:stsj/core/views/sales_dashboard/subpages/STUbycategoryTotal_pages/STUcategoryGraphLM.dart';
import 'package:stsj/core/views/sales_dashboard/subpages/STUbycategoryTotal_pages/STUcategoryGraphLY.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ListCategoryTotal extends StatefulWidget {
  static List<DataCategorytotal> listDataAPICategoryTotal = [];
  static Map<String?, List<DataCategorytotal>> groupedDataCategory = {};

  @override
  _DPpagesState createState() => _DPpagesState();
}

class _DPpagesState extends State<ListCategoryTotal> {
  var tanggalsekarang = DateTime.now().day;
  var bulansekarang = DateTime.now().month;
  var tahunsekarang = DateTime.now().year;

  static List<DataDashboardTipe> listDataCategory = [];

  var bulansebelumnya = DateTime.now().month - 1;
  var duabulansebelumnya = DateTime.now().month - 2;

  var bulannow, bulanprev, bulansecondprev;
  var tahunnow, tahunprev, tahunsecondprev;

  var f = intl.NumberFormat("###.0#", "en_US");
  var g = intl.NumberFormat("#.##", "en_US");

  List<String?> subItem = [];
  bool isLoading = true;
  bool isReset = false;
  bool isError = false;

  Future<void> FetchData() async {
    print('Fetch Data Category Total');

    listDataCategory.clear();

    try {
      await STUbyCategoryController.fetchDataCategoryTotal(
              FilterbyArea.selectedArea,
              FilterbyKab.selectedKab,
              FilterbyGrup.selectedGroup,
              FilterKategori.selectedKategori,
              FilterbyTahunBelow.selectedTahunBelow,
              FilterDatesV2.currentSelectionMode ==
                      DateRangePickerSelectionMode.multiple
                  ? FilterDatesV2.selectedDates
                  : (FilterDatesV2.currentSelectionMode ==
                          DateRangePickerSelectionMode.range
                      ? FilterDatesV2.rangeDate
                      : null))
          .then((value) {
        listDataCategory.addAll(value);
      });
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    } finally {
      isLoading = false;
      isError = false;

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    FetchData();
  }

  @override
  Widget build(BuildContext context) {
    double fontsize = 12;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.salesDashboard,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isReset == false)
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  children: [
                    FilterbyArea(),
                    SizedBox(width: 5),
                    FilterKategori(),
                    SizedBox(width: 5),
                    FilterbyKab(),
                    SizedBox(width: 5),
                    FilterDatesV2(),
                    SizedBox(width: 5),
                    Expanded(child: SizedBox()),
                    Align(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_alt, color: Colors.black54),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Filter')
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            FetchData();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Align(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.clear, color: Colors.black54),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Reset All Filter')
                          ],
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
                      ),
                    ),
                  ],
                ),
              ),
            isError
                ? ErrorWidgetComponent(
                    message: 'Terjadi Kesalahan saat mengambil data',
                    onRetry: FetchData,
                  )
                : isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey, // Warna border
                                      width: 1.0, // Lebar border
                                    ),
                                  ),
                                  child: Center(
                                    child: Text("AREA",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "fontdashboard",
                                            color: Colors.blueGrey,
                                            fontSize: fontsize)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey, // Warna border
                                      width: 1.0, // Lebar border
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(int.parse(STUbyCategoryController.bulan)))}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "fontdashboard",
                                        color: Colors.blueGrey,
                                        fontSize: fontsize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey, // Warna border
                                      width: 1.0, // Lebar border
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(int.parse(STUbyCategoryController.bulan)))}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "fontdashboard",
                                        color: Colors.blueGrey,
                                        fontSize: fontsize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey, // Warna border
                                      width: 1.0, // Lebar border
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${ServiceReusable.cekbulan(int.parse(STUbyCategoryController.bulan))}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "fontdashboard",
                                        color: Colors.blueGrey,
                                        fontSize: fontsize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey, // Warna border
                                            width: 1.0, // Lebar border
                                          ),
                                        ),
                                        child: Center(
                                          child: Text("",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "fontdashboard",
                                                  color: Colors.blueGrey,
                                                  fontSize: fontsize)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey, // Warna border
                                            width: 1.0, // Lebar border
                                          ),
                                        ),
                                        child: Center(
                                          child: Text("VSLM",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "fontdashboard",
                                                  color: Colors.blueGrey,
                                                  fontSize: fontsize)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey, // Warna border
                                      width: 1.0, // Lebar border
                                    ),
                                  ),
                                  child: Center(
                                    child: Text("LY",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "fontdashboard",
                                            color: Colors.blueGrey,
                                            fontSize: fontsize)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey, // Warna border
                                            width: 1.0, // Lebar border
                                          ),
                                        ),
                                        child: Center(
                                          child: Text("",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "fontdashboard",
                                                  color: Colors.blueGrey,
                                                  fontSize: fontsize)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey, // Warna border
                                            width: 1.0, // Lebar border
                                          ),
                                        ),
                                        child: Center(
                                          child: Text("VSLY",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "fontdashboard",
                                                  color: Colors.blueGrey,
                                                  fontSize: fontsize)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ...listDataCategory.map((item1) {
                            return Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                              onTap: () {
                                                if (subItem
                                                    .contains(item1.category)) {
                                                  subItem
                                                      .remove(item1.category);
                                                } else {
                                                  subItem.add(item1.category);
                                                }
                                                setState(() {});
                                                // print(subItem);
                                              },
                                              child: CellDashboard1(
                                                  textTitle:
                                                      "${item1.category}")),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item1.Qty1}'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item1.Qty2}'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item1.Qty3}'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: CellDashboard1Image(
                                                    textTitle:
                                                        '${item1.UrlGambarVZLM}'),
                                              ),
                                              Expanded(
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '${item1.VSLM} %'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item1.LY}'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: CellDashboard1Image(
                                                    textTitle:
                                                        '${item1.UrlGambarVZLY}'),
                                              ),
                                              Expanded(
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '${item1.VSLY} %'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    subItem.contains(item1.category)
                                        ? Column(
                                            children:
                                                item1.detail!.map((item2) {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: CellDashboard2(
                                                        textTitle:
                                                            '${item2.itemName}'),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: CellDashboard2(
                                                        textTitle:
                                                            '${item2.qty1}'),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: CellDashboard2(
                                                        textTitle:
                                                            '${item2.qty2}'),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: CellDashboard2(
                                                        textTitle:
                                                            '${item2.qty3}'),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: CellDashboard2(
                                                        textTitle:
                                                            '${item2.vSLM} %'),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: CellDashboard2(
                                                        textTitle:
                                                            '${item2.lY} %'),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: CellDashboard2(
                                                        textTitle:
                                                            '${item2.vSLY} %'),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          )
                                        : SizedBox()
                                  ],
                                )
                              ],
                            );
                          }).toList(),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child:
                                    CellDashboard6(textTitle: ' GRAND TOTAL'),
                              ),
                              Expanded(
                                flex: 1,
                                child: CellDashboard6(
                                    textTitle:
                                        '${STUbyCategoryController.sumQTY1totalCategory}'),
                              ),
                              Expanded(
                                flex: 1,
                                child: CellDashboard6(
                                    textTitle:
                                        '${STUbyCategoryController.sumQTY2totalCategory}'),
                              ),
                              Expanded(
                                flex: 1,
                                child: CellDashboard6(
                                    textTitle:
                                        '${STUbyCategoryController.sumQTY3totalCategory}'),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CellDashboard6(textTitle: ''),
                                    ),
                                    Expanded(
                                      child: CellDashboard6(
                                          textTitle:
                                              '${ServiceReusable.parseAndHandleNaNPercent((STUbyCategoryController.sumQTY3totalCategory / STUbyCategoryController.sumQTY2totalCategory) * 100)} %'),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: CellDashboard6(
                                    textTitle:
                                        '${STUbyCategoryController.sumLYtotalCategory}'),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CellDashboard6(textTitle: ''),
                                    ),
                                    Expanded(
                                      child: CellDashboard6(
                                          textTitle:
                                              '${ServiceReusable.parseAndHandleNaNPercent((STUbyCategoryController.sumQTY3totalCategory / STUbyCategoryController.sumLYtotalCategory) * 100)} %'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // isLoading
                          //     ? SizedBox()
                          //     : Row(
                          //         children: [
                          //           BarChartCategoryLM(
                          //             STUbyKategori: listDataCategory,
                          //           ),
                          //           BarChartCategoryLY(
                          //             STUbyKategori: listDataCategory,
                          //           )
                          //         ],
                          //       )
                        ],
                      ),
            SizedBox(
              height: 20,
            ),

            // isLoading
            //     ? SizedBox()
            //     : SpGrid(spacing: 15, children: [
            //         SpGridItem(
            //             lg: 6,
            //             child: BarChartCategoryLM(
            //               STUbyKategori: listDataCategory,
            //             )),
            //         SpGridItem(
            //             lg: 6,
            //             child: BarChartCategoryLY(
            //               STUbyKategori: listDataCategory,
            //             ))
            //       ])
          ],
        ),
      ),
    );
  }

  // Widget YourItemWidget(DataCategorytotal item) {
  //   print(item);
  //   return ExpansionTile(
  //     title: Text('test'),
  //     children: [
  //       DataTable(
  //         dividerThickness: 5,
  //         showBottomBorder: true,
  //         headingRowColor: MaterialStateProperty.all(Colors.white),
  //         columns: [
  //           DataColumn(
  //               label: Center(
  //                   child: Text(
  //             'Judul',
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: "fontdashboard",
  //                 color: Colors.blueGrey,
  //                 fontSize: 16),
  //           ))),
  //           DataColumn(
  //               label: Center(
  //                   child: Text(
  //             FilterDates.bulanFilter == 0
  //                 ? cekbulan(duabulansebelumnya).toString()
  //                 : cekbulan((FilterDates.bulansecondprev)).toString(),
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: "fontdashboard",
  //                 color: Colors.blueGrey,
  //                 fontSize: 16),
  //           ))),
  //           DataColumn(
  //               label: Center(
  //                   child: Text(
  //             FilterDates.bulanFilter == 0
  //                 ? cekbulan((bulansebelumnya)).toString()
  //                 : cekbulan((FilterDates.bulanprev)).toString(),
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: "fontdashboard",
  //                 color: Colors.blueGrey,
  //                 fontSize: 16),
  //           ))),
  //           DataColumn(
  //               label: Center(
  //                   child: Text(
  //             FilterDates.bulanFilter == 0
  //                 ? cekbulan(bulansekarang).toString()
  //                 : cekbulan((FilterDates.bulanFilter)).toString(),
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: "fontdashboard",
  //                 color: Colors.blueGrey,
  //                 fontSize: 16),
  //           ))),
  //           DataColumn(
  //               label: Center(
  //                   child: Text(
  //             "",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: "fontdashboard",
  //                 color: Colors.blueGrey,
  //                 fontSize: 16),
  //           ))),
  //           DataColumn(
  //               label: Center(
  //                   child: Text(
  //             "% VS LM",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: "fontdashboard",
  //                 color: Colors.blueGrey,
  //                 fontSize: 16),
  //           ))),
  //           DataColumn(
  //               label: Center(
  //                   child: Text(
  //             "LAST YEAR",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: "fontdashboard",
  //                 color: Colors.blueGrey,
  //                 fontSize: 16),
  //           ))),
  //           DataColumn(
  //               label: Center(
  //                   child: Text(
  //             "",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: "fontdashboard",
  //                 color: Colors.blueGrey,
  //                 fontSize: 16),
  //           ))),
  //           DataColumn(
  //               label: Center(
  //                   child: Text(
  //             "% VS LY",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: "fontdashboard",
  //                 color: Colors.blueGrey,
  //                 fontSize: 16),
  //           ))),
  //         ],
  //         rows: [],
  //       )
  //     ],
  //   );
  // }
}
