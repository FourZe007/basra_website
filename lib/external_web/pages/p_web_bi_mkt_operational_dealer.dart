import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:stsj/dashboard_pemetaan/models/geo_hd.dart';
import 'package:stsj/external_web/utilities/global.dart';
import 'package:stsj/external_web/widget/w_info_user.dart';
import 'package:stsj/external_web/widget/w_tombol_link_powerbi.dart';
import 'package:stsj/external_web/widget/w_tombol_logout.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/external_web/widget/w_web_bi_dashboard_pemetaan.dart';
import 'package:stsj/external_web/widget/w_web_bi_filter_dashboard_pemetaan.dart';
import 'package:stsj/external_web/widget/w_web_bi_import_target_dealer.dart';
import 'package:stsj/external_web/widget/w_web_bi_manager_activity.dart';
import 'package:web/web.dart' as web;
import 'package:go_router/go_router.dart';
import 'package:stsj/router/router_const.dart';

class PWebBiMktOperationalDealer extends StatefulWidget {
  const PWebBiMktOperationalDealer({super.key});

  @override
  State<PWebBiMktOperationalDealer> createState() => _MyPageState();
}

class _MyPageState extends State<PWebBiMktOperationalDealer> {
  String currentURL = '',
      tgldashboardpemetaan1 = '',
      tgldashboardpemetaan2 = '',
      viewID = "operationaldealer-iframe";
  int modeDashboardPemetaan = 0;
  bool _isSpvArea = false;
  List<GeoHD> listDashboardPemetaan = [];

  void setModeDashboardPemetaan(String value, tgl1, tgl2, List<GeoHD> list) {
    switch (currentURL) {
      case 'DASHBOARD PEMETAAN':
        modeDashboardPemetaan = 0;
        tgldashboardpemetaan1 = tgl1;
        tgldashboardpemetaan2 = tgl2;
        listDashboardPemetaan = list;
        if (value == 'DASHBOARD') setState(() => modeDashboardPemetaan = 1);
        break;
      default:
    }
  }

  void getURlPowerBI(String url) => setState(() {
        currentURL = url;
        ui.platformViewRegistry.registerViewFactory(viewID, (int viewId) {
          final element = web.HTMLIFrameElement()
            ..src = currentURL
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.zoom = '80%';
          //..style.height = 'calc(100% + 30px)';
          return element;
        });
      });

  void getURLMenuBasra(String url) {
    if (url == 'DASHBOARD PEMETAAN') modeDashboardPemetaan = 0;
    setState(() => currentURL = url);
  }

  @override
  void initState() {
    currentURL = linkBIOperationalDealerReport;
    getURlPowerBI(currentURL);
    super.initState();
    isSpvArea().then((value) {
      if (mounted && value != _isSpvArea) setState(() => _isSpvArea = value);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.softCharcoal,
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1.0),
            ),
          ),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () {
                context.replaceNamed(RoutesConstant.menu);
              },
            ),
            title: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: WTombolLinkPowerBI(
                            'REPORT',
                            'assets/images/operational-dealer-report.png',
                            linkBIOperationalDealerReport,
                            (currentURL == linkBIOperationalDealerReport)
                                ? Colors.white
                                : const Color.fromRGBO(34, 137, 221, 1.0),
                            getURlPowerBI,
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: WTombolLinkPowerBI(
                            'ACTIVITY',
                            'assets/images/operational-dealer-activity.png',
                            'ACTIVITY MANAGER',
                            currentURL == 'ACTIVITY MANAGER' ? Colors.white : const Color.fromRGBO(34, 137, 221, 1.0),
                            getURLMenuBasra,
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: WTombolLinkPowerBI(
                            'TRACKER',
                            'assets/images/operational-dealer-tracker.png',
                            'DASHBOARD PEMETAAN',
                            currentURL == 'DASHBOARD PEMETAAN'
                                ? Colors.white
                                : const Color.fromRGBO(34, 137, 221, 1.0),
                            getURLMenuBasra,
                          ),
                        ),
                        if (!_isSpvArea)
                        SizedBox(
                          width: 140,
                          child: WTombolLinkPowerBI(
                            'TARGET',
                            'assets/images/operational-dealer-target.png',
                            'IMPORT TARGET DEALER',
                            currentURL == 'IMPORT TARGET DEALER'
                                ? Colors.white
                                : const Color.fromRGBO(34, 137, 221, 1.0),
                            getURLMenuBasra,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const WInfoUser(),
                const WTombolLogout(),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: currentURL == 'ACTIVITY MANAGER'
          ? WWebBIManagerActivity()
          : currentURL == 'DASHBOARD PEMETAAN'
              ? modeDashboardPemetaan == 0
                  ? WWebBiFilterDashboardPemetaan(setModeDashboardPemetaan)
                  : WWebBiDashboardPemetaan(
                      tgldashboardpemetaan1, tgldashboardpemetaan2, listDashboardPemetaan)
              : currentURL == 'IMPORT TARGET DEALER'
                  ? WWebBiImportTargetDealer()
                  : HtmlElementView(key: UniqueKey(), viewType: viewID),
    );
  }
}
