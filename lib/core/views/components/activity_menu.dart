import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/activity_point/pages/filter_page.dart';
import 'package:stsj/activity_point/pages/point_vs_target.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/service_dialog_filter.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard_pemetaan/pages/filter_dashboard.dart';
import 'package:stsj/external_web/utilities/global.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/router/router_const.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityMenuComponent extends HookWidget {
  const ActivityMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() => null);
    final state = Provider.of<MenuState>(context);
    final level = state.getEntryLevelId.trim();
    if (level != '53' && level != '00') {
      return const SizedBox.shrink();
    }

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
                if (state.getSubHeaderList.contains('100'))
                  _buildMenuItem(context, 'assets/images/maps.png', 'Peta', RoutesConstant.map, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('101'))
                  _buildMenuItem(context, 'assets/images/destination.png', 'Aktivitas Sales', RoutesConstant.salesActivities, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('110'))
                  _buildMenuItem(context, 'assets/images/activity.png', 'Aktivitas Manager', RoutesConstant.managerActivities, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('110'))
                  _buildMenuItem(context, 'assets/images/destination.png', 'Dashboard Pemetaan', RoutesConstant.filterPemetaan, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('111'))
                  _buildMenuItem(context, 'assets/images/weekly.png', 'Aktivitas Mingguan', RoutesConstant.weeklyActivitiesReport, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('113'))
                  _buildMenuItem(context, 'assets/images/subdealer.png', 'Aktivitas SubDealer', RoutesConstant.historyAktivitasSubDealer, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('112'))
                  _buildMenuItem(context, 'assets/images/coin.png', 'Points', RoutesConstant.filterPoint, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('110'))
                  _buildMenuItem(context, 'assets/images/goal.png', 'Import Target', RoutesConstant.importTargetActivities, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('110'))
                  _buildMenuItem(context, 'assets/images/progress-report.png', 'Target VS Result', RoutesConstant.targetResult, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('114'))
                  _buildMenuItem(context, 'assets/images/dashboard.png', 'Dashboard Sales', RoutesConstant.dashboardsales, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('115'))
                  _buildMenuItem(context, 'assets/images/operation-dealer.png', 'Operational Dealer', RoutesConstant.operationaldealer, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('116'))
                  _buildMenuItem(context, 'assets/images/dashboard-3.png', 'Dashboard Google Review', RoutesConstant.dashboardgooglereview, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('117'))
                  _buildMenuItem(context, 'assets/images/operational-sales-spv.png', 'Operational Sales Supervisor', RoutesConstant.operationalsalessupervisor, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('118'))
                  _buildMenuItem(context, 'assets/images/manpower-condition.png', 'Manpower Condition', RoutesConstant.manpowercondition, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('119'))
                  _buildMenuItem(context, 'assets/images/network-report.png', 'Network Report', RoutesConstant.networkreport, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('120'))
                  _buildMenuItem(context, 'assets/images/dashboard-2.png', 'Dashboard Sparepart STSJ', RoutesConstant.dashboardSparepartstsj, state, itemWidth: itemWidth, iconSize: iconSize),
                if (state.getSubHeaderList.contains('121'))
                  _buildMenuItem(context, 'assets/images/dashboard-2.png', 'Dashboard Sparepart SAMP', RoutesConstant.dashboardSparepartsamp, state, itemWidth: itemWidth, iconSize: iconSize),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String imagePath,
    String tooltip,
    String route,
    MenuState state, {
    required double itemWidth,
    required double iconSize,
  }) {
    return SizedBox(
      width: itemWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMenuIcon(context, imagePath, tooltip, route, state, iconSize: iconSize),
          const SizedBox(height: 10),
          Text(
            tooltip,
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
    BuildContext context,
    String imagePath,
    String tooltip,
    String route,
    MenuState state, {
    required double iconSize,
  }) {
    final isHovered = ValueNotifier<bool>(false);

    Future<void> handleTap() async {
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
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) => FilterDashboard(),
            );
          }
        });
      } else if (tooltip == 'Points') {
        showDialog(
          context: context,
          builder: (BuildContext context) => FilterPage(),
        );
      } else if (tooltip == 'Target VS Result') {
        showDialog(
          context: context,
          builder: (BuildContext context) => PointVsTarget(),
        );
      } else if (tooltip == 'Dashboard Google Review') {
        launchUrl(
          Uri.parse(linkBIGoogleReview),
          mode: LaunchMode.platformDefault,
        );
      } else {
        context.goNamed(route);
      }
    }

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
                onTap: handleTap,
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
