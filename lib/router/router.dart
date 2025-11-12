import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_history.dart';
import 'package:stsj/alokasi-bm/pages/p_koreksi_alokasi_bm.dart';
import 'package:stsj/core/cleanArc/dashboard_service/dashboardmain.dart';
import 'package:stsj/core/cleanArc/dashboard_service/models/dashboard.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/dashboard01.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/dashboard02.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/dashboard03.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/dashboard04.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/dashboard05.dart';
import 'package:stsj/core/views/activities/activities_point.dart';
import 'package:stsj/core/views/activities/edit_activites_point.dart';
import 'package:stsj/core/views/activities/manager_activities.dart';
import 'package:stsj/core/views/activities/sales_activities.dart';
import 'package:stsj/core/views/activities/carousel_route_details.dart';
import 'package:stsj/core/views/activities/image_preview.dart';
import 'package:stsj/core/views/activities/map.dart';
import 'package:stsj/core/views/activities/route_details.dart';
import 'package:stsj/core/views/activities/weekly_activities_report.dart';
import 'package:stsj/core/views/report/absent_history.dart';
import 'package:stsj/core/views/report/bike_history.dart';
import 'package:stsj/core/views/report/browse_salesman.dart';
import 'package:stsj/core/views/report/mds_sparepart_stock.dart';
import 'package:stsj/core/views/report/service_history.dart';
import 'package:stsj/core/views/sales_dashboard/delivery.dart';
import 'package:stsj/core/views/sales_dashboard/delivery_approval.dart';
import 'package:stsj/core/views/sales_dashboard/delivery_map.dart';
import 'package:stsj/core/views/report/branch_free_stock.dart';
import 'package:stsj/core/views/sales_dashboard/delivery_monthly.dart';
import 'package:stsj/core/views/sales_dashboard/delivery_monthly_detail.dart';
import 'package:stsj/core/views/sales_dashboard/packing.dart';
import 'package:stsj/core/views/sales_dashboard/picking.dart';
import 'package:stsj/dashboard-fixup/pages/dashboard1_page.dart';
import 'package:stsj/dashboard-fixup/pages/dashboard2_page.dart';
import 'package:stsj/dashboard-fixup/pages/dashboard3_page.dart';
import 'package:stsj/dashboard-fixup/pages/dashboard4_page.dart';
import 'package:stsj/dashboard-fixup/pages/dashboard5_page.dart';
import 'package:stsj/dashboard-fixup/pages/import_excel.dart';
import 'package:stsj/global/globalVar.dart';
import 'package:stsj/global/widget/open_map.dart';
import 'package:stsj/alokasi-bm/pages/p_import_alokasi_bm.dart';

import 'package:stsj/router/not_found_page.dart';
import 'package:stsj/router/router_const.dart';
import 'package:stsj/core/views/Akun/akun_pages.dart';
import 'package:stsj/core/views/Sales_Dashboard/subpages/STUbyLeasingArea_pages/STUbyleasingArea_pages.dart';
import 'package:stsj/core/cleanArc/ServiceInput/presentasion/views/ServiceDashboard.dart';
import 'package:stsj/core/views/home_main_pages.dart';
import 'package:stsj/core/views/Login/login_pages.dart';
import 'package:stsj/core/views/Menu/menu_pages.dart';
import 'package:stsj/core/views/Otorisasi/OtorisasiSPK/OtorisasiSPK.dart';
import 'package:stsj/core/views/Otorisasi/otorisasi_mutasi_pages.dart';
import 'package:stsj/core/views/Otorisasi/otorisasi_pages.dart';
import 'package:stsj/core/views/report/report_Mainpages.dart';
import 'package:stsj/core/views/Sales_Dashboard/salesDashboard_mainpages.dart';
import 'package:stsj/core/views/Sales_Dashboard/subpages/STUbyGroupArea_pages/STUbyGroupArea.dart';
import 'package:stsj/core/views/Sales_Dashboard/subpages/STUbyDate_pages/STUbydate_pages.dart';
import 'package:stsj/core/views/Sales_Dashboard/subpages/STUbycategoryTotal_pages/categoryTotal_Pages.dart';
import 'package:stsj/core/views/Sales_Dashboard/subpages/STUkabArea_pages/kabArea_pages.dart';
import 'package:stsj/core/views/sales_dashboard/subpages/STUbyDP+Category_pages/STUbyDPCategoryArea_pages.dart';
import 'package:stsj/core/views/sales_dashboard/subpages/STUbyLeasingGroupCC/STUbyleasingGroupCC_pages.dart';

class RouterSettings {
  static Future<String?> redirect(
      BuildContext context, GoRouterState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("Status") == true) {
      GlobalVar.username = prefs.getString("UserID") ?? '';
      return null;
    }

    return state.namedLocation(RoutesConstant.login);
  }

  static final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: redirect,
    routes: <GoRoute>[
      GoRoute(
        name: RoutesConstant.homepage,
        path: '/',
        builder: (context, state) => HomePages(),
        routes: [
          GoRoute(
            name: RoutesConstant.login,
            path: 'login',
            pageBuilder: (context, state) {
              return MaterialPage(child: LoginPages());
            },
          ),
          GoRoute(
            name: RoutesConstant.account,
            path: 'account',
            pageBuilder: (context, state) {
              return MaterialPage(child: AkunPage());
            },
          ),
          GoRoute(
            name: RoutesConstant.report,
            path: 'report',
            pageBuilder: (context, state) {
              return MaterialPage(child: ReportPages());
            },
          ),
          // ~:NEW:~
          GoRoute(
            name: RoutesConstant.fpm1stDashboard,
            path: 'dashboard',
            pageBuilder: (context, state) {
              return MaterialPage(child: Dashboard1Page());
            },
          ),
          GoRoute(
            name: RoutesConstant.fpm2ndDashboard,
            path: 'dailyBengkel',
            pageBuilder: (context, state) {
              return MaterialPage(child: Dashboard2Page());
            },
          ),
          GoRoute(
            name: RoutesConstant.fpm3rdDashboard,
            path: 'dailyMekanik',
            pageBuilder: (context, state) {
              return MaterialPage(child: Dashboard3Page());
            },
          ),
          GoRoute(
            name: RoutesConstant.fpm4thDashboard,
            path: 'bengkelBulanan',
            pageBuilder: (context, state) {
              return MaterialPage(child: Dashboard4Page());
            },
          ),
          GoRoute(
            name: RoutesConstant.fpmImportExcel,
            path: 'importExcel',
            pageBuilder: (context, state) {
              return MaterialPage(child: ImportExcel());
            },
          ),
          GoRoute(
            name: RoutesConstant.branchFreeStock,
            path: 'branchFreeStock',
            pageBuilder: (context, state) {
              return MaterialPage(child: BranchFreeStockPage());
            },
          ),
          GoRoute(
            name: RoutesConstant.fpm5thDashboard,
            path: 'memberReport',
            pageBuilder: (context, state) {
              return MaterialPage(child: Dashboard5Page());
            },
          ),
          GoRoute(
            name: RoutesConstant.absentHistory,
            path: 'absentHistory',
            pageBuilder: (context, state) {
              return MaterialPage(child: AbsentHistoryPage());
            },
          ),
          GoRoute(
            name: RoutesConstant.browseSalesman,
            path: 'browseSalesman',
            pageBuilder: (context, state) {
              return MaterialPage(child: BrowseSalesmanPage());
            },
          ),
          GoRoute(
            name: RoutesConstant.bikesHistory,
            path: 'bikesHistory',
            pageBuilder: (context, state) {
              return MaterialPage(child: BikesHistoryPage());
            },
          ),
          GoRoute(
            name: RoutesConstant.serviceHistory,
            path: 'serviceHistory',
            pageBuilder: (context, state) {
              return MaterialPage(child: ServiceHistoryPage());
            },
          ),
          GoRoute(
            name: RoutesConstant.mdsSparepartStock,
            path: 'mdsSparepartStock',
            pageBuilder: (context, state) {
              return MaterialPage(child: MdsSparepartStockPage());
            },
          ),
          // ~:NEW:~
          GoRoute(
            name: RoutesConstant.menu,
            path: 'menu',
            pageBuilder: (context, state) {
              return MaterialPage(child: MenuPages());
            },
          ),
          GoRoute(
            name: RoutesConstant.otorisasiMutasi,
            path: 'otorisasiMutasi',
            pageBuilder: (context, state) {
              return MaterialPage(child: OtorisasiMutasiPages());
            },
          ),
          GoRoute(
            name: RoutesConstant.otorisasi,
            path: 'authorization',
            pageBuilder: (context, state) {
              return MaterialPage(child: OtoriasiPages());
            },
          ),
          GoRoute(
            name: RoutesConstant.dashboardService,
            path: 'dashboardService',
            pageBuilder: (context, state) {
              return MaterialPage(child: DashboardServiceMain());
            },
          ),
          GoRoute(
            name: RoutesConstant.delivery,
            path: 'delivery',
            pageBuilder: (context, state) {
              return MaterialPage(child: DeliveryPage());
            },
            routes: [
              GoRoute(
                name: RoutesConstant.mapDelivery,
                path: 'detilMap',
                pageBuilder: (context, state) {
                  return MaterialPage(child: DeliveryMap());
                },
              ),
            ],
          ),
          GoRoute(
            name: RoutesConstant.deliveryApproval,
            path: 'deliveryApproval',
            pageBuilder: (context, state) {
              return MaterialPage(child: DeliveryApproval());
            },
          ),
          GoRoute(
            name: RoutesConstant.deliveryMonthly,
            path: 'deliveryMonthly',
            pageBuilder: (context, state) {
              return MaterialPage(child: DeliveryMonthly());
            },
          ),
          GoRoute(
            name: RoutesConstant.picking,
            path: 'picking',
            pageBuilder: (context, state) {
              return MaterialPage(child: PickingPage());
            },
          ),
          GoRoute(
            name: RoutesConstant.packing,
            path: 'packing',
            pageBuilder: (context, state) {
              return MaterialPage(child: PackingPage());
            },
          ),
          GoRoute(
            name: RoutesConstant.service,
            path: 'service',
            pageBuilder: (context, state) {
              return MaterialPage(child: ServiceInput());
            },
          ),
          GoRoute(
            name: RoutesConstant.authorizationSPK,
            path: 'otorisasiSPK',
            pageBuilder: (context, state) {
              return MaterialPage(child: OtorisasiSPK());
            },
          ),
          GoRoute(
            name: RoutesConstant.salesDashboard,
            path: 'salesDashboard',
            builder: (context, state) => SalesPages(),
            routes: [
              GoRoute(
                name: RoutesConstant.salesDashboardkab,
                path: 'areakab',
                pageBuilder: (context, state) {
                  return MaterialPage(child: ListKabAreaPages());
                },
              ),
              GoRoute(
                name: RoutesConstant.salesDashboardleasingArea,
                path: 'leasingArea',
                pageBuilder: (context, state) {
                  return MaterialPage(child: ListAreaPages());
                },
              ),
              GoRoute(
                name: RoutesConstant.salesDashboardareaGroup,
                path: 'areaGroup',
                pageBuilder: (context, state) {
                  return MaterialPage(child: GroupAreaPages());
                },
              ),
              GoRoute(
                name: RoutesConstant.salesDashboardleasingDP,
                path: 'leasing-area-dp-category',
                pageBuilder: (context, state) {
                  return MaterialPage(child: DPwithCategoryPages());
                },
              ),
              GoRoute(
                name: RoutesConstant.salesDashboardleasingGroupCC,
                path: 'leasingGroupCC',
                pageBuilder: (context, state) {
                  return MaterialPage(child: GroupLeasingCCAreaPages());
                },
              ),
              GoRoute(
                name: RoutesConstant.salesDashboardtipe,
                path: 'kategoriTipe',
                pageBuilder: (context, state) {
                  return MaterialPage(child: ListCategoryTotal());
                },
              ),
              GoRoute(
                name: RoutesConstant.salesDashboardtipeDaily,
                path: 'kategoriDaily',
                pageBuilder: (context, state) {
                  return MaterialPage(child: ListSTUbyDate());
                },
              ),
            ],
          ),
          // ~:NEW:~
          // Maps
          GoRoute(
            name: RoutesConstant.map,
            path: 'map',
            pageBuilder: (context, state) {
              return MaterialPage(child: MapPage());
            },
            routes: [
              GoRoute(
                name: RoutesConstant.carouselRouteDetails,
                path: 'carouselRouteDetails',
                pageBuilder: (context, state) {
                  return MaterialPage(child: CarouselRouteDetailsPage());
                },
                routes: [
                  GoRoute(
                    name: RoutesConstant.carouselImageView,
                    path: 'carouselImageView',
                    pageBuilder: (context, state) {
                      return MaterialPage(child: ImageView());
                    },
                  ),
                ],
              ),
              GoRoute(
                name: RoutesConstant.routeDetails,
                path: 'routeDetails',
                pageBuilder: (context, state) {
                  return MaterialPage(child: RouteDetailsPage());
                },
                routes: [
                  GoRoute(
                    name: RoutesConstant.routeImageView,
                    path: 'routeImageView',
                    pageBuilder: (context, state) {
                      return MaterialPage(child: ImageView());
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            name: RoutesConstant.salesActivities,
            path: 'salesActivities',
            pageBuilder: (context, state) {
              return MaterialPage(child: SalesActivitiesPage());
            },
          ),
          GoRoute(
            name: RoutesConstant.managerActivities,
            path: 'managerActivities',
            pageBuilder: (context, state) {
              return MaterialPage(child: ManagerActivitiesPage());
            },
            routes: [
              GoRoute(
                name: RoutesConstant.managerActivitiesInMap,
                path: 'managerActivitiesInMap',
                pageBuilder: (context, state) {
                  return MaterialPage(child: OpenMap());
                },
              ),
            ],
          ),
          GoRoute(
            name: RoutesConstant.weeklyActivitiesReport,
            path: 'weeklyActivitiesReport',
            pageBuilder: (context, state) {
              return MaterialPage(child: WeeklyActivitiesReport());
            },
          ),
          GoRoute(
            name: RoutesConstant.activitiesPoint,
            path: 'activitiesPoint',
            pageBuilder: (context, state) {
              return MaterialPage(child: ActivitiesPoint());
            },
            routes: [
              GoRoute(
                name: RoutesConstant.editActivitiesPoint,
                path: 'editActivitiesPoint',
                pageBuilder: (context, state) {
                  return MaterialPage(child: EditActivitiesPoint());
                },
              ),
            ],
          ),
          GoRoute(
            name: RoutesConstant.importAlokasiBM,
            path: 'importAlokasiBM',
            pageBuilder: (context, state) {
              return MaterialPage(child: PImportAlokasiBM());
            },
          ),
          GoRoute(
            name: RoutesConstant.koreksiAlokasiBM,
            path: 'koreksiAlokasiBM',
            pageBuilder: (context, state) {
              return MaterialPage(child: PKoreksiAlokasiBM());
            },
          ),
          GoRoute(
            name: RoutesConstant.historyAktivitasSubDealer,
            path: 'historyAktivitasSubDealer',
            pageBuilder: (context, state) {
              return MaterialPage(child: PSubDealerHistory());
            },
          ),
          // ~:NEW:~
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );

  // static Future<String?> redirect(
  //     BuildContext context, GoRouterState state) async {
  //   // akses Provider di luar widget tree
  //   // LoginModel loginModel = Provider.of<LoginModel>(context, listen: false);
  //   // bool isLogin = loginModel.islogin;

  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   if (prefs.getBool("Status") != true) {
  //     // User is already logged in, return null to stay on the current route.
  //     return '/';
  //   } else {
  //     // Fluttertoast.showToast(
  //     //     msg: "Anda belum login. Silahkan login terlebih dahulu", // message
  //     //     toastLength: Toast.LENGTH_LONG, // length
  //     //     gravity: ToastGravity.CENTER, // location
  //     //     webPosition: "center",
  //     //     webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
  //     //     timeInSecForIosWeb: 2 // duration
  //     //     );
  //   }
  // }
}

class DashboardSelector extends StatelessWidget {
  final String dashboard;
  final List<Dashboard> value;

  DashboardSelector({required this.dashboard, required this.value});

  @override
  Widget build(BuildContext context) {
    switch (dashboard) {
      case 'Dashboard01':
        return Dashboard01(value);
      case 'Dashboard02':
        return Dashboard02(value);
      case 'Dashboard03':
        return Dashboard03(value);
      case 'Dashboard04':
        return Dashboard04(value);
      case 'Dashboard05':
        return Dashboard05(value);
      default:
        throw 'HALAMAN TIDAK DITEMUKAN';
    }
  }
}
