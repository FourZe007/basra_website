// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:simple_grid/simple_grid.dart';
import 'package:stsj/core/controller/SalesDashboardController/STUbyLeasing.dart';
import 'package:stsj/core/models/SalesDashboardModel/STUModelLeasingDashboardArea.dart';
import 'package:stsj/core/service/ReusableService.dart';

import 'package:stsj/router/router_const.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/core/views/errorHandling_pages.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/TipeFilterDP.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterArea.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterDatesUpdate.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategori.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategoriTipeMotor.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterTahunBelow.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipefilterByKab.dart';

import 'package:stsj/core/views/sales_dashboard/components/dataCell6.dart';
import 'package:stsj/core/views/sales_dashboard/subpages/STUbyLeasingArea_pages/STUbyLeasingAreaPieChart.dart';
import 'package:stsj/core/views/sales_dashboard/subpages/STUbyLeasingArea_pages/STUbyLeasingAreaPieChartALL.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ListAreaPages extends StatefulWidget {
  @override
  _ListAreaPagesState createState() => _ListAreaPagesState();
}

class _ListAreaPagesState extends State<ListAreaPages> {
  List<STUDataDashboardArea> listDataArea = [];

  List<ChartData> chartjenispembayaran = [];
  List<ChartData> chartsemuaLeasing = [];

  var tanggalsekarang = DateTime.now().day;
  var bulansekarang = DateTime.now().month;
  var tahunsekarang = DateTime.now().year;

  final Map<String, dynamic> kategoriSum = {
    'sumQTY1': 0,
    'sumTotalTunaiKredit1': 0,
    'sumTotalTunaiKredit2': 0,
    'sumTotalTunaiKredit3': 0,
    'sumQTY2': 0,
    'sumQTY3': 0,
    'sumVSLM': 0,
    'sumVSLY': 0,
    'sumLY': 0,
  };

  var bulansebelumnya = DateTime.now().month - 1;
  var duabulansebelumnya = DateTime.now().month - 2;

  bool isLoading = true;
  bool isError = false;
  bool isReset = false;
  bool isloadingChart = false;

  void fetchData() async {
    // Bersihkan data saat terjadi fetch ulang
    listDataArea.clear();
    chartjenispembayaran.clear();

    setState(() {
      isLoading = true;
    });

    //

    print('fetch data Area');

    try {
      await STUbyLeasingController.fetchDataarea(
              FilterbyArea.selectedArea,
              FilterKategori.selectedKategori,
              FilterbyTipeMotor.selectedTipeMotor,
              FilterbyTahunBelow.selectedTahunBelow,
              FilterbyKab.selectedKab,
              FilterByDP.selectedRangeUM,
              FilterDatesV2.currentSelectionMode ==
                      DateRangePickerSelectionMode.multiple
                  ? FilterDatesV2.selectedDates
                  : (FilterDatesV2.currentSelectionMode ==
                          DateRangePickerSelectionMode.range
                      ? FilterDatesV2.rangeDate
                      : null))
          .then((value) {
        print(value);
        listDataArea.addAll(value);

        if (listDataArea.isNotEmpty) {
          kategoriSum['sumQTY1'] = 0;
          kategoriSum['sumQTY2'] = 0;
          kategoriSum['sumQTY3'] = 0;
          kategoriSum['sumTotalTunaiKredit1'] = 0;
          kategoriSum['sumTotalTunaiKredit2'] = 0;
          kategoriSum['sumTotalTunaiKredit3'] = 0;
          kategoriSum['sumVSLM'] = 0;
          kategoriSum['sumVSLY'] = 0;
          kategoriSum['sumLY'] = 0;

          for (var i = 0; i < listDataArea.length; i++) {
            kategoriSum['sumQTY1'] += listDataArea[i].Qty1;
            kategoriSum['sumQTY2'] += listDataArea[i].Qty2;
            kategoriSum['sumQTY3'] += listDataArea[i].Qty3;

            if (listDataArea[i].leasingmkt == "TUNAI" ||
                listDataArea[i].leasingmkt == "KREDIT") {
              kategoriSum['sumTotalTunaiKredit1'] += listDataArea[i].Qty1;
              kategoriSum['sumTotalTunaiKredit2'] += listDataArea[i].Qty2;
              kategoriSum['sumTotalTunaiKredit3'] += listDataArea[i].Qty3;
              kategoriSum['sumVSLM'] += listDataArea[i].VSLM;
              kategoriSum['sumVSLY'] += listDataArea[i].VSLY;

              kategoriSum['sumLY'] += listDataArea[i].LY;
            }
          }

          for (var i = 0; i < listDataArea.length; i++) {
            // double kredittunai = 0;

            if (listDataArea[i].leasingmkt == "TUNAI" ||
                listDataArea[i].leasingmkt == "KREDIT") {
              // kredittunai += listDataArea[i].Qty3;

              print(listDataArea[i].Qty3);

              chartjenispembayaran.add(ChartData(
                  listDataArea[i].leasingmkt, (listDataArea[i].Qty3)));
            } else {
              chartsemuaLeasing.add(
                  ChartData(listDataArea[i].leasingmkt, listDataArea[i].Qty3));
            }
          }
        }

        print(chartjenispembayaran);

        setState(() {
          isError = false;
          isLoading = false;
        });
      });
    } catch (e) {
      print(e);
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("==================TipeAreaSubPages==================");

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // Kode UI Anda di sini

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
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (isReset == false)
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Row(
                    children: [
                      FilterbyArea(),
                      SizedBox(width: 5),
                      FilterbyKab(),
                      SizedBox(width: 5),
                      FilterKategori(),
                      SizedBox(width: 5),
                      FilterbyTipeMotor(),
                      SizedBox(width: 5),
                      FilterByDP(),
                      SizedBox(width: 5),
                      FilterbyTahunBelow(),
                      SizedBox(width: 5),
                      FilterDatesV2(),
                      Expanded(child: SizedBox()),
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              fetchData();
                            });
                          },
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
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          ),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.clear, color: Colors.black54),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Reset All Filter')
                          ],
                        ),
                      ),
                    ],
                  )),
            isError
                ? ErrorWidgetComponent(
                    message: 'Terjadi Kesalahan saat mengambil data',
                    onRetry: fetchData,
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
                                    child: Text("STU BY LEASING AREA",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                    child: Text("CC + LEASING",
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
                                      "${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(int.parse(STUbyLeasingController.bulan)))}",
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
                                      "% ${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(int.parse(STUbyLeasingController.bulan)))}",
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
                                      "${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(int.parse(STUbyLeasingController.bulan)))}",
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
                                      "% ${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(int.parse(STUbyLeasingController.bulan)))}",
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
                                      "${ServiceReusable.cekbulan((int.parse(STUbyLeasingController.bulan)))}",
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
                                      "% ${ServiceReusable.cekbulan((int.parse(STUbyLeasingController.bulan)))}",
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
                                    child: Text(
                                      "LY",
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
                          Column(
                              children: listDataArea.map((emp) {
                            var g = intl.NumberFormat("#.##", "en_US");

                            return Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard1(
                                      textTitle: '${emp.leasingmkt}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard1(
                                      textTitle: emp.Qty1.toString().length > 3
                                          ? CurrencyFormat.convertToIdr(
                                                  emp.Qty1, 0)
                                              .toString()
                                          : emp.Qty1.toString()),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard1(
                                    textTitle:
                                        '${g.format((emp.Qty1 / (kategoriSum['sumTotalTunaiKredit1'])) * 100)} %',
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard1(
                                      textTitle: emp.Qty2.toString().length > 3
                                          ? CurrencyFormat.convertToIdr(
                                                  emp.Qty2, 0)
                                              .toString()
                                          : emp.Qty2.toString()),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard1(
                                    textTitle:
                                        '${g.format(((emp.Qty2 / (kategoriSum['sumQTY2'] ?? 1)) * 100).isNaN ? 0 : (emp.Qty2 / (kategoriSum['sumQTY2'] ?? 1)) * 100)} %',
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard1(
                                      textTitle: emp.Qty3.toString().length > 3
                                          ? CurrencyFormat.convertToIdr(
                                                  emp.Qty3, 0)
                                              .toString()
                                          : emp.Qty3.toString()),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard1(
                                    textTitle:
                                        '${g.format(((emp.Qty3 / (kategoriSum['sumQTY3'] ?? 1)) * 100).isNaN ? 0 : (emp.Qty3 / (kategoriSum['sumQTY3'] ?? 1)) * 100)} %',
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 182, 255, 250),
                                          ),
                                          child: Center(
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 8,
                                              backgroundImage: AssetImage(
                                                  emp.UrlGambarVZLM!),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: CellDashboard1(
                                            textTitle:
                                                '${emp.VSLM.toString().replaceAll(".", ",")}%'),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard1(
                                      textTitle: emp.Qty3.toString().length > 3
                                          ? CurrencyFormat.convertToIdr(
                                                  emp.Qty3, 0)
                                              .toString()
                                          : emp.LY.toString()),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 182, 255, 250),
                                          ),
                                          child: Center(
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 8,
                                              backgroundImage: AssetImage(
                                                  emp.UrlGambarVZLY!),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard1(
                                            textTitle: emp.VSLY
                                                    .toString()
                                                    .replaceAll(".", ",") +
                                                '%'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList()),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CellDashboard6(textTitle: 'GRAND TOTAL'),
                              ),
                              Expanded(
                                flex: 1,
                                child: CellDashboard6(
                                    textTitle:
                                        (kategoriSum['sumTotalTunaiKredit1'])
                                            .toString()),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: CellDashboard6(textTitle: "")),
                              Expanded(
                                flex: 1,
                                child: CellDashboard6(
                                    textTitle:
                                        (kategoriSum['sumTotalTunaiKredit2'])
                                            .toString()),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: CellDashboard6(textTitle: "")),
                              Expanded(
                                flex: 1,
                                child: CellDashboard6(
                                    textTitle:
                                        (kategoriSum['sumTotalTunaiKredit3'])
                                            .toString()),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: CellDashboard6(textTitle: "")),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: CellDashboard6(textTitle: "")),
                                    Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle:
                                                '${ServiceReusable.parseAndHandleNaNPercent(kategoriSum['sumTotalTunaiKredit3'] / kategoriSum['sumTotalTunaiKredit2'] * 100)}%')),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: CellDashboard6(
                                      textTitle:
                                          (kategoriSum['sumLY']).toString())),
                              Expanded(
                                  child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: CellDashboard6(textTitle: "")),
                                  Expanded(
                                      flex: 1,
                                      child: CellDashboard6(
                                          textTitle:
                                              '${ServiceReusable.parseAndHandleNaNPercent(kategoriSum['sumTotalTunaiKredit3'] / kategoriSum['sumVSLY'] * 100)}%')),
                                ],
                              )),
                            ],
                          ),
                        ],
                      ),
            SpGrid(children: [
              SpGridItem(
                  padding: EdgeInsetsDirectional.all(20),
                  lg: 6,
                  child: isLoading
                      ? SizedBox()
                      : Container(
                          color: Colors.white,
                          child: STUbyLeasingAreaPieChart(
                            AreaChart: chartjenispembayaran,
                          ),
                        )),
              SpGridItem(
                  padding: EdgeInsetsDirectional.all(20),
                  lg: 6,
                  child: isLoading
                      ? SizedBox()
                      : Container(
                          color: Colors.white,
                          child: STUbyLeasingAreaPieChartAll(
                            AreaChart: chartsemuaLeasing,
                          ),
                        ))
            ])
          ]),
        ),
      ),
    );
  }
}

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
