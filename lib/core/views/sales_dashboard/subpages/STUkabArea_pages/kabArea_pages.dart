import 'package:flutter/material.dart';
import 'package:stsj/core/controller/SalesDashboardController/STUbyArea_controller.dart';
import 'package:stsj/core/models/SalesDashboardModel/STUModelbyAreaKab.dart';
import 'package:stsj/core/service/ReusableService.dart';
import 'package:stsj/router/router_const.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategoriTipeMotor.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/core/views/errorHandling_pages.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell3.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell2.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell4.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/dataCell6.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterDatesUpdate.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategori.dart';
import 'package:stsj/core/views/sales_dashboard/components/dataCell2_image.dart';
import 'package:stsj/core/views/sales_dashboard/components/dataCell3_image.dart';
import 'package:stsj/core/views/sales_dashboard/components/dataCell4_image.dart';
import 'package:stsj/core/views/sales_dashboard/components/dataCell_image.dart';
import 'package:stsj/core/views/sales_dashboard/components/tipeFilterTahunBelow.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ListKabAreaPages extends StatefulWidget {
  ListKabAreaPages({Key? key}) : super(key: key);

  @override
  _ListKabAreaPagesState createState() => _ListKabAreaPagesState();
}

class _ListKabAreaPagesState extends State<ListKabAreaPages> {
  var bulansekarang = DateTime.now().day;
  var tahunsekarang = DateTime.now().year;

  List<kabupatenModel> kabupatenList = [];
  List<String?> subkabupatenList = [];
  List<String?> subBigArea = [];
  List<String?> subitem = [];

  String? selectedKabupaten;
  String? selectedBigArea;

  var bulannow, bulanprev, bulansecondprev;
  var tahunnow, tahunprev, tahunsecondprev;

  bool isLoading = true;
  bool isError = false;

  void fetchDataKab() async {
    kabupatenList.clear();
    subkabupatenList.clear();
    subBigArea.clear();
    subitem.clear();

    setState(() {
      isLoading = true;
    });

    try {
      print('fetchDataSales');
      await STUBYAreaController.fetchDataAPIbyKab(
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
          isLoading = false;
          isError = false;

          kabupatenList.addAll(value);
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

    fetchDataKab();
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
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.salesDashboard,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (isReset == false)
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Row(
                        children: [
                          FilterKategori(),
                          SizedBox(width: 5),
                          FilterbyTipeMotor(),
                          SizedBox(
                            width: 5,
                          ),
                          FilterbyTahunBelow(),
                          SizedBox(
                            width: 5,
                          ),
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
                                setState(() {
                                  fetchDataKab();
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
                                    DateTime.now().month,
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
                    )
                  : SizedBox(),
              isError
                  ? ErrorWidgetComponent(
                      message: 'Terjadi Kesalahan saat mengambil data',
                      onRetry: fetchDataKab,
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
                                      child: Text("STU BY KAB AREA",
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
                                        "${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(int.parse(STUBYAreaController.bulan)))}",
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
                                        "${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(int.parse(STUBYAreaController.bulan)))}",
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
                                        "${ServiceReusable.cekbulan(int.parse(STUBYAreaController.bulan))}",
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
                                              color:
                                                  Colors.grey, // Warna border
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
                                              color:
                                                  Colors.grey, // Warna border
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
                                        " TOTAL: ${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(int.parse(STUBYAreaController.bulan)))}",
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
                                        " TOTAL: ${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(int.parse(STUBYAreaController.bulan)))}",
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
                                        " TOTAL: ${ServiceReusable.cekbulan(int.parse(STUBYAreaController.bulan))}",
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
                                        "COUNT: ${ServiceReusable.cekbulan(ServiceReusable.bulan2BeforeCheck(int.parse(STUBYAreaController.bulan)))}",
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
                                        "COUNT: ${ServiceReusable.cekbulan(ServiceReusable.bulanBeforeCheck(int.parse(STUBYAreaController.bulan)))}",
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
                                        " COUNT: ${ServiceReusable.cekbulan(int.parse(STUBYAreaController.bulan))}",
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: kabupatenList.map((item) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              if (subkabupatenList
                                                  .contains(item.territori)) {
                                                subkabupatenList
                                                    .remove(item.territori);
                                              } else {
                                                subkabupatenList
                                                    .add(item.territori);
                                              }
                                              setState(() {});
                                            },
                                            child: CellDashboard1(
                                                textTitle: '${item.territori}'),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item.qty1}'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item.qty2}'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item.qty3}'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: CellDashboard1Image(
                                                      textTitle:
                                                          item.UrlGambarVZLM
                                                              .toString())),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        "${item.vSLM!} %"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: CellDashboard1Image(
                                                      textTitle:
                                                          item.UrlGambarVZLY
                                                              .toString())),
                                              Expanded(
                                                flex: 1,
                                                child: CellDashboard1(
                                                    textTitle:
                                                        "${item.vSLY!} %"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item.tQty1}'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item.tQty2}'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item.tQty3}'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item.pTQty1} %'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item.pTQty2} %'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CellDashboard1(
                                              textTitle: '${item.pTQty3} %'),
                                        ),
                                      ],
                                    ),
                                    subkabupatenList.contains(item.territori)
                                        ? Column(
                                            children: item.detail!.map((item2) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (subBigArea
                                                                .contains(item2
                                                                    .bigArea)) {
                                                              subBigArea.remove(
                                                                  item2
                                                                      .bigArea);
                                                            } else {
                                                              subBigArea.add(
                                                                  item2
                                                                      .bigArea);
                                                            }
                                                            setState(() {});
                                                          },
                                                          child: CellDashboard2(
                                                              textTitle:
                                                                  '${item2.bigArea}'),
                                                        ),
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
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child: CellDashboard2Image(
                                                                    textTitle: item2
                                                                            .UrlGambarVZLM
                                                                        .toString())),
                                                            Expanded(
                                                              flex: 1,
                                                              child: CellDashboard2(
                                                                  textTitle:
                                                                      "${item2.vSLM!} %"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child: CellDashboard2Image(
                                                                    textTitle: item2
                                                                            .UrlGambarVZLY
                                                                        .toString())),
                                                            Expanded(
                                                              flex: 1,
                                                              child: CellDashboard2(
                                                                  textTitle:
                                                                      "${item2.vSLY!} %"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: CellDashboard2(
                                                            textTitle:
                                                                '${item2.tQty1}'),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: CellDashboard2(
                                                            textTitle:
                                                                '${item2.tQty2}'),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: CellDashboard2(
                                                            textTitle:
                                                                '${item2.tQty3}'),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: CellDashboard2(
                                                            textTitle:
                                                                '${item2.pTQty1}'),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: CellDashboard2(
                                                            textTitle:
                                                                '${item2.pTQty2}'),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: CellDashboard2(
                                                            textTitle:
                                                                '${item2.pTQty3}'),
                                                      ),
                                                    ],
                                                  ),
                                                  subBigArea.contains(
                                                          item2.bigArea)
                                                      ? Column(
                                                          children: item2
                                                              .dataDT2!
                                                              .map((item3) {
                                                            return Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (subitem
                                                                              .contains(item3.kabupaten)) {
                                                                            subitem.remove(item3.kabupaten);
                                                                          } else {
                                                                            subitem.add(item3.kabupaten);
                                                                          }
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child: CellDashboard3(
                                                                            textTitle:
                                                                                '${item3.kabupaten}'),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: CellDashboard3(
                                                                          textTitle:
                                                                              '${item3.qty1}'),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: CellDashboard3(
                                                                          textTitle:
                                                                              '${item3.qty2}'),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: CellDashboard3(
                                                                          textTitle:
                                                                              '${item3.qty3}'),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Expanded(
                                                                              flex: 1,
                                                                              child: CellDashboard3Image(textTitle: item3.UrlGambarVZLM.toString())),
                                                                          Expanded(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                CellDashboard3(textTitle: "${item3.vSLM!} %"),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Expanded(
                                                                              flex: 1,
                                                                              child: CellDashboard3Image(textTitle: item3.UrlGambarVZLY.toString())),
                                                                          Expanded(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                CellDashboard3(textTitle: "${item3.vSLY!} %"),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: CellDashboard3(
                                                                          textTitle:
                                                                              '${item3.tQty1}'),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: CellDashboard3(
                                                                          textTitle:
                                                                              '${item3.tQty2}'),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: CellDashboard3(
                                                                          textTitle:
                                                                              '${item3.tQty3}'),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: CellDashboard3(
                                                                          textTitle:
                                                                              '${item3.pTQty1} %'),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: CellDashboard3(
                                                                          textTitle:
                                                                              '${item3.pTQty2} %'),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: CellDashboard3(
                                                                          textTitle:
                                                                              '${item3.pTQty3} %'),
                                                                    ),
                                                                  ],
                                                                ),
                                                                subitem.contains(
                                                                        item3
                                                                            .kabupaten)
                                                                    ? Column(
                                                                        children: item3
                                                                            .dataDT3!
                                                                            .map((item4) {
                                                                          return Row(
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard4(textTitle: '${item4.cName}'),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard4(textTitle: '${item4.qty1}'),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard4(textTitle: '${item4.qty2}'),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard4(textTitle: '${item4.qty3}'),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Row(
                                                                                  children: [
                                                                                    Expanded(flex: 1, child: CellDashboard4Image(textTitle: item4.UrlGambarVZLM.toString())),
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: CellDashboard4(textTitle: "${item4.vSLM!} %"),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Row(
                                                                                  children: [
                                                                                    Expanded(flex: 1, child: CellDashboard4Image(textTitle: item4.UrlGambarVZLY.toString())),
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: CellDashboard4(textTitle: "${item4.vSLY!} %"),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard4(textTitle: '${item4.tQty1}'),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard4(textTitle: '${item4.tQty2}'),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard4(textTitle: '${item4.tQty3}'),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard4(textTitle: '${item4.pTQty1} %'),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard4(textTitle: '${item4.pTQty2} %'),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: CellDashboard4(textTitle: '${item4.pTQty3} %'),
                                                                              ),
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
                                        : SizedBox(),
                                  ],
                                );
                              }).toList(),
                            ),
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
                                          '${STUBYAreaController.sumKABqty1}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard6(
                                      textTitle:
                                          '${STUBYAreaController.sumKABqty2}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard6(
                                      textTitle:
                                          '${STUBYAreaController.sumKABqty3}'),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(textTitle: ''),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(
                                            textTitle:
                                                '${((ServiceReusable.parseAndHandleNaNPercent(STUBYAreaController.sumKABqty3 / STUBYAreaController.sumKABqty2) * 100))} %'),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: CellDashboard6(textTitle: ''),
                                      ),
                                      Expanded(
                                        child: CellDashboard6(
                                            textTitle:
                                                '${((ServiceReusable.parseAndHandleNaNPercent(STUBYAreaController.sumKABqty3 / STUBYAreaController.sumKABVSLY) * 100))} %'),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard6(
                                      textTitle:
                                          '${STUBYAreaController.sumKABqty1}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard6(
                                      textTitle:
                                          '${STUBYAreaController.sumKABqty2}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard6(
                                      textTitle:
                                          '${STUBYAreaController.sumKABqty3}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard6(
                                      textTitle:
                                          '${((ServiceReusable.parseAndHandleNaNPercent(STUBYAreaController.sumKABqty1 / STUBYAreaController.sumKABqty1) * 100))} %'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard6(
                                      textTitle:
                                          '${((ServiceReusable.parseAndHandleNaNPercent(STUBYAreaController.sumKABqty2 / STUBYAreaController.sumKABqty2) * 100))} %'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CellDashboard6(
                                      textTitle:
                                          '${((ServiceReusable.parseAndHandleNaNPercent(STUBYAreaController.sumKABqty3 / STUBYAreaController.sumKABqty3) * 100))} %'),
                                ),
                              ],
                            )
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
