import 'package:flutter/material.dart';
import 'package:stsj/core/controller/SalesDashboardController/STUbyLeasing.dart';
import 'package:stsj/core/models/SalesDashboardModel/STUbyLeasingGroupCC.dart';
import 'package:stsj/core/service/ReusableService.dart';

import 'package:stsj/router/router_const.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterLeasingRadio.dart';
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

class GroupLeasingCCAreaPages extends StatefulWidget {
  GroupLeasingCCAreaPages({Key? key}) : super(key: key);

  @override
  _ListKabAreaPagesState createState() => _ListKabAreaPagesState();
}

class _ListKabAreaPagesState extends State<GroupLeasingCCAreaPages> {
  var tanggalsekarang = DateTime.now().day;
  var bulansekarang = DateTime.now().month;
  var tahunsekarang = DateTime.now().year;

  List<GroupCC> grouplistCC = [];
  List<String?> Listtier = [];
  List<String?> groupbigTotal = [];
  List<String?> groupDealer = [];
  List<String?> Dealer = [];

  String? selectedKabupaten;
  String? selectedBigArea;

  var bulansebelumnya = DateTime.now().month - 1;
  var duabulansebelumnya = DateTime.now().month - 2;

  bool isLoading = true;
  bool isError = false;
  bool isReset = false;

  void fetchDatabyGroupCC() async {
    grouplistCC.clear();

    setState(() {
      isLoading = true;
    });

    try {
      print('fetchDataSales');
      await STUbyLeasingController.fetchDataAPIbyGroupCC(
        FilterKategori.selectedKategori,
        FilterbyTipeMotor.selectedTipeMotor,
        FilterbyTahunBelow.selectedTahunBelow,
        FilterByLeasingRadio.selectedLeasingDP,
        FilterDatesV2.currentSelectionMode ==
                DateRangePickerSelectionMode.multiple
            ? FilterDatesV2.selectedDates
            : (FilterDatesV2.currentSelectionMode ==
                    DateRangePickerSelectionMode.range
                ? FilterDatesV2.rangeDate
                : null),
      ).then((value) {
        grouplistCC.addAll(value);

        print(grouplistCC);

        // SalesKabArea.getTtitle(value!);

        setState(() {
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
                      FilterByLeasingRadio(),
                      SizedBox(width: 5),
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
                                          "${ServiceReusable.cekbulan(int.parse(STUbyLeasingController.bulan))}",
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
                                              child: Text("GROWTH1",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "fontdashboard",
                                                      color: Colors.blueGrey,
                                                      fontSize: 9)),
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
                                          "SHARE ${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(int.parse(STUbyLeasingController.bulan)))}",
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
                                          "SHARE ${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(int.parse(STUbyLeasingController.bulan)))}",
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
                                          "SHARE ${ServiceReusable.cekbulan(int.parse(STUbyLeasingController.bulan))}",
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
                                          "KREDIT ${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(int.parse(STUbyLeasingController.bulan)))}",
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
                                          "KREDIT ${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(int.parse(STUbyLeasingController.bulan)))}",
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
                                          "KREDIT ${ServiceReusable.cekbulan(int.parse(STUbyLeasingController.bulan))}",
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
                                              child: Text("GROWTH2",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "fontdashboard",
                                                      color: Colors.blueGrey,
                                                      fontSize: 9)),
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
                                          "TOTAL ${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(int.parse(STUbyLeasingController.bulan)))}",
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
                                          "TOTAL ${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(int.parse(STUbyLeasingController.bulan)))}",
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
                                          "TOTAL ${ServiceReusable.cekbulan(int.parse(STUbyLeasingController.bulan))}",
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
                              ...grouplistCC.map((item) {
                                return Column(children: [
                                  Column(
                                    children: item.detail!.map((item2) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                    onTap: () {
                                                      if (Listtier.contains(
                                                          item2.territori)) {
                                                        Listtier.remove(
                                                            item2.territori);

                                                        print(Listtier);
                                                      } else {
                                                        Listtier.add(
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
                                                      child: CellDashboard1Image(
                                                          textTitle: item2
                                                                  .UrlGambarGrow1
                                                              .toString()),
                                                    ),
                                                    Expanded(
                                                      child: CellDashboard1(
                                                          textTitle:
                                                              '  ${item2.growth1} %'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.share1} %'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.share2} %'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.share3} %'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.kQty1}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.kQty2}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.kQty3}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: CellDashboard1Image(
                                                          textTitle: item2
                                                                  .UrlGambarGrow2
                                                              .toString()),
                                                    ),
                                                    Expanded(
                                                      child: CellDashboard1(
                                                          textTitle:
                                                              '  ${item2.growth2} %'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.tQty1} '),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.tQty2} '),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        '  ${item2.tQty3} '),
                                              ),
                                            ],
                                          ),
                                          Listtier.contains(item2.territori)
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

                                                                  print(
                                                                      Listtier);
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
                                                                  child: CellDashboard2Image(
                                                                      textTitle:
                                                                          item3.UrlGambarGrow1
                                                                              .toString()),
                                                                ),
                                                                Expanded(
                                                                  child: CellDashboard2(
                                                                      textTitle:
                                                                          '  ${item3.growth1} %'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.share1} %'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.share2} %'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.share3} %'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.kQty1}'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.kQty2}'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.kQty3}'),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: CellDashboard2Image(
                                                                      textTitle:
                                                                          item3.UrlGambarGrow2
                                                                              .toString()),
                                                                ),
                                                                Expanded(
                                                                  child: CellDashboard2(
                                                                      textTitle:
                                                                          '  ${item3.growth2} %'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.tQty1} '),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.tQty2} '),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CellDashboard2(
                                                                textTitle:
                                                                    '  ${item3.tQty3} '),
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

                                                                                print(groupDealer);
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
                                                                              Expanded(
                                                                                child: CellDashboard3Image(textTitle: item4.UrlGambarGrow1.toString()),
                                                                              ),
                                                                              Expanded(
                                                                                child: CellDashboard3(textTitle: '  ${item4.growth1} %'),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.share1} %'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.share2} %'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.share3} %'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.kQty1}'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.kQty2}'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.kQty3}'),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: CellDashboard3Image(textTitle: item4.UrlGambarGrow2.toString()),
                                                                              ),
                                                                              Expanded(
                                                                                child: CellDashboard3(textTitle: '  ${item4.growth2} %'),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.tQty1} '),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.tQty2} '),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              CellDashboard3(textTitle: '  ${item4.tQty3} '),
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

                                                                                              print(groupDealer);
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
                                                                                            Expanded(
                                                                                              child: CellDashboard4Image(textTitle: item5.UrlGambarGrow1.toString()),
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: CellDashboard4(textTitle: '  ${item5.growth1} %'),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.share1} %'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.share2} %'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.share3} %'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.kQty1}'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.kQty2}'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.kQty3}'),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: CellDashboard4Image(textTitle: item5.UrlGambarGrow2.toString()),
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: CellDashboard4(textTitle: '  ${item5.growth2} %'),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.tQty1} '),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.tQty2} '),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 1,
                                                                                        child: CellDashboard4(textTitle: '  ${item5.tQty3} '),
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
                                                                                                          Expanded(
                                                                                                            child: CellDashboard5Image(textTitle: item6.UrlGambarGrow1.toString()),
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: CellDashboard5(textTitle: '  ${item6.growth1} %'),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.share1} %'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.share2} %'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.share3} %'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.kQty1}'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.kQty2}'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.kQty3}'),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Expanded(
                                                                                                            child: CellDashboard5Image(textTitle: item6.UrlGambarGrow2.toString()),
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: CellDashboard5(textTitle: '  ${item6.growth2} %'),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.tQty1} '),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.tQty2} '),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      flex: 1,
                                                                                                      child: CellDashboard5(textTitle: '  ${item6.tQty3} '),
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
                                                  textTitle:
                                                      '  ${item.growth1} %'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.share1} %'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.share2} %'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.share3} %'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.kQty1}'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.kQty2}'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.kQty3}'),
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
                                                  textTitle:
                                                      '  ${item.growth2} %'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.tQty1} '),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.tQty2} '),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle: '  ${item.tQty3} '),
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
