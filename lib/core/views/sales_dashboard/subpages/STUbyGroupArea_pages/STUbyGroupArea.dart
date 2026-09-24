import 'package:flutter/material.dart';
import 'package:stsj/core/controller/SalesDashboardController/STUbyArea_controller.dart';
import 'package:stsj/core/models/SalesDashboardModel/STUModelbyGroupArea.dart';
import 'package:stsj/core/service/ReusableService.dart';

import 'package:stsj/router/router_const.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/core/views/errorHandling_pages.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell3.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell2.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell4.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell5.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell6.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterDatesUpdate.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategori.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategoriTipeMotor.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterTahunBelow.dart';
import 'package:stsj/core/views/sales_dashboard/components/dataCell2_image.dart';
import 'package:stsj/core/views/sales_dashboard/components/dataCell3_image.dart';
import 'package:stsj/core/views/sales_dashboard/components/dataCell4_image.dart';
import 'package:stsj/core/views/sales_dashboard/components/dataCell5_image.dart';
import 'package:stsj/core/views/sales_dashboard/components/dataCell_image.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class GroupAreaPages extends StatefulWidget {
  const GroupAreaPages({Key? key}) : super(key: key);

  @override
  _ListKabAreaPagesState createState() => _ListKabAreaPagesState();
}

class _ListKabAreaPagesState extends State<GroupAreaPages> {
  var tanggalsekarang = DateTime.now().day;
  var bulansekarang = DateTime.now().month;
  var tahunsekarang = DateTime.now().year;

  List<SalesGroupByArea?> grouplist = [];
  List<String?> listtier = [];
  List<String?> groupbigTotal = [];
  List<String?> groupDealer = [];
  List<String?> dealer = [];

  String? selectedKabupaten;
  String? selectedBigArea;

  bool isLoading = true;
  bool isError = false;

  void fetchDatabyGroupCC() async {
    grouplist.clear();

    setState(() {
      isLoading = true;
    });

    try {
      // print('fetchDataSales');
      await STUBYAreaController.fetchDataAPIGroupArea(
        FilterKategori.selectedKategori,
        FilterbyTipeMotor.selectedTipeMotor,
        FilterbyTahunBelow.selectedTahunBelow,
        FilterDatesV2.currentSelectionMode ==
                DateRangePickerSelectionMode.multiple
            ? FilterDatesV2.selectedDates
            : (FilterDatesV2.currentSelectionMode ==
                    DateRangePickerSelectionMode.range
                ? FilterDatesV2.rangeDate
                : null),
      ).then((value) {
        // SalesKabArea.getTtitle(value!);

        setState(() {
          grouplist.addAll(value);

          isLoading = false;
          isError = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });

      // Tangani pengecualian di sini, misalnya tampilkan pesan kesalahan atau lakukan tindakan yang sesuai.
      print('Terjadi kesalahan: $e');
    }
  }

  bool isReset = false;

  @override
  void initState() {
    super.initState();

    fetchDatabyGroupCC();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    const double fontsize = 10;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            56,
          ),
          child: CustomAppBar(
            goBack: RoutesConstant.salesDashboard,
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              children: [
                if (isReset == false)
                  Row(
                    children: [
                      FilterKategori(),
                      SizedBox(width: 5),
                      FilterbyTipeMotor(),
                      SizedBox(width: 5),
                      FilterbyTahunBelow(),
                      SizedBox(width: 5),
                      FilterDatesV2(),
                      SizedBox(width: 5),
                      Expanded(child: SizedBox()),
                      Align(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
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
                            setState(() {});
                            fetchDatabyGroupCC();
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
                              EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.clear, color: Colors.black54),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Reset Filter')
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
                SizedBox(
                  height: 10,
                ),
                isError
                    ? ErrorWidgetComponent(
                        message: 'Terjadi Kesalahan saat mengambil data',
                        onRetry: fetchDatabyGroupCC,
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
                                        child: Text("STU BY GROUP ",
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
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color:
                                                    Colors.grey, // Warna border
                                                width: 1.0, // Lebar border
                                              ),
                                            ),
                                            child: Center(
                                              child: Text("",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "fontdashboard",
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
                                                color:
                                                    Colors.grey, // Warna border
                                                width: 1.0, // Lebar border
                                              ),
                                            ),
                                            child: Center(
                                              child: Text("VSLM",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "fontdashboard",
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
                                                color:
                                                    Colors.grey, // Warna border
                                                width: 1.0, // Lebar border
                                              ),
                                            ),
                                            child: Center(
                                              child: Text("",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "fontdashboard",
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
                                                color:
                                                    Colors.grey, // Warna border
                                                width: 1.0, // Lebar border
                                              ),
                                            ),
                                            child: Center(
                                              child: Text("VSLY",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "fontdashboard",
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
                                          "Σ ${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(FilterDatesV2.selectedDates['bulan']))}",
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
                                          "Σ ${ServiceReusable.cekbulan(FilterDatesV2.selectedDates['bulan'])}",
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
                                          "COUNT ${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(FilterDatesV2.selectedDates['bulan']))}",
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
                                          "COUNT ${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(FilterDatesV2.selectedDates['bulan']))}",
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
                                          "COUNT ${ServiceReusable.cekbulan((FilterDatesV2.selectedDates['bulan']))}",
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
                              ...grouplist.map((item) {
                                return Column(children: [
                                  Column(
                                    children: item!.detail!.map((item2) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                    onTap: () {
                                                      if (listtier.contains(
                                                          item2.territori)) {
                                                        listtier.remove(
                                                            item2.territori);

                                                        // print(listtier);
                                                      } else {
                                                        listtier.add(
                                                            item2.territori);
                                                      }
                                                      setState(() {});
                                                    },
                                                    child: CellDashboard1(
                                                        textTitle:
                                                            '${item2.territori}')),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle: '${item2.qty1}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle: '${item2.qty2}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle: '${item2.qty3}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: CellDashboard1Image(
                                                            textTitle: item2
                                                                    .UrlGambarVZLM
                                                                .toString())),
                                                    Expanded(
                                                      flex: 1,
                                                      child: CellDashboard1(
                                                          textTitle:
                                                              "${item2.vSLM!} %"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle: '${item2.lY}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: CellDashboard1Image(
                                                            textTitle: item2
                                                                    .UrlGambarVZLY
                                                                .toString())),
                                                    Expanded(
                                                      flex: 1,
                                                      child: CellDashboard1(
                                                          textTitle:
                                                              "${item2.vSLY!} %"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.tQty1}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.tQty2}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.tQty3}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.pTQty1} %'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.pTQty2} %'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.pTQty3} %'),
                                              ),
                                            ],
                                          ),
                                          listtier.contains(item2.territori)
                                              ? Column(
                                                  children: item2.dataDT2!
                                                      .map((item3) {
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: InkWell(
                                                              onTap: () {
                                                                if (groupbigTotal
                                                                    .contains(item3
                                                                        .bigArea)) {
                                                                  groupbigTotal
                                                                      .remove(item3
                                                                          .bigArea);

                                                                  // print(
                                                                  //     listtier);
                                                                } else {
                                                                  groupbigTotal
                                                                      .add(item3
                                                                          .bigArea);
                                                                }
                                                                setState(() {});
                                                              },
                                                              child: CellDashboard2(
                                                                  textTitle:
                                                                      ' Total ${item3.bigArea}'),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '${item3.qty1}'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '${item3.qty2}'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '${item3.qty3}'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    flex: 1,
                                                                    child: CellDashboard2Image(
                                                                        textTitle:
                                                                            item3.UrlGambarVZLM.toString())),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: CellDashboard2(
                                                                      textTitle:
                                                                          "${item3.vSLM!} %"),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '${item3.lY}'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    flex: 1,
                                                                    child: CellDashboard2Image(
                                                                        textTitle:
                                                                            item3.UrlGambarVZLY.toString())),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: CellDashboard2(
                                                                      textTitle:
                                                                          "${item3.vSLY!} %"),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.tQty1}'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.tQty2}'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.tQty3}'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.pTQty1} %'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.pTQty2} %'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.pTQty3} %'),
                                                          ),
                                                        ],
                                                      ),
                                                      groupbigTotal.contains(
                                                              item3.bigArea)
                                                          ? Column(
                                                              children: item3
                                                                  .dataDT3!
                                                                  .map((item4) {
                                                                return Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              if (groupDealer.contains(item4.groupBigName)) {
                                                                                groupDealer.remove(item4.groupBigName);

                                                                                // print(groupDealer);
                                                                              } else {
                                                                                groupDealer.add(item4.groupBigName);
                                                                              }
                                                                              setState(() {});
                                                                            },
                                                                            child:
                                                                                CellDashboard3(textTitle: '  ${item4.groupBigName}'),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '${item4.qty1}'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '${item4.qty2}'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '${item4.qty3}'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(flex: 1, child: CellDashboard3Image(textTitle: item4.UrlGambarVZLM.toString())),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard3(textTitle: "${item4.vSLM!} %"),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '${item4.lY}'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(flex: 1, child: CellDashboard3Image(textTitle: item4.UrlGambarVZLY.toString())),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard3(textTitle: "${item4.vSLY!} %"),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.tQty1}'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.tQty2}'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.tQty3}'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.pTQty1} %'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.pTQty2} %'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.pTQty3} %'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    groupDealer.contains(
                                                                            item4.groupBigName)
                                                                        ? Column(
                                                                            children:
                                                                                item4.dataDT4!.map((item5) {
                                                                              return Column(
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: InkWell(
                                                                                          onTap: () {
                                                                                            if (groupDealer.contains(item5.groupName)) {
                                                                                              groupDealer.remove(item5.groupName);

                                                                                              // print(groupDealer);
                                                                                            } else {
                                                                                              groupDealer.add(item5.groupName);
                                                                                            }
                                                                                            setState(() {});
                                                                                          },
                                                                                          child: CellDashboard4(textTitle: '${item5.groupName}'),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '${item5.qty1}'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '${item5.qty2}'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '${item5.qty3}'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Expanded(flex: 1, child: CellDashboard4Image(textTitle: item5.UrlGambarVZLM.toString())),
                                                                                            Expanded(
                                                                                              flex: 1,
                                                                                              child: CellDashboard4(textTitle: "${item5.vSLM!} %"),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '${item5.lY}'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Expanded(flex: 1, child: CellDashboard4Image(textTitle: item5.UrlGambarVZLY.toString())),
                                                                                            Expanded(
                                                                                              flex: 1,
                                                                                              child: CellDashboard4(textTitle: "${item5.vSLY!} %"),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.tQty1}'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.tQty2}'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.tQty3}'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.pTQty1} %'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.pTQty2} %'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.pTQty3} %'),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  groupDealer.contains(item5.groupName)
                                                                                      ? Column(
                                                                                          children: item5.dataDT5!.map((item6) {
                                                                                            return Column(
                                                                                              children: [
                                                                                                Row(
                                                                                                  children: [
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '${item6.cName}'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '${item6.qty1}'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '${item6.qty2}'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '${item6.qty3}'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Expanded(flex: 1, child: CellDashboard5Image(textTitle: item6.UrlGambarVZLM.toString())),
                                                                                                          Expanded(
                                                                                                            flex: 1,
                                                                                                            child: CellDashboard5(textTitle: "${item6.vSLM!} %"),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '${item6.lY}'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Expanded(flex: 1, child: CellDashboard5Image(textTitle: item6.UrlGambarVZLY.toString())),
                                                                                                          Expanded(
                                                                                                            flex: 1,
                                                                                                            child: CellDashboard5(textTitle: "${item6.vSLY!} %"),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.tQty1}'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.tQty2}'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.tQty3}'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.pTQty1} %'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.pTQty2} %'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.pTQty3} %'),
                                                                                                    ),
                                                                                                  ],
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          }).toList(),
                                                                                        )
                                                                                      : SizedBox()
                                                                                ],
                                                                              );
                                                                            }).toList(),
                                                                          )
                                                                        : SizedBox()
                                                                  ],
                                                                );
                                                              }).toList(),
                                                            )
                                                          : SizedBox()
                                                    ],
                                                  );
                                                }).toList())
                                              : SizedBox()
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: ' GRAND TOTAL'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '${item.qty1}'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '${item.qty2}'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '${item.qty3}'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child:
                                                  CellDashboard6(textTitle: ''),
                                            ),
                                            Expanded(
                                              child: CellDashboard6(
                                                  textTitle: '${item.vSLM} %'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '${item.lY}'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child:
                                                  CellDashboard6(textTitle: ''),
                                            ),
                                            Expanded(
                                              child: CellDashboard6(
                                                  textTitle: '${item.vSLY} %'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.tQty1}'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.tQty2}'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.tQty3}'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.pTQty1} %'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.pTQty2} %'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.pTQty3} %'),
                                      ),
                                    ],
                                  )
                                ]);
                              }).toList()
                            ],
                          ),
              ],
            ),
          ),
        ));
  }
}
