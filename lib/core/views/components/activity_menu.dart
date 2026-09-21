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
    
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 24.0,
          runSpacing: 24.0,
          alignment: WrapAlignment.start,
          children: [
            if (state.getSubHeaderList.contains('100')) _buildMenuItem(context, 'assets/images/maps.png', 'Peta', RoutesConstant.map, state),
            if (state.getSubHeaderList.contains('101')) _buildMenuItem(context, 'assets/images/destination.png', 'Aktivitas Sales', RoutesConstant.salesActivities, state),
            if (state.getSubHeaderList.contains('110')) _buildMenuItem(context, 'assets/images/activity.png', 'Aktivitas Manager', RoutesConstant.managerActivities, state),
            if (state.getSubHeaderList.contains('110')) _buildMenuItem(context, 'assets/images/destination.png', 'Dashboard Pemetaan', RoutesConstant.filterPemetaan, state),
            if (state.getSubHeaderList.contains('111')) _buildMenuItem(context, 'assets/images/weekly.png', 'Aktivitas Mingguan', RoutesConstant.weeklyActivitiesReport, state),
            if (state.getSubHeaderList.contains('113')) _buildMenuItem(context, 'assets/images/subdealer.png', 'Aktivitas SubDealer', RoutesConstant.historyAktivitasSubDealer, state),
            if (state.getSubHeaderList.contains('112')) _buildMenuItem(context, 'assets/images/coin.png', 'Points', RoutesConstant.filterPoint, state),
            if (state.getSubHeaderList.contains('110')) _buildMenuItem(context, 'assets/images/goal.png', 'Import Target', RoutesConstant.importTargetActivities, state),
            if (state.getSubHeaderList.contains('110')) _buildMenuItem(context, 'assets/images/progress-report.png', 'Target VS Result', RoutesConstant.targetResult, state),
            if (state.getSubHeaderList.contains('114')) _buildMenuItem(context, 'assets/images/new_dashboard_sales.png', 'Dashboard Sales', RoutesConstant.dashboardsales, state),
            if (state.getSubHeaderList.contains('115')) _buildMenuItem(context, 'assets/images/new_operational_dealer.png', 'Operational Dealer', RoutesConstant.operationaldealer, state),
            if (state.getSubHeaderList.contains('116')) _buildMenuItem(context, 'assets/images/new_google_review.png', 'Dashboard Google Review', RoutesConstant.dashboardgooglereview, state),
            if (state.getSubHeaderList.contains('117')) _buildMenuItem(context, 'assets/images/new_operational_sales_supervisor.png', 'Operational Sales Supervisor', RoutesConstant.operationalsalessupervisor, state),
            if (state.getSubHeaderList.contains('118')) _buildMenuItem(context, 'assets/images/new_manpower_condition.png', 'Manpower Condition', RoutesConstant.manpowercondition, state),
            if (state.getSubHeaderList.contains('119')) _buildMenuItem(context, 'assets/images/new_network_report.png', 'Network Report', RoutesConstant.networkreport, state),
            if (state.getSubHeaderList.contains('120')) _buildMenuItem(context, 'assets/images/dashboard-2.png', 'Dashboard Sparepart STSJ', RoutesConstant.dashboardSparepartstsj, state),
            if (state.getSubHeaderList.contains('121')) _buildMenuItem(context, 'assets/images/dashboard-2.png', 'Dashboard Sparepart SAMP', RoutesConstant.dashboardSparepartsamp, state),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String imagePath, String tooltip, String route, MenuState state) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuIcon(context, imagePath, tooltip, route, state),
          const SizedBox(height: 8),
          Text(
            tooltip,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
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
    MenuState state,
  ) {
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
        await state.fetchProvinces().then((_) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) => FilterPage(),
            );
          }
        });
      } else if (tooltip == 'Target VS Result') {
        await state.fetchProvinces().then((_) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) => PointVsTarget(),
            );
          }
        });
      } else if (tooltip == 'Network') {
        try {
          await launchUrl(Uri.parse(googleFormNetwork));
        } catch (e) {
          debugPrint(e.toString());
        }
      } else if (tooltip == 'Network2') {
        try {
          await launchUrl(Uri.parse(petunjukNetwork));
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        context.goNamed(route);
      }
    }

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: isHovered,
        builder: (context, hovered, _) {
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
