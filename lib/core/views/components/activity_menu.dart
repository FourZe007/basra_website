import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/activity_point/pages/filter_page.dart';
import 'package:stsj/activity_point/pages/point_vs_target.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/service_dialog_filter.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard_pemetaan/pages/filter_dashboard.dart';
import 'package:stsj/router/router_const.dart';

class ActivityMenuComponent extends HookWidget {
  const ActivityMenuComponent({super.key});

  Widget computerView(BuildContext context) {
    final state = Provider.of<MenuState>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            // Peta
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('100')) {
                  print('100 is inside SubHeaderList');
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        // ~:NEW:~
                        // Map
                        _buildMenuIcon(
                          context,
                          'assets/images/maps.png',
                          'Peta',
                          RoutesConstant.map,
                          state,
                        ),
                        const Text('Peta'),
                        // ~:NEW:~
                      ],
                    ),
                  );
                } else {
                  print('100 is not inside SubHeaderList');
                  return const SizedBox();
                }
              },
            ),

            // Aktivitas Sales
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('101')) {
                  print('101 is inside SubHeaderList');
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        // ~:NEW:~
                        // Aktivitas Sales
                        _buildMenuIcon(
                          context,
                          'assets/images/destination.png',
                          'Aktivitas Sales',
                          RoutesConstant.salesActivities,
                          state,
                        ),
                        const Text('Aktivitas Sales'),
                        // ~:NEW:~
                      ],
                    ),
                  );
                } else {
                  print('101 is not inside SubHeaderList');
                  return const SizedBox();
                }
              },
            ),

            // Aktivitas Manager
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('110')) {
                  print('110 is inside SubHeaderList');
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        // ~:NEW:~
                        // Aktivitas Manager
                        _buildMenuIcon(
                          context,
                          'assets/images/activity.png',
                          'Aktivitas Manager',
                          RoutesConstant.managerActivities,
                          state,
                        ),
                        const Text('Aktivitas Manager'),
                        // ~:NEW:~
                      ],
                    ),
                  );
                } else {
                  print('110 is not inside SubHeaderList');
                  return const SizedBox();
                }
              },
            ),

            // Dashboard Pemetaan
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('110')) {
                  print('110 is inside SubHeaderList');
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        // ~:NEW:~
                        // Dashboard Pemetaan
                        _buildMenuIcon(
                          context,
                          'assets/images/destination.png',
                          'Dashboard Pemetaan',
                          RoutesConstant.filterPemetaan,
                          state,
                        ),
                        const Text('Dashboard Pemetaan'),
                        // ~:NEW:~
                      ],
                    ),
                  );
                } else {
                  print('110 is not inside SubHeaderList');
                  return const SizedBox();
                }
              },
            ),

            // Aktivitas Mingguan
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('111')) {
                  print('111 is inside SubHeaderList');
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        // ~:NEW:~
                        // Aktivitas Mingguan
                        _buildMenuIcon(
                          context,
                          'assets/images/weekly.png',
                          'Aktivitas Mingguan',
                          RoutesConstant.weeklyActivitiesReport,
                          state,
                        ),
                        const Text('Aktivitas Mingguan'),
                        // ~:NEW:~
                      ],
                    ),
                  );
                } else {
                  print('111 is not inside SubHeaderList');
                  return const SizedBox();
                }
              },
            ),

            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('113')) {
                  print('101 is inside SubHeaderList');
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        // ~:NEW:~
                        // Aktivitas Sales
                        _buildMenuIcon(
                          context,
                          'assets/images/subdealer.png',
                          'Aktivitas SubDealer',
                          RoutesConstant.historyAktivitasSubDealer,
                          state,
                        ),
                        const Text('Aktivitas SubDealer'),
                        // ~:NEW:~
                      ],
                    ),
                  );
                } else {
                  print('101 is not inside SubHeaderList');
                  return const SizedBox();
                }
              },
            ),

            // Points
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('112')) {
                  print('112 is inside SubHeaderList');
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        // ~:NEW:~
                        // Points
                        _buildMenuIcon(
                          context,
                          'assets/images/coin.png',
                          'Points',
                          RoutesConstant.filterPoint,
                          state,
                        ),
                        const Text('Points'),
                        // ~:NEW:~
                      ],
                    ),
                  );
                } else {
                  print('112 is not inside SubHeaderList');
                  return const SizedBox();
                }
              },
            ),

            // Import Target
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('110')) {
                  print('110 is inside SubHeaderList');
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        // ~:NEW:~
                        // Points
                        _buildMenuIcon(
                          context,
                          'assets/images/goal.png',
                          'Import Target',
                          RoutesConstant.importTargetActivities,
                          state,
                        ),
                        const Text('Import Target'),
                        // ~:NEW:~
                      ],
                    ),
                  );
                } else {
                  print('110 is not inside SubHeaderList');
                  return const SizedBox();
                }
              },
            ),

            // Target VS Result
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('110')) {
                  print('110 is inside SubHeaderList');
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        // ~:NEW:~
                        // Points
                        _buildMenuIcon(
                          context,
                          'assets/images/progress-report.png',
                          'Target VS Result',
                          RoutesConstant.targetResult,
                          state,
                        ),
                        const Text('Target VS Result'),
                        // ~:NEW:~
                      ],
                    ),
                  );
                } else {
                  print('110 is not inside SubHeaderList');
                  return const SizedBox();
                }
              },
            ),

            // Dashboard Power BI
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('110')) {
                  print('110 is inside SubHeaderList');
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        // ~:NEW:~
                        // Points
                        _buildMenuIcon(
                          context,
                          'assets/images/dashboard-2.png',
                          'Dashboard Marketing',
                          RoutesConstant.dashboardMarketing,
                          state,
                        ),
                        const Text('Dashboard Marketing'),
                        // ~:NEW:~
                      ],
                    ),
                  );
                } else {
                  print('110 is not inside SubHeaderList');
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget mobileView(BuildContext context) {
    final state = Provider.of<MenuState>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        runSpacing: 15,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Peta
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.getSubHeaderList.contains('100')) {
                      print('100 is inside SubHeaderList');
                      return Column(
                        children: [
                          // ~:NEW:~
                          // Map
                          _buildMenuIcon(
                            context,
                            'assets/images/maps.png',
                            'Peta',
                            RoutesConstant.map,
                            state,
                          ),
                          const Text('Peta'),
                          // ~:NEW:~
                        ],
                      );
                    } else {
                      print('100 is not inside SubHeaderList');
                      return const SizedBox();
                    }
                  },
                ),
              ),

              // Aktivitas Sales
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.getSubHeaderList.contains('101')) {
                      print('101 is inside SubHeaderList');
                      return Column(
                        children: [
                          // ~:NEW:~
                          // Aktivitas Sales
                          _buildMenuIcon(
                            context,
                            'assets/images/destination.png',
                            'Aktivitas Sales',
                            RoutesConstant.salesActivities,
                            state,
                          ),
                          const Text('Aktivitas Sales'),
                          // ~:NEW:~
                        ],
                      );
                    } else {
                      print('101 is not inside SubHeaderList');
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Aktivitas Manager
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.getSubHeaderList.contains('110')) {
                      print('110 is inside SubHeaderList');
                      return Column(
                        children: [
                          // ~:NEW:~
                          // Aktivitas Manager
                          _buildMenuIcon(
                            context,
                            'assets/images/activity.png',
                            'Aktivitas Manager',
                            RoutesConstant.managerActivities,
                            state,
                          ),
                          const Text('Aktivitas Manager'),
                          // ~:NEW:~
                        ],
                      );
                    } else {
                      print('110 is not inside SubHeaderList');
                      return const SizedBox();
                    }
                  },
                ),
              ),

              // Dashboard Pemetaan
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.getSubHeaderList.contains('110')) {
                      print('110 is inside SubHeaderList');
                      return Column(
                        children: [
                          // ~:NEW:~
                          // Dashboard Pemetaan
                          _buildMenuIcon(
                            context,
                            'assets/images/destination.png',
                            'Dashboard Pemetaan',
                            RoutesConstant.filterPemetaan,
                            state,
                          ),
                          const Text('Dashboard Pemetaan'),
                          // ~:NEW:~
                        ],
                      );
                    } else {
                      print('110 is not inside SubHeaderList');
                      return const SizedBox();
                    }
                  },
                ),
              ),

              // Aktivitas Mingguan
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.getSubHeaderList.contains('111')) {
                      print('111 is inside SubHeaderList');
                      return Column(
                        children: [
                          // ~:NEW:~
                          // Aktivitas Mingguan
                          _buildMenuIcon(
                            context,
                            'assets/images/weekly.png',
                            'Aktivitas Mingguan',
                            RoutesConstant.weeklyActivitiesReport,
                            state,
                          ),
                          const Text('Aktivitas Mingguan'),
                          // ~:NEW:~
                        ],
                      );
                    } else {
                      print('111 is not inside SubHeaderList');
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),

          Builder(
            builder: (context) {
              if (state.getSubHeaderList.contains('113')) {
                print('101 is inside SubHeaderList');
                return Container(
                  margin: EdgeInsets.only(right: 50.0),
                  child: Column(
                    children: [
                      // ~:NEW:~
                      // Aktivitas Sales
                      _buildMenuIcon(
                        context,
                        'assets/images/subdealer.png',
                        'Aktivitas SubDealer',
                        RoutesConstant.historyAktivitasSubDealer,
                        state,
                      ),
                      const Text('Aktivitas SubDealer'),
                      // ~:NEW:~
                    ],
                  ),
                );
              } else {
                print('101 is not inside SubHeaderList');
                return const SizedBox();
              }
            },
          ),

          // Points
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.getSubHeaderList.contains('112')) {
                      print('112 is inside SubHeaderList');
                      return Column(
                        children: [
                          // ~:NEW:~
                          // Points
                          _buildMenuIcon(
                            context,
                            'assets/images/coin.png',
                            'Points',
                            RoutesConstant.filterPoint,
                            state,
                          ),
                          const Text('Points'),
                          // ~:NEW:~
                        ],
                      );
                    } else {
                      print('112 is not inside SubHeaderList');
                      return const SizedBox();
                    }
                  },
                ),
              ),

              // for UI purpose only
              // Expanded(
              //   child: Builder(
              //     builder: (context) {
              //       if (state.getSubHeaderList.contains('0')) {
              //         print('112 is inside SubHeaderList');
              //         return Column(
              //           children: [
              //             // ~:NEW:~
              //             // Points
              //             _buildMenuIcon(
              //               context,
              //               'assets/images/coin.png',
              //               'Peta',
              //               RoutesConstant.activitiesPoint,
              //               state,
              //             ),
              //             const Text('Points'),
              //             // ~:NEW:~
              //           ],
              //         );
              //       } else {
              //         print('112 is not inside SubHeaderList');
              //         return const SizedBox();
              //       }
              //     },
              //   ),
              // ),
            ],
          ),

          // Import Target
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.getSubHeaderList.contains('110')) {
                      print('110 is inside SubHeaderList');
                      return Column(
                        children: [
                          // ~:NEW:~
                          // Points
                          _buildMenuIcon(
                            context,
                            'assets/images/goal.png',
                            'Import Target',
                            RoutesConstant.importTargetActivities,
                            state,
                          ),
                          const Text('Import Target'),
                          // ~:NEW:~
                        ],
                      );
                    } else {
                      print('110 is not inside SubHeaderList');
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),

          // Target VS Result
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.getSubHeaderList.contains('110')) {
                      print('110 is inside SubHeaderList');
                      return Column(
                        children: [
                          // ~:NEW:~
                          // Points
                          _buildMenuIcon(
                            context,
                            'assets/images/progress-report.png',
                            'Target VS Result',
                            RoutesConstant.targetResult,
                            state,
                          ),
                          const Text('Target VS Result'),
                          // ~:NEW:~
                        ],
                      );
                    } else {
                      print('110 is not inside SubHeaderList');
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),

          // Dashboard Power BI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.getSubHeaderList.contains('110')) {
                      print('110 is inside SubHeaderList');
                      return Column(
                        children: [
                          // ~:NEW:~
                          // Points
                          _buildMenuIcon(
                            context,
                            'assets/images/dashboard-2.png',
                            'Dashboard Marketing',
                            RoutesConstant.dashboardMarketing,
                            state,
                          ),
                          const Text('Dashboard Marketing'),
                          // ~:NEW:~
                        ],
                      );
                    } else {
                      print('110 is not inside SubHeaderList');
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() => null);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= constraints.maxHeight) {
          return computerView(context);
        } else {
          return mobileView(context);
        }
      },
    );
  }

  Widget _buildMenuIcon(
    BuildContext context,
    String imagePath,
    String tooltip,
    String route,
    MenuState state,
  ) {
    final isHovered = ValueNotifier<bool>(false);
    final tooltipNull = ValueNotifier<bool>(false);

    return MouseRegion(
      onEnter: (_) {
        isHovered.value = true;
      },
      onExit: (_) {
        isHovered.value = false;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isHovered,
        builder: (context, hovered, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 1024) {
                return AnimatedContainer(
                  width: 100.0,
                  height: 100.0,
                  duration: Duration(milliseconds: 100),
                  padding: EdgeInsets.all(hovered ? 10.0 : 0.0),
                  child: IconButton(
                    onPressed: () async {
                      tooltipNull.value = true;
                      if (tooltip == 'Dashboard Service') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => ServiceDialogFilter(),
                        );
                      } else if (tooltip == 'Aktivitas Manager') {
                        await state.fetchProvinces().then((_) {
                          if (context.mounted) context.goNamed(route);
                        });
                      } else if (tooltip == 'Dashboard Pemetaan') {
                        await state.fetchProvinces().then((_) {
                          if (context.mounted) showDialog(context: context, builder: (BuildContext context) => FilterDashboard());
                        });
                      } else if (tooltip == 'Points') {
                        await state.fetchProvinces().then((_) {
                          if (context.mounted) showDialog(context: context, builder: (BuildContext context) => FilterPage());
                        });
                      } else if (tooltip == 'Target VS Result') {
                        await state.fetchProvinces().then((_) {
                          if (context.mounted) showDialog(context: context, builder: (BuildContext context) => PointVsTarget());
                        });
                      } else {
                        context.goNamed(route);
                      }

                      // context.goNamed(route);
                    },
                    icon: Image.asset(imagePath),
                  ),
                );
              } else {
                return AnimatedContainer(
                  width: 80.0,
                  height: 80.0,
                  duration: Duration(milliseconds: 100),
                  padding: EdgeInsets.all(hovered ? 10.0 : 0.0),
                  child: IconButton(
                    onPressed: () async {
                      tooltipNull.value = true;
                      if (tooltip == 'Dashboard Service') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => ServiceDialogFilter(),
                        );
                      } else if (tooltip == 'Aktivitas Manager') {
                        await state.fetchProvinces().then((_) {
                          if (context.mounted) context.goNamed(route);
                        });
                      } else if (tooltip == 'Dashboard Pemetaan') {
                        await state.fetchProvinces().then((_) {
                          if (context.mounted) showDialog(context: context, builder: (BuildContext context) => FilterDashboard());
                        });
                      } else if (tooltip == 'Points') {
                        await state.fetchProvinces().then((_) {
                          if (context.mounted) showDialog(context: context, builder: (BuildContext context) => FilterPage());
                        });
                      } else if (tooltip == 'Target VS Result') {
                        await state.fetchProvinces().then((_) {
                          if (context.mounted) showDialog(context: context, builder: (BuildContext context) => PointVsTarget());
                        });
                      } else {
                        context.goNamed(route);
                      }

                      // context.goNamed(route);
                    },
                    icon: Image.asset(imagePath),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
