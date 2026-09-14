// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/core/providers/refresh_detector.dart';
import 'package:stsj/core/views/components/authorization_menu.dart';
import 'package:stsj/core/views/components/dashboard_menu.dart';
import 'package:stsj/core/views/components/report_menu.dart';
import 'package:stsj/core/views/components/activity_menu.dart';
import 'package:stsj/core/views/components/tools_menu.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/router/router_const.dart';
import 'package:stsj/global/widget/app_bar.dart';

class MenuPages extends StatefulWidget {
  const MenuPages({super.key});

  @override
  State<MenuPages> createState() => _MenuPagesState();
}

class _MenuPagesState extends State<MenuPages> with AutomaticKeepAliveClientMixin<MenuPages> {
  late RefreshDetector refreshDetector;

  String staticMenu = '';
  // Note -> temporary variable to enable dashboard menu
  // bool isDeliveryEnable = true;

  void setStaticMenu(
    MenuState state,
    String value,
  ) {
    staticMenu = value;
    print('Static Menu: $staticMenu');
    state.staticMenuNotifier.value = value;
  }

  void displayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Peringatan!'),
          content: Text(
            'Anda tidak diizinkan mengakses menu ini.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget computerView(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(goBack: RoutesConstant.homepage),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.075,
        ),
        child: Consumer<MenuState>(
          builder: (context, state, _) {
            if (state.headerList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // ===================== Dashboard Menu ======================
                        Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Builder(
                            builder: (context) {
                              // Note --> command for a while to enable global menu
                              if (state.getHeaderList.contains('DASHBOARD')) {
                                print('Contains Dashboard');
                                return InkWell(
                                  onTap: () => setStaticMenu(state, 'dashboard'),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red[800]!,
                                          Colors.red[600]!,
                                          Colors.red[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Dashboard',
                                      style: GlobalFont.mediumgiantfontRBoldWhite,
                                    ),
                                  ),
                                );
                              } else {
                                print('Not Contains Dashboard');
                                return InkWell(
                                  onTap: () => displayDialog(context),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey[800]!,
                                          Colors.grey[600]!,
                                          Colors.grey[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Dashboard',
                                      style: GlobalFont.mediumgiantfontRBoldWhite,
                                    ),
                                  ),
                                );
                                // return SizedBox();
                              }

                              // Note --> always enable in case, there are more than 1 global menu
                              // return InkWell(
                              //   onTap: () => setStaticMenu(state, 'dashboard'),
                              //   hoverColor: Colors.transparent,
                              //   child: Container(
                              //     width:
                              //         MediaQuery.of(context).size.width * 0.15,
                              //     alignment: Alignment.center,
                              //     decoration: ShapeDecoration(
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(20.0),
                              //       ),
                              //       gradient: LinearGradient(
                              //         colors: [
                              //           Colors.red[800]!,
                              //           Colors.red[600]!,
                              //           Colors.red[400]!,
                              //         ],
                              //         begin: Alignment.topLeft,
                              //         end: Alignment.bottomRight,
                              //       ),
                              //     ),
                              //     child: Text(
                              //       'Dashboard',
                              //       style: GlobalFont.mediumbigfontRBoldWhite,
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                        ),

                        // ===================== Activity Menu =======================
                        Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Builder(
                            builder: (context) {
                              if (state.getHeaderList.contains('SALES ACTIVITY')) {
                                print('Contains Sales Activity');
                                return InkWell(
                                  onTap: () => setStaticMenu(state, 'activity'),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.amber[700]!,
                                          Colors.amber[600]!,
                                          Colors.amber[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Activity',
                                      style: GlobalFont.mediumgiantfontRBoldWhite,
                                    ),
                                  ),
                                );
                              } else {
                                print('Not Contains Sales Activity');
                                return InkWell(
                                  onTap: () => displayDialog(context),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey[700]!,
                                          Colors.grey[600]!,
                                          Colors.grey[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Activity',
                                      style: GlobalFont.mediumgiantfontRBoldWhite,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        // =================== Authorization Menu ====================
                        Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Builder(
                            builder: (context) {
                              if (state.getHeaderList.contains('AUTHORIZATION')) {
                                print('Contains Authorization');
                                return InkWell(
                                  onTap: () => setStaticMenu(state, 'authorization'),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green[800]!,
                                          Colors.green[600]!,
                                          Colors.green[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Authorization',
                                      style: GlobalFont.mediumgiantfontRBoldWhite,
                                    ),
                                  ),
                                );
                              } else {
                                print('Not Contains Authorization');
                                return InkWell(
                                  onTap: () => displayDialog(context),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey[800]!,
                                          Colors.grey[600]!,
                                          Colors.grey[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Authorization',
                                      style: GlobalFont.mediumgiantfontRBoldWhite,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        // ====================== Report Menu ========================
                        Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Builder(
                            builder: (context) {
                              if (state.getHeaderList.contains('INFORMATION')) {
                                print('Contains Information');
                                return InkWell(
                                  onTap: () => setStaticMenu(state, 'report'),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue[800]!,
                                          Colors.blue[600]!,
                                          Colors.blue[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Information',
                                      style: GlobalFont.mediumgiantfontRBoldWhite,
                                    ),
                                  ),
                                );
                              } else {
                                print('Not Contains Information');
                                return InkWell(
                                  onTap: () => displayDialog(context),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey[800]!,
                                          Colors.grey[600]!,
                                          Colors.grey[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Information',
                                      style: GlobalFont.mediumgiantfontRBoldWhite,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        // ====================== Tools Menu =========================
                        Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Builder(
                            builder: (context) {
                              if (state.getHeaderList.contains('TOOLS')) {
                                print('Contains Tools');
                                return InkWell(
                                  onTap: () => setStaticMenu(state, 'tools'),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.purple[800]!,
                                          Colors.purple[600]!,
                                          Colors.purple[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Tools',
                                      style: GlobalFont.mediumgiantfontRBoldWhite,
                                    ),
                                  ),
                                );
                              } else {
                                print('Not Contains Tools');
                                return InkWell(
                                  onTap: () => displayDialog(context),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey[800]!,
                                          Colors.grey[600]!,
                                          Colors.grey[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Tools',
                                      style: GlobalFont.mediumgiantfontRBoldWhite,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =========================== Devider =============================
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),

                  // ========================= Menu Result ===========================
                  Container(
                    height: MediaQuery.of(context).size.height * 0.66,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.035,
                      vertical: MediaQuery.of(context).size.height * 0.06,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: state.getStaticMenuNotifier,
                      builder: (context, value, _) {
                        if (value == 'dashboard' || value == '') {
                          return DashboardMenuComponent();
                        } else if (value == 'activity') {
                          return ActivityMenuComponent();
                        } else if (value == 'authorization') {
                          return AuthorizationMenuComponent();
                        } else if (value == 'report') {
                          return ReportMenuComponent();
                        } else if (value == 'tools') {
                          return ToolsMenuComponent();
                        }

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text('Please choose your type.'),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget mobileView(BuildContext context, double deviceWidth) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (deviceWidth <= 450)
              ? MediaQuery.of(context).size.height * 0.055
              : MediaQuery.of(context).size.height * 0.085,
        ),
        child: CustomAppBar(
          goBack: RoutesConstant.homepage,
          imageSize: 35,
          profileRadius: 15,
          returnButtonSize: 20,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.05,
        ),
        child: Consumer<MenuState>(
          builder: (context, state, _) {
            if (state.headerList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: (deviceWidth <= 450)
                        ? MediaQuery.of(context).size.height * 0.075
                        : MediaQuery.of(context).size.height * 0.125,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // ======================= Sales Menu ========================
                        Container(
                          width: (deviceWidth <= 450)
                              ? MediaQuery.of(context).size.width * 0.225
                              : MediaQuery.of(context).size.width * 0.125,
                          margin: EdgeInsets.only(right: 20.0),
                          child: Builder(
                            builder: (context) {
                              // Note --> command for a while to enable global menu
                              // if (state.getHeaderList.contains('DASHBOARD')) {
                              //   print('Contains Dashboard');
                              //   return InkWell(
                              //     onTap: () =>
                              //         setStaticMenu(state, 'dashboard'),
                              //     hoverColor: Colors.transparent,
                              //     child: Container(
                              //       alignment: Alignment.center,
                              //       decoration: ShapeDecoration(
                              //         shape: RoundedRectangleBorder(
                              //           borderRadius:
                              //               BorderRadius.circular(20.0),
                              //         ),
                              //         gradient: LinearGradient(
                              //           colors: [
                              //             Colors.red[800]!,
                              //             Colors.red[600]!,
                              //             Colors.red[400]!,
                              //           ],
                              //           begin: Alignment.topLeft,
                              //           end: Alignment.bottomRight,
                              //         ),
                              //       ),
                              //       padding: EdgeInsets.symmetric(
                              //         horizontal:
                              //             MediaQuery.of(context).size.width *
                              //                 0.025,
                              //       ),
                              //       child: Text(
                              //         'Dashboard',
                              //         style: GlobalFont.mediumbigfontRBoldWhite,
                              //       ),
                              //     ),
                              //   );
                              // } else {
                              //   print('Not Contains Dashboard');
                              //   return InkWell(
                              //     onTap: () => displayDialog(context),
                              //     hoverColor: Colors.transparent,
                              //     child: Container(
                              //       alignment: Alignment.center,
                              //       decoration: ShapeDecoration(
                              //         shape: RoundedRectangleBorder(
                              //           borderRadius:
                              //               BorderRadius.circular(20.0),
                              //         ),
                              //         gradient: LinearGradient(
                              //           colors: [
                              //             Colors.grey[800]!,
                              //             Colors.grey[600]!,
                              //             Colors.grey[400]!,
                              //           ],
                              //           begin: Alignment.topLeft,
                              //           end: Alignment.bottomRight,
                              //         ),
                              //       ),
                              //       child: Text(
                              //         'Dashboard',
                              //         style: GlobalFont.mediumbigfontRBoldWhite,
                              //       ),
                              //     ),
                              //   );
                              //   // return SizedBox();
                              // }

                              // Note --> always enable in case, there are more than 1 global menu
                              return InkWell(
                                onTap: () => setStaticMenu(state, 'dashboard'),
                                hoverColor: Colors.transparent,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red[800]!,
                                        Colors.red[600]!,
                                        Colors.red[400]!,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * 0.025,
                                  ),
                                  child: Text(
                                    'Dashboard',
                                    style: GlobalFont.mediumbigfontRBoldWhite,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // ===================== Activity Menu =======================
                        Container(
                          width: (deviceWidth <= 450)
                              ? MediaQuery.of(context).size.width * 0.225
                              : MediaQuery.of(context).size.width * 0.125,
                          margin: EdgeInsets.only(right: 20.0),
                          child: Builder(
                            builder: (context) {
                              if (state.getHeaderList.contains('SALES ACTIVITY')) {
                                print('Contains Sales Activity');
                                return InkWell(
                                  onTap: () => setStaticMenu(state, 'activity'),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.125,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.amber[700]!,
                                          Colors.amber[600]!,
                                          Colors.amber[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Activity',
                                      style: GlobalFont.mediumbigfontRBoldWhite,
                                    ),
                                  ),
                                );
                              } else {
                                print('Not Contains Sales Activity');
                                return InkWell(
                                  onTap: () => displayDialog(context),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.125,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey[700]!,
                                          Colors.grey[600]!,
                                          Colors.grey[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Activity',
                                      style: GlobalFont.mediumbigfontRBoldWhite,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        // =================== Authorization Menu ====================
                        Container(
                          width: (deviceWidth <= 450)
                              ? MediaQuery.of(context).size.width * 0.225
                              : MediaQuery.of(context).size.width * 0.125,
                          margin: EdgeInsets.only(right: 20.0),
                          child: Builder(
                            builder: (context) {
                              if (state.getHeaderList.contains('AUTHORIZATION')) {
                                print('Contains Authorization');
                                return InkWell(
                                  onTap: () => setStaticMenu(state, 'authorization'),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.125,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green[800]!,
                                          Colors.green[600]!,
                                          Colors.green[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Authorization',
                                      style: GlobalFont.mediumbigfontRBoldWhite,
                                    ),
                                  ),
                                );
                              } else {
                                print('Not Contains Authorization');
                                return InkWell(
                                  onTap: () => displayDialog(context),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.125,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey[800]!,
                                          Colors.grey[600]!,
                                          Colors.grey[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Authorization',
                                      style: GlobalFont.mediumbigfontRBoldWhite,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        // ====================== Report Menu ========================
                        Container(
                          width: (deviceWidth <= 450)
                              ? MediaQuery.of(context).size.width * 0.225
                              : MediaQuery.of(context).size.width * 0.125,
                          margin: EdgeInsets.only(right: 20.0),
                          child: Builder(
                            builder: (context) {
                              if (state.getHeaderList.contains('INFORMATION')) {
                                print('Contains Information');
                                return InkWell(
                                  onTap: () => setStaticMenu(state, 'report'),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.125,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue[800]!,
                                          Colors.blue[600]!,
                                          Colors.blue[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Report',
                                      style: GlobalFont.mediumbigfontRBoldWhite,
                                    ),
                                  ),
                                );
                              } else {
                                print('Not Contains Information');
                                return InkWell(
                                  onTap: () => displayDialog(context),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.125,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey[800]!,
                                          Colors.grey[600]!,
                                          Colors.grey[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Report',
                                      style: GlobalFont.mediumbigfontRBoldWhite,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        // ====================== Tools Menu =========================
                        Container(
                          width: (deviceWidth <= 450)
                              ? MediaQuery.of(context).size.width * 0.225
                              : MediaQuery.of(context).size.width * 0.125,
                          margin: EdgeInsets.only(right: 20.0),
                          child: Builder(
                            builder: (context) {
                              if (state.getHeaderList.contains('TOOLS')) {
                                print('Contains Tools');
                                return InkWell(
                                  onTap: () => setStaticMenu(state, 'tools'),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.125,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.purple[800]!,
                                          Colors.purple[600]!,
                                          Colors.purple[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Tools',
                                      style: GlobalFont.mediumbigfontRBoldWhite,
                                    ),
                                  ),
                                );
                              } else {
                                print('Not Contains Tools');
                                return InkWell(
                                  onTap: () => displayDialog(context),
                                  hoverColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.125,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey[800]!,
                                          Colors.grey[600]!,
                                          Colors.grey[400]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      'Tools',
                                      style: GlobalFont.mediumbigfontRBoldWhite,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =========================== Devider =============================
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),

                  // ========================= Menu Result ===========================
                  Container(
                    height: (deviceWidth <= 450)
                        ? MediaQuery.of(context).size.height * 0.7
                        : MediaQuery.of(context).size.height * 0.64,
                    decoration: ShapeDecoration(
                      // color: Colors.grey[350],
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.035,
                      vertical: MediaQuery.of(context).size.height * 0.025,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: state.getStaticMenuNotifier,
                      builder: (context, value, _) {
                        if (value == 'dashboard' || value == '') {
                          return DashboardMenuComponent();
                        } else if (value == 'activity') {
                          return ActivityMenuComponent();
                        } else if (value == 'authorization') {
                          return AuthorizationMenuComponent();
                        } else if (value == 'report') {
                          return ReportMenuComponent();
                        } else if (value == 'tools') {
                          return ToolsMenuComponent();
                        }

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text('Please choose your type.'),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void getCompany() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Company Name: ${prefs.getString('CompanyName') ?? ''}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<MenuState>(context, listen: false).loadHeader();
    Provider.of<MenuState>(context, listen: false).loadSubHeader();
    Provider.of<MenuState>(context, listen: false).readDashboardList();
    Provider.of<MenuState>(context, listen: false).readCompanyAuthorization();
    getCompany();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final companyState = Provider.of<PtModel>(context);
    // final menuState = Provider.of<MenuState>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return computerView(context);
        } else {
          return mobileView(context, constraints.maxWidth);
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
