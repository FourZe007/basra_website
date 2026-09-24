import 'package:flutter/material.dart';

import 'package:intl/intl.dart' as intl;
import 'package:stsj/core/controller/SalesDashboardController/STUbyCategory_controller.dart';
import 'package:stsj/core/models/SalesDashboardModel/STUModelbyDaily.dart';
import 'package:stsj/core/service/ReusableService.dart';
import 'package:stsj/router/router_const.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/core/views/errorHandling_pages.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterArea.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterDatesUpdate.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterGroupName.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategori.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategoriTipeMotor.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterTahunBelow.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipefilterByKab.dart';
import 'package:stsj/core/views/Sales_Dashboard/salesDashboard_mainpages.dart';

class ListSTUbyDate extends StatefulWidget {
  @override
  _ListSTUbyDate createState() => _ListSTUbyDate();
}

class _ListSTUbyDate extends State<ListSTUbyDate> {
  List<STUbyDate> listDataAPIByDate = [];

  var tanggalsekarang = DateTime.now().day;
  var bulansekarang = DateTime.now().month;
  var tahunsekarang = DateTime.now().year;

  var bulansebelumnya = DateTime.now().month - 1;
  var duabulansebelumnya = DateTime.now().month - 2;

  var f = intl.NumberFormat("###.0#", "en_US");
  var g = intl.NumberFormat("#.##", "en_US");

  bool isLoading = true;
  bool isReset = false;
  bool isError = false;

  double fontsize = 12;

  Future<void> FetchData() async {
    print('Fetch Data Leasing by Category');
    listDataAPIByDate.clear();

    setState(() {
      isLoading = true;
    });

    try {
      await STUbyCategoryController.fetchDataSTUbyDate(
              FilterbyArea.selectedArea,
              FilterbyKab.selectedKab,
              FilterbyGrup.selectedGroup,
              FilterKategori.selectedKategori,
              FilterbyTipeMotor.selectedTipeMotor,
              FilterbyTahunBelow.selectedTahunBelow)
          .then((value) {
        setState(() {
          isLoading = false;
          isError = false;
          listDataAPIByDate.addAll(value);
        });
      });
    } catch (e) {
      print(e);
      isError = true;
      isLoading = true;

// Rethrow the exception
    }
  }

  @override
  void initState() {
    super.initState();
    print("==================TipeByDate==================");

    FetchData();
  }

  @override
  Widget build(BuildContext context) {
    // Kode UI Anda di sini

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.salesDashboard,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (isReset == false)
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                children: [
                  if (isReset == false) FilterbyArea(),
                  SizedBox(width: 5),
                  FilterKategori(),
                  SizedBox(width: 5),
                  FilterbyKab(),
                  SizedBox(width: 5),
                  FilterbyGrup(),
                  SizedBox(width: 5),
                  FilterbyTipeMotor(),
                  SizedBox(width: 5),
                  FilterbyTahunBelow(),
                  Expanded(child: SizedBox()),
                  Container(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                      ),
                      onPressed: () {
                        setState(() {
                          FetchData();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.filter_alt, color: Colors.black54),
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
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                    ),
                    onPressed: () {
                      setState(() {
                        isReset = true;
                      });
                      ServiceReusable.resetFilter(FilterDatesV2.selectedDates,
                          DateTime.now().day, bulansekarang, tahunsekarang, () {
                        setState(() {
                          isReset = false;
                        });
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.clear, color: Colors.black54),
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
                                  child: Text("STU BY DAILY",
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
                                  child: Text("TANGGAL",
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
                                    "${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(FilterDatesV2.selectedDates['bulan']))}",
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
                                    " Σ ${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(FilterDatesV2.selectedDates['bulan']))}",
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
                                    "${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(FilterDatesV2.selectedDates['bulan']))}",
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
                                    "Σ ${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(FilterDatesV2.selectedDates['bulan']))}",
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
                                    "${ServiceReusable.cekbulan(FilterDatesV2.selectedDates['bulan'])}",
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
                                    "S ${ServiceReusable.cekbulan(FilterDatesV2.selectedDates['bulan'])}",
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
                          ],
                        ),
                        ...listDataAPIByDate.map((emp) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CellDashboard1(textTitle: '${emp.hari}'),
                              ),
                              Expanded(
                                flex: 1,
                                child: CellDashboard1(
                                    textTitle: emp.qty1.toString().length > 3
                                        ? CurrencyFormat.convertToIdr(
                                                emp.qty1, 0)
                                            .toString()
                                        : emp.qty1.toString()),
                              ),
                              Expanded(
                                flex: 1,
                                child: CellDashboard1(
                                    textTitle: emp.qty1.toString().length > 3
                                        ? CurrencyFormat.convertToIdr(
                                                emp.qty1, 0)
                                            .toString()
                                        : emp.qty1.toString()),
                              ),
                              Expanded(
                                flex: 1,
                                child: CellDashboard1(
                                    textTitle: emp.qty2.toString().length > 3
                                        ? CurrencyFormat.convertToIdr(
                                                emp.qty2, 0)
                                            .toString()
                                        : emp.qty2.toString()),
                              ),
                              Expanded(
                                flex: 1,
                                child: CellDashboard1(
                                    textTitle: emp.qty2.toString().length > 3
                                        ? CurrencyFormat.convertToIdr(
                                                emp.qty2, 0)
                                            .toString()
                                        : emp.qty2.toString()),
                              ),
                              Expanded(
                                flex: 1,
                                child: CellDashboard1(
                                    textTitle: emp.qty3.toString().length > 3
                                        ? CurrencyFormat.convertToIdr(
                                                emp.qty3, 0)
                                            .toString()
                                        : emp.qty3.toString()),
                              ),
                              Expanded(
                                flex: 1,
                                child: CellDashboard1(
                                    textTitle: emp.qty3.toString().length > 3
                                        ? CurrencyFormat.convertToIdr(
                                                emp.qty3, 0)
                                            .toString()
                                        : emp.qty3.toString()),
                              ),
                            ],
                          );
                        }).toList()
                      ],
                    ),
        ]),
      ),
    );
  }
}
