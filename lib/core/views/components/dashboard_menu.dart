import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/service_dialog_filter.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/pages/fpm_dialog_filter.dart';
import 'package:stsj/router/router_const.dart';

class DashboardMenuComponent extends HookWidget {
  DashboardMenuComponent({super.key});

  final Map<int, String> allowedPages = {
    001: 'Peta',
    002: 'Sales',
  };

  @override
  Widget build(BuildContext context) {
    useEffect(() => null);
    final state = Provider.of<MenuState>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            // ~:Sales Dashboard:~
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('000')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/sales.png',
                          'Sales Dashboard',
                          RoutesConstant.salesDashboard,
                        ),
                        const Text('Sales Dashboard'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            // ~:Service Dashboard:~
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('002')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/dashboard.png',
                          'Dashboard Service',
                          RoutesConstant.dashboardService,
                        ),
                        const Text('Dashboard Service'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            // ~:Delivery:~
            Builder(
              builder: (context) {
                // With User Access
                if (state.getSubHeaderList.contains('003')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/delivery.png',
                          'Delivery',
                          RoutesConstant.delivery,
                        ),
                        const Text('Delivery'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            // ~:Delivery Approval:~
            Builder(
              builder: (context) {
                // With User Access
                if (state.getSubHeaderList.contains('006')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/authorization.png',
                          'Delivery Approval',
                          RoutesConstant.deliveryApproval,
                        ),
                        const Text('Delivery Approval'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            // ~:Delivery Monthly:~
            Builder(
              builder: (context) {
                // With User Access
                if (state.getSubHeaderList.contains('007')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/delivery_monthly.png',
                          'Delivery Monthly',
                          RoutesConstant.deliveryMonthly,
                        ),
                        const Text('Delivery Monthly'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            // ~:Picking PIC:~
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('004')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/picking.png',
                          'Delivery',
                          RoutesConstant.picking,
                        ),
                        const Text('Picking'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            // ~:Packing PIC:~
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('005')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/packing.png',
                          'Delivery',
                          RoutesConstant.packing,
                        ),
                        const Text('Packing'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            // ~:FPM Dashboard:~
            Builder(
              builder: (context) {
                if (state.getCompanyAuthorization.contains('SAMP')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/dashboard-2.png',
                          'FPM Dashboard',
                          RoutesConstant.fpmDashboard,
                        ),
                        const Text('FPM Dashboard'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            // ~:FPM Import Excel:~
            Builder(
              builder: (context) {
                if (state.getCompanyAuthorization.contains('SAMP')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/upload.png',
                          'FPM Upload Excel',
                          RoutesConstant.fpmImportExcel,
                        ),
                        const Text('FPM Import Excel'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuIcon(
    BuildContext context,
    String imagePath,
    String tooltip,
    String route,
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
        builder: (context, hovered, child) {
          return AnimatedContainer(
            width: 100.0,
            height: 100.0,
            duration: Duration(milliseconds: 100),
            padding: EdgeInsets.all(hovered ? 10.0 : 0.0),
            child: IconButton(
              onPressed: () {
                tooltipNull.value = true;
                if (tooltip == 'Dashboard Service') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ServiceDialogFilter(),
                  );
                } else if (tooltip == 'FPM Dashboard') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => FPMDialogFilter(),
                  );
                } else {
                  context.goNamed(route);
                }

                // context.goNamed(route);
              },
              icon: Image.asset(imagePath),
            ),
          );
        },
      ),
    );
  }
}
