import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/datepicker_custom.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/dropdown_custom.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/snackbar_info.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/utilities/utils.dart';
import 'package:stsj/router/router_const.dart';
import 'package:url_launcher/url_launcher.dart';

class FPMDialogFilter extends StatefulWidget {
  const FPMDialogFilter({super.key});

  @override
  State<FPMDialogFilter> createState() => _FPMDialogFilterState();
}

class _FPMDialogFilterState extends State<FPMDialogFilter> {
  late String dashboard, bengkel, tgl;
  String access = '';

  String get getDashboard => dashboard;

  void setDashboard(String value) => setState(() => dashboard = value);
  void setBengkel(String value) => setState(() => bengkel = value);
  void setTgl1(String value) => tgl = value;

  void setReset() {
    dashboard = dashboardList[0]['id']!;
    bengkel = bengkelList[0]['id']!;
    tgl = DateTime.now().toString().substring(0, 10);
  }

  // ~:Dashboard 2 Export:~
  Future exportDashboard2(MenuState state) async {
    String baseUrl =
        "https://wsip.yamaha-jatim.co.id:2449/Report/ExportXls?PT=SAMP&Param={'PT':'SAMP','ReportName':'DASHBOARD FIXUPMOTO DAILY','UserID':'YUDI SETIAWAN','Branch':'${state.getWorkshopName == '' ? '' : state.getWorkshopName.substring(0, 2)}','Shop':'${state.getWorkshopName == '' ? '' : state.getWorkshopName.substring(2, 4)}','TransNo':'','BeginDate':'','EndDate':'${state.getFpmDateFilter}','Filter1':'','Filter2':'','Filter3':'','Filter4':'','Filter5':'','Filter6':'','Filter7':'','Filter8':'','Filter9':'','Filter10':'','Filter11':'','Filter12':'','Filter13':'','Filter14':''}";

    try {
      await launchUrl(Uri.parse(baseUrl));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
      }
    }
  }

  // ~:Dashboard 3 Export:~
  Future exportDashboard3(MenuState state) async {
    String baseUrl =
        "https://wsip.yamaha-jatim.co.id:2449/Report/ExportXls?PT=SAMP&Param={'PT':'SAMP','ReportName':'DASHBOARD FIXUPMOTO DAILY MEKANIK','UserID':'YUDI SETIAWAN','Branch':'${state.getWorkshopName == '' ? '' : state.getWorkshopName.substring(0, 2)}','Shop':'${state.getWorkshopName == '' ? '' : state.getWorkshopName.substring(2, 4)}','TransNo':'','BeginDate':'','EndDate':'${state.getFpmDateFilter}','Filter1':'','Filter2':'','Filter3':'','Filter4':'','Filter5':'','Filter6':'','Filter7':'','Filter8':'','Filter9':'','Filter10':'','Filter11':'','Filter12':'','Filter13':'','Filter14':''}";

    try {
      await launchUrl(Uri.parse(baseUrl));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
      }
    }
  }

  // ~:Dashboard 4 Export:~
  Future exportDashboard4(MenuState state) async {
    String baseUrl =
        "https://wsip.yamaha-jatim.co.id:2449/Report/ExportXls?PT=SAMP&Param={'PT':'SAMP','ReportName':'DASHBOARD FIXUPMOTO MONTHLY','UserID':'YUDI SETIAWAN','Branch':'${state.getWorkshopName == '' ? '' : state.getWorkshopName.substring(0, 2)}','Shop':'${state.getWorkshopName == '' ? '' : state.getWorkshopName.substring(2, 4)}','TransNo':'','BeginDate':'','EndDate':'${state.getFpmDateFilter}','Filter1':'','Filter2':'','Filter3':'','Filter4':'','Filter5':'','Filter6':'','Filter7':'','Filter8':'','Filter9':'','Filter10':'','Filter11':'','Filter12':'','Filter13':'','Filter14':''}";

    try {
      await launchUrl(Uri.parse(baseUrl));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    setReset();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Ganti nama 'Yudi' jadi username sesuai login configuration
  void find(
    BuildContext context,
    MenuState state,
  ) async {
    Navigator.pop(context);

    state.setWorkshopName(bengkel);
    state.setFpmDateFilter(tgl);
    if (dashboard == '1') {
      // ~:Preview Dashboard 1:~
      context.goNamed(RoutesConstant.fpm1stDashboard);
    } else if (dashboard == '2') {
      // ~:Preview Dashboard 2:~
      await exportDashboard2(state);
      // context.goNamed(RoutesConstant.fpm2ndDashboard);
    } else if (dashboard == '3') {
      // ~:Preview Dashboard 3:~
      await exportDashboard3(state);
      // context.goNamed(RoutesConstant.fpm3rdDashboard);
    } else if (dashboard == '4') {
      // ~:Preview Dashboard 4:~
      await exportDashboard4(state);
      // context.goNamed(RoutesConstant.fpm4thDashboard);
    } else {
      // ~:Preview Dashboard 5:~
      context.goNamed(RoutesConstant.fpm5thDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);

    return Theme(
      data: ThemeData(),
      child: AlertDialog(
        actionsPadding:
            const EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
        contentPadding:
            const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 5),
        title: const Text('FILTER',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actionsAlignment: MainAxisAlignment.center,
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard :',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                DropdownCustom(
                  state.getFilteredDashboardList,
                  dashboard,
                  'Pilih Dashboard',
                  setDashboard,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Bengkel :',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                DropdownCustom(
                    bengkelList, bengkel, 'Pilih Bengkel', setBengkel),
                const SizedBox(height: 12),
                const Text(
                  'Tanggal :',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                DatepickerCustom(tgl, setTgl1),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => find(context, state),
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(EdgeInsets.all(10)),
              backgroundColor: const WidgetStatePropertyAll(Colors.indigo),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            child: Builder(
              builder: (context) {
                if (getDashboard == '1' || getDashboard == '5') {
                  return const Text(
                    'CARI',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  );
                } else {
                  return const Text(
                    'EXPORT',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
