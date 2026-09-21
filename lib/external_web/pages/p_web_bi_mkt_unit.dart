import 'package:flutter/material.dart';
import 'package:stsj/external_web/utilities/global.dart';
import 'package:stsj/external_web/widget/w_info_user.dart';
import 'package:stsj/external_web/widget/w_tombol_link_powerbi.dart';
import 'package:stsj/external_web/widget/w_tombol_logout.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;
import 'package:go_router/go_router.dart';
import 'package:stsj/router/router_const.dart';

class PWebBIMktUnit extends StatefulWidget {
  const PWebBIMktUnit({super.key});

  @override
  State<PWebBIMktUnit> createState() => _PowerbiView1State();
}

class _PowerbiView1State extends State<PWebBIMktUnit> {
  String currentURL = '';
  final String viewID = "unit-iframe";

  void checkBeginMonth() {
    var date = DateTime.now();
    print('a');
    if (DateTime(date.year, date.month, date.day).day == 1 ||
        DateTime(date.year, date.month, date.day).day == 2) {
      currentURL = linkBIEndMonth;
    } else {
      bool isEndMonth = checkEndMonth(DateTime.now());
      if (isEndMonth) {
        currentURL = linkBIEndMonth;
      } else {
        currentURL = linkBIDaily;
      }
    }
  }

  bool checkEndMonth(DateTime date) {
    return DateTime(date.year, date.month, date.day + 1).day == 1;
  }

  void reloadPage(String url) => setState(() {
        if (url == linkBIDaily || url == linkBIEndMonth) {
          checkBeginMonth();
        } else if (url == linkBIProductivity) {
          currentURL = linkBIProductivity;
        } else if (url == linkBISummary) {
          currentURL = linkBISummary;
        } else {
          currentURL = linkBIPSI;
        }

        ui.platformViewRegistry.registerViewFactory(viewID, (int viewId) {
          final element = web.HTMLIFrameElement()
            ..src = currentURL
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = 'calc(100% + 30px)';
          return element;
        });
      });

  @override
  void initState() {
    bool isEndMonth = checkEndMonth(DateTime.now());
    isEndMonth ? currentURL = linkBIEndMonth : currentURL = linkBIDaily;
    reloadPage(currentURL);
    super.initState();
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
                            'DAILY',
                            'assets/images/PowerBIDaily.png',
                            linkBIDaily,
                            (currentURL == linkBIDaily || currentURL == linkBIEndMonth)
                                ? Colors.white
                                : const Color.fromRGBO(34, 137, 221, 1.0),
                            reloadPage,
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: WTombolLinkPowerBI(
                            'MONTHLY',
                            'assets/images/PowerBIEndMonth.png',
                            linkBIProductivity,
                            currentURL == linkBIProductivity ? Colors.white : const Color.fromRGBO(34, 137, 221, 1.0),
                            reloadPage,
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: WTombolLinkPowerBI(
                            'SUMMARY',
                            'assets/images/PowerBISummary.png',
                            linkBISummary,
                            currentURL == linkBISummary ? Colors.white : const Color.fromRGBO(34, 137, 221, 1.0),
                            reloadPage,
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: WTombolLinkPowerBI(
                            'PSI',
                            'assets/images/PowerBIPSI.png',
                            linkBIPSI,
                            currentURL == linkBIPSI ? Colors.white : const Color.fromRGBO(34, 137, 221, 1.0),
                            reloadPage,
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
      body: HtmlElementView(key: UniqueKey(), viewType: viewID),
    );
  }
}
