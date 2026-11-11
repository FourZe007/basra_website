import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/service_dialog_filter.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/pages/fpm_dialog_filter.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/router/router_const.dart';

class DashboardMenuComponent extends HookWidget {
  const DashboardMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() => null);
    final state = Provider.of<MenuState>(context);
    final loginpt = Provider.of<PtModel>(context, listen: false);
    final currentCompany = (state.getCompanyName.isNotEmpty
            ? state.getCompanyName
            : loginpt.getPT)
        .toUpperCase();

    // Check company authorization
    final isSamp = currentCompany == 'SAMP';
    final hasSampAuth = state.getCompanyAuthorization.contains('SAMP');
    final showSampItems = isSamp || hasSampAuth;

    // Check EntryLevelID (support reactive state & SharedPreferences fallback)
    final entryLevelFuture = useMemoized(() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('EntryLevelID') ?? '';
    });
    final entryLevelSnapshot = useFuture(entryLevelFuture);
    final savedLevel = entryLevelSnapshot.data ?? '';
    final entryLevel = (state.getEntryLevelId.isNotEmpty
            ? state.getEntryLevelId
            : savedLevel)
        .trim();
    final bool isLevel50 = entryLevel == '50';

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 450;
            final spacing = isNarrow ? 16.0 : 24.0;
            final itemWidth = isNarrow ? 96.0 : 104.0;
            final iconSize = isNarrow ? 80.0 : 88.0;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              alignment: WrapAlignment.start,
              children: [
                // Non-level 50 items (Hidden for EntryLevelID == 50)
                if (!isLevel50) ...[
                  // ~:Sales Dashboard:~
                  if (state.getSubHeaderList.contains('000'))
                    _buildMenuItem(
                      context,
                      imagePath: 'assets/images/sales.png',
                      label: 'Sales Dashboard',
                      route: RoutesConstant.salesDashboard,
                      itemWidth: itemWidth,
                      iconSize: iconSize,
                    ),

                  // ~:Service Dashboard:~
                  if (state.getSubHeaderList.contains('002'))
                    _buildMenuItem(
                      context,
                      imagePath: 'assets/images/dashboard.png',
                      label: 'Dashboard Service',
                      route: RoutesConstant.dashboardService,
                      itemWidth: itemWidth,
                      iconSize: iconSize,
                      onTapOverride: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => ServiceDialogFilter(),
                        );
                      },
                    ),

                  // ~:Delivery:~
                  if (state.getSubHeaderList.contains('003'))
                    _buildMenuItem(
                      context,
                      imagePath: 'assets/images/delivery.png',
                      label: 'Delivery',
                      route: RoutesConstant.delivery,
                      itemWidth: itemWidth,
                      iconSize: iconSize,
                    ),

                  // ~:Delivery Approval:~
                  if (state.getSubHeaderList.contains('006'))
                    _buildMenuItem(
                      context,
                      imagePath: 'assets/images/authorization.png',
                      label: 'Delivery Approval',
                      route: RoutesConstant.deliveryApproval,
                      itemWidth: itemWidth,
                      iconSize: iconSize,
                    ),

                  // ~:Delivery Monthly:~
                  if (state.getSubHeaderList.contains('007'))
                    _buildMenuItem(
                      context,
                      imagePath: 'assets/images/delivery_monthly.png',
                      label: 'Delivery Monthly',
                      route: RoutesConstant.deliveryMonthly,
                      itemWidth: itemWidth,
                      iconSize: iconSize,
                    ),

                  // ~:Picking PIC:~
                  if (state.getSubHeaderList.contains('004'))
                    _buildMenuItem(
                      context,
                      imagePath: 'assets/images/picking.png',
                      label: 'Picking',
                      route: RoutesConstant.picking,
                      itemWidth: itemWidth,
                      iconSize: iconSize,
                    ),

                  // ~:Packing PIC:~
                  if (state.getSubHeaderList.contains('005'))
                    _buildMenuItem(
                      context,
                      imagePath: 'assets/images/packing.png',
                      label: 'Packing',
                      route: RoutesConstant.packing,
                      itemWidth: itemWidth,
                      iconSize: iconSize,
                    ),

                  // ~:FPM Dashboard (SAMP):~
                  if (showSampItems)
                    _buildMenuItem(
                      context,
                      imagePath: 'assets/images/dashboard-2.png',
                      label: 'FPM Dashboard',
                      route: RoutesConstant.fpmDashboard,
                      itemWidth: itemWidth,
                      iconSize: iconSize,
                      onTapOverride: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => FPMDialogFilter(),
                        );
                      },
                    ),

                  // ~:FPM Import Excel (SAMP):~
                  if (showSampItems)
                    _buildMenuItem(
                      context,
                      imagePath: 'assets/images/upload.png',
                      label: 'FPM Import Excel',
                      route: RoutesConstant.fpmImportExcel,
                      itemWidth: itemWidth,
                      iconSize: iconSize,
                    ),
                ],

                // ~:Booking Service (FixUP Moto):~
                // Always displayed for EntryLevelID == 50, or when SAMP authorization is present
                if (isLevel50 || showSampItems)
                  _buildMenuItem(
                    context,
                    imagePath: 'assets/images/service.png',
                    label: 'Booking Service',
                    route: RoutesConstant.bookingService,
                    itemWidth: itemWidth,
                    iconSize: iconSize,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String imagePath,
    required String label,
    required String route,
    required double itemWidth,
    required double iconSize,
    VoidCallback? onTapOverride,
  }) {
    return SizedBox(
      width: itemWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMenuIcon(
            context,
            imagePath: imagePath,
            route: route,
            iconSize: iconSize,
            onTapOverride: onTapOverride,
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuIcon(
    BuildContext context, {
    required String imagePath,
    required String route,
    required double iconSize,
    VoidCallback? onTapOverride,
  }) {
    final isHovered = ValueNotifier<bool>(false);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: isHovered,
        builder: (context, hovered, child) {
          return AnimatedContainer(
            width: iconSize,
            height: iconSize,
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
                  if (onTapOverride != null) {
                    onTapOverride();
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
