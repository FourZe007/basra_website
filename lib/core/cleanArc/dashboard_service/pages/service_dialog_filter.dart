import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stsj/core/cleanArc/dashboard_service/DashboardMain.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/api.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/global.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/style.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/dashboard01.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/dashboard02.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/dashboard03.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/dashboard04.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/dashboard05.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/datepicker_custom.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/dropdown_custom.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/snackbar_info.dart';

class ServiceDialogFilter extends StatefulWidget {
  const ServiceDialogFilter({super.key});

  @override
  State<ServiceDialogFilter> createState() => _ServiceDialogFilterState();
}

class _ServiceDialogFilterState extends State<ServiceDialogFilter> {
  late bool loading;
  late String dashboard;
  late String teritory;
  late String tgl1;
  late String tgl2;

  void setDashboard(String value) => setState(() => dashboard = value);
  void setTeritory(String value) => setState(() => teritory = value);
  void setTgl1(String value) => tgl1 = value;
  void setTgl2(String value) => tgl2 = value;

  @override
  void initState() {
    super.initState();

    setReset();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setReset() {
    loading = false;
    dashboard = dashboardFC[0]['id']!;
    teritory = teritoryFC[0]['id']!;
    tgl1 = DateTime(DateTime.now().year, 01, 01).toString().substring(0, 10);
    tgl2 = DateTime.now().toString().substring(0, 10);
  }

  void find(context) async {
    setState(() => loading = true);
    try {
      await Api.getDashboard(dashboard, teritory, tgl1, tgl2).then((value) {
        // context.goNamed(
        //   RoutesConstant.dashboardService,
        //   queryParams: {'dashboard': dashboard, 'value': value},
        // );
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            if (dashboard == 'Dashboard01') {
              return DashboardServiceMain(child: Dashboard01(value));
            } else if (dashboard == 'Dashboard02') {
              return DashboardServiceMain(child: Dashboard02(value));
            } else if (dashboard == 'Dashboard03') {
              return DashboardServiceMain(child: Dashboard03(value));
            } else if (dashboard == 'Dashboard04') {
              return DashboardServiceMain(child: Dashboard04(value));
            } else if (dashboard == 'Dashboard05') {
              return DashboardServiceMain(child: Dashboard05(value));
            } else {
              throw 'HALAMAN TIDAK DITEMUKAN';
            }
          }),
        );
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: AlertDialog(
        actionsPadding:
            const EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
        contentPadding:
            const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 5),
        title: Text('FILTER', style: text20SB),
        actionsAlignment: MainAxisAlignment.center,
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard :', style: text13Med),
              DropdownCustom(
                  dashboardFC, dashboard, 'Pilih Dashboard', setDashboard),
              const SizedBox(height: 10),
              Text('Teritory :', style: text13Med),
              DropdownCustom(
                  teritoryFC, teritory, 'Pilih Teritory', setTeritory),
              const SizedBox(height: 10),
              Text('Tanggal :', style: text13Med),
              Row(
                children: [
                  Expanded(flex: 1, child: DatepickerCustom(tgl1, setTgl1)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text('-', style: TextStyle(fontSize: 15)),
                  ),
                  Expanded(flex: 1, child: DatepickerCustom(tgl2, setTgl2)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          loading
              ? SpinKitWave(color: blueOcean, size: 35)
              : ElevatedButton(
                  onPressed: () => find(context),
                  style: ButtonStyle(
                    padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
                    backgroundColor: MaterialStatePropertyAll(blueShappire),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  child: Text(' CARI ', style: text13SB.copyWith(color: white)),
                ),
        ],
      ),
    );
  }
}
