import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/models/dashboard1_model.dart';
import 'package:stsj/dashboard-fixup/models/detail_dashboard1_model.dart';
import 'package:stsj/dashboard-fixup/pages/dashboard1_chart.dart';
import 'package:stsj/dashboard-fixup/pages/dashboard1_table.dart';
import 'package:stsj/dashboard-fixup/services/api.dart';
import 'package:stsj/dashboard-fixup/utilities/basepage.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

//HASIL DATA BEDA ANTARA BULAN "03" vs "3"
class Dashboard1Page extends StatefulWidget {
  const Dashboard1Page({
    super.key,
  });

  @override
  State<Dashboard1Page> createState() => _Dashboard1PageState();
}

class _Dashboard1PageState extends State<Dashboard1Page> with BasePage, AutomaticKeepAliveClientMixin<Dashboard1Page> {
  late List<Dashboard1> listDashboard1;
  late List<DetailDashboard1> sortDetailOmset;
  late String tgl, bln, thn;
  late bool dashboardView;

  @override
  void initState() {
    setAwal(Provider.of<MenuState>(context, listen: false));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future setAwal(MenuState state) async {
    setState(() => loading = true);

    listDashboard1 = [];
    sortDetailOmset = [];
    reset(state);
    await getListApi();

    setState(() => loading = false);
  }

  void reset(MenuState state) {
    dashboardView = true;
    thn = state.getFpmDateFilter.substring(0, 4);
    bln = state.getFpmDateFilter.substring(5, 7);
    tgl = state.getFpmDateFilter.substring(8, 10);
  }

  Future getListApi() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      listDashboard1.addAll(await SampApi.getDashboard1(
        prefs.getString("UserID")!,
        bln,
        thn,
      ));

      //*SORT OMSET
      sortDetailOmset.addAll(listDashboard1[0].detail);
      sortDetailOmset.sort((a, b) => b.omsetTmBS.compareTo(a.omsetTmBS));
    } catch (e) {
      error = true;
      txtError = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = Provider.of<MenuState>(context);

    return Scaffold(
      backgroundColor: Colors.blue[50]!.withAlpha(200),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: startUpPage(
        onRefresh: () => setAwal(state),
        child: Stack(
          children: [
            dashboardView ? Dashboard1Chart(listDashboard1, sortDetailOmset, bln) : Dashboard1Table(listDashboard1, bln),
            //*FOOTER
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.white.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('\u00a9 ', style: TextStyle(fontSize: 10)), Text(' 2025 IT Basra Corporation', style: TextStyle(fontSize: 10))],
                ),
              ),
            ),
            //*TANGGAL
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                color: Colors.white.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        Format.tanggalFormat(
                          DateTime.now().toString().substring(0, 10),
                        ),
                        style: const TextStyle(fontSize: 10)),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        setState(() => dashboardView = !dashboardView);
                      },
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        overlayColor: WidgetStatePropertyAll(Colors.transparent),
                        minimumSize: WidgetStatePropertyAll(Size(50, 20)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        dashboardView ? '🔁Switch Table' : '🔁Switch Dashboard',
                        style: const TextStyle(
                          fontSize: 10,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
