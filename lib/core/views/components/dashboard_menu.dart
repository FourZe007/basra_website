import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/service_dialog_filter.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/pages/fpm_dialog_filter.dart';
import 'package:stsj/global/theme/app_theme.dart';
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

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: isHovered,
        builder: (context, hovered, child) {
          return AnimatedContainer(
            width: 88.0,
            height: 88.0,
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: hovered ? AppColors.secondaryMaroon : AppColors.darkGrey,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hovered ? AppColors.accentYellow : AppColors.border,
                width: hovered ? 1.5 : 1.0,
              ),
              boxShadow: hovered
                  ? [
                      BoxShadow(
                        color: AppColors.accentYellow.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
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
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
