// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:simple_grid/simple_grid.dart';
import 'package:stsj/core/controller/SalesDashboardController/STUbyLeasing.dart';
import 'package:stsj/core/models/SalesDashboardModel/STUModelDataLeasingCategoryDP.dart';
import 'package:stsj/core/models/SalesDashboardModel/STUModelLeasingCategory.dart';
import 'package:stsj/core/models/SalesDashboardModel/STUModelLeasingDashboardArea.dart';
import 'package:stsj/core/service/ReusableService.dart';

import 'package:stsj/router/router_const.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/core/views/errorHandling_pages.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterArea.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterDatesUpdate.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategori.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipeFilterKategoriRadio.dart';
import 'package:stsj/core/views/Sales_Dashboard/components/tipefilterByKab.dart';

import 'package:stsj/core/views/sales_dashboard/components/TipeFilterDP.dart';
import 'package:stsj/core/views/sales_dashboard/components/tipeFilterKategoriTipeMotor.dart';
import 'package:stsj/core/views/sales_dashboard/components/tipeFilterLeasingRadio.dart';
import 'package:stsj/core/views/sales_dashboard/components/tipeFilterTahunBelow.dart';
import 'package:stsj/core/views/sales_dashboard/subpages/STUbyDP+Category_pages/STUbyLeasingArea_component.dart';
import 'package:stsj/core/views/sales_dashboard/subpages/STUbyDP+Category_pages/categoryDP_pages/STUcategoryDP_component.dart';
import 'package:stsj/core/views/sales_dashboard/subpages/STUbyDP+Category_pages/leasingCategory_pages/STUbyleasingCategory_component.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DPwithCategoryPages extends StatefulWidget {
  @override
  _DPpagesState createState() => _DPpagesState();
}

class _DPpagesState extends State<DPwithCategoryPages> {
  List<DataDashboardKategoriDP> listDataAPIleasingDP = [];
  List<STUDataDashboardArea> listDataArea = [];
  List<DataLeasingCategory> listDataAPIleasingCategory = [];

  var tanggalsekarang = DateTime.now().day;
  var bulansekarang = DateTime.now().month;
  var tahunsekarang = DateTime.now().year;

  bool isLoading = true;
  bool isReset = false;
  bool isError = false;

  Future<void> fetchData() async {
    print('Fetch Data Leasing DP');
    setState(() {
      isLoading = true;
    });

    try {
      await STUbyLeasingController.fetchDataLeasingDP(
              FilterbyArea.selectedArea,
              FilterKategoriRadio.selectedKategori,
              FilterByLeasingRadio.selectedLeasingDP,
              FilterbyKab.selectedKab,
              FilterDatesV2.currentSelectionMode ==
                      DateRangePickerSelectionMode.multiple
                  ? FilterDatesV2.selectedDates
                  : (FilterDatesV2.currentSelectionMode ==
                          DateRangePickerSelectionMode.range
                      ? FilterDatesV2.rangeDate
                      : null))
          .then((value) {
        print(value);
        listDataAPIleasingDP.addAll(value);
      });

      await STUbyLeasingController.fetchDataLeasingCategory(
              FilterbyArea.selectedArea,
              FilterKategori.selectedKategori,
              FilterByLeasingRadio.selectedLeasingDP,
              FilterbyKab.selectedKab,
              FilterDatesV2.currentSelectionMode ==
                      DateRangePickerSelectionMode.multiple
                  ? FilterDatesV2.selectedDates
                  : (FilterDatesV2.currentSelectionMode ==
                          DateRangePickerSelectionMode.range
                      ? FilterDatesV2.rangeDate
                      : null))
          .then((value) => listDataAPIleasingCategory.addAll(value));

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
          .then((value) => listDataArea.addAll(value));

      setState(() {
        isError = false;
        isLoading = false;
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

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // Kode UI Anda di sini
    final double screenWidth = MediaQuery.of(context).size.width;

    double fontsize = 14;

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
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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

                      ServiceReusable.resetFilter(FilterDatesV2.selectedDates,
                          DateTime.now().day, bulansekarang, tahunsekarang, () {
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
              ),
            ),
          isError
              ? ErrorWidgetComponent(
                  message: 'Terjadi Kesalahan saat mengambil data',
                  onRetry: fetchData,
                )
              : isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          ListAreaPagesComponent(
                            listDataArea: listDataArea,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SpGrid(spacing: 15, children: [
                            SpGridItem(
                              lg: 6,
                              child: CategoryDPComponent(
                                listDataAPIleasingDP: listDataAPIleasingDP,
                              ),
                            ),
                            SpGridItem(
                                lg: 6,
                                child: LeasingCategoryComponent(
                                    listDataAPIleasingCategory:
                                        listDataAPIleasingCategory))
                          ])
                        ],
                      ),
                    ),
        ]),
      ),
    );
  }
}
