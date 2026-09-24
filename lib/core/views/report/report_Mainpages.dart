import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_grid/simple_grid.dart';
import 'package:stsj/core/controller/ReportDashboardController/ListReport_controller.dart';
import 'package:stsj/core/models/Report/ListReport.dart';
import 'package:stsj/core/models/Report/ReportModel.dart';
import 'package:stsj/router/router_const.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/core/views/errorHandling_pages.dart';
import 'package:stsj/core/views/report/component/left_drawer.dart';
import 'package:stsj/core/views/report/subpages/accounting_subpages.dart';
import 'package:stsj/core/views/report/subpages/beabaliknama_subpages.dart';
import 'package:stsj/core/views/report/subpages/fakturPajak_subpages.dart';
import 'package:stsj/core/views/report/subpages/finance_subpages.dart';
import 'package:stsj/core/views/report/subpages/inventory_subpages.dart';
import 'package:stsj/core/views/report/subpages/faktur_polisi.dart';
import 'package:stsj/core/views/report/subpages/lain-lain_subpages.dart';
import 'package:stsj/core/views/report/subpages/master.dart';
import 'package:stsj/core/views/report/subpages/pembelian_subpages.dart';
import 'package:stsj/core/views/report/subpages/penjualan_subpages.dart';
import 'package:stsj/core/views/report/subpages/registrasi_subpages.dart';
import 'package:stsj/core/views/report/subpages/service_subpages.dart';

class ReportPages extends HookWidget {
  static List<ListReport> listReport = [];
  static List<String> listReportPembelian = [];
  static List<ListBranch> listBranch = [];

  static String? Userid = "";
  static String? PTClicked = "";

  // static Map<String, dynamic> listReportMap = {
  //   'PT'
  //   'Userid': Userid,
  //   'PT': PTClicked,
  //   'Branch': []
  // };

  @override
  Widget build(BuildContext context) {
    var currentPage = useState<int>(0);
    var isLoading = useState<bool>(false);

    var isLoadingBranch = useState<bool>(false);

    var isError = useState<bool>(false);

    void fetchDataReport() async {
      // bersihkan list dulu agar saat di fetch data tidak numpuk
      listReport.clear();
      listBranch.clear();

      isLoading.value = true;

      Userid = "";
      PTClicked = "";

      SharedPreferences ListUser = await SharedPreferences.getInstance();

      Userid = ListUser.getString("UserID");
      PTClicked = ListUser.getString("PT");

      try {
        await ListReportController.fetchListReport(PTClicked!, Userid!)
            .then((value) {
          listReport.addAll(value);

          isLoading.value = false;
          isError.value = false;
        });
      } catch (e) {
        print(e);
        isLoading.value = false;
        isError.value = true;
      }
    }

    useEffect(() {
      fetchDataReport();

      return () {
        // clean up code
      };
    }, []);

    void _changePage(int newPage) {
      currentPage.value = newPage;
    }

    Widget _getCurrentPageWidget() {
      switch (currentPage.value) {
        case 0:
          return PembelianSubPages(
            category: "PUR",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        case 1:
          return PenjualanSubPages(
            category: "SLS",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        case 2:
          return ServiceSubPages(
            category: "SRV",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        case 3:
          return InventorySubPages(
            category: "INV",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        case 4:
          return RegistrasiSubPages(
            category: "REG",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        case 5:
          return FinanceSubPages(
            category: "FIN",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        case 6:
          return AccountingSubPages(
            category: "ACC",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        case 7:
          return MasterSubPages(
            category: "MST",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        case 8:
          return FakturPolisiSubPages(
            category: "FAK",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        case 9:
          return BeaBalikNamaSubPages(
            category: "BBN",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        case 10:
          return FakturPajakSubPages(
            category: "FPJ",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        case 11:
          return LainLainSubpages(
            category: "OTH",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
        default:
          return PembelianSubPages(
            category: "PUR",
            nama: Userid.toString(),
            pt: PTClicked.toString(),
          );
      }
    }

    return isError.value
        ? ErrorWidgetComponent(
            message: 'Terjadi Kesalahan saat mengambil data',
            onRetry: fetchDataReport,
          )
        : isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(
                    56,
                  ),
                  child: CustomAppBar(goBack: RoutesConstant.menu),
                ),
                drawer: LeftDrawer(
                    currentPage: currentPage.value,
                    onItemSelected: _changePage),
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 1000),
                      child: SpGrid(
                        width: MediaQuery.of(context).size.width,
                        children: [
                          SpGridItem(
                            xs: 12,
                            sm: 12,
                            md: 12,
                            lg: 12,
                            child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                decoration: BoxDecoration(
                                  color:
                                      Color.fromARGB(255, 255, 255, 255), // A
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.2), // Warna bayangan
                                      spreadRadius:
                                          5, // Menyebar lebar bayangan
                                      blurRadius: 7, // Blur bayangan
                                      offset: Offset(0, 3), // Offset bayangan
                                    ),
                                  ],
                                ),
                                child: _getCurrentPageWidget()),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }
}
