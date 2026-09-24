import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/service_dialog_filter.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/router/router_const.dart';

class ReportMenuComponent extends HookWidget {
  const ReportMenuComponent({super.key});

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
            if (state.getSubHeaderList.contains('300'))
              _buildMenuItem(context, 'assets/images/progress-report.png', 'Report', RoutesConstant.report, 'report'),
            if (state.getSubHeaderList.contains('304'))
              _buildMenuItem(context, 'assets/images/img_dailytask.png', 'Riwayat Absensi', RoutesConstant.absentHistory, 'attendance'),
            if (state.getSubHeaderList.contains('305'))
              _buildMenuItem(context, 'assets/images/salesman.png', 'Cari Salesman', RoutesConstant.browseSalesman, 'salesman list'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String imagePath,
    String tooltip,
    String route,
    String menuName,
  ) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuIcon(context, imagePath, tooltip, route, menuName),
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
    String menuName,
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
                onTap: () async {
                  final state = Provider.of<MenuState>(context, listen: false);
                  if (tooltip == 'Dashboard Service') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => ServiceDialogFilter(),
                    );
                  } else if (menuName == 'attendance') {
                    await state.resetAbsentHistory();
                  } else if (menuName == 'salesman list') {
                    await state.resetAbsentHistory();
                    state.setSearchTriggerNotifier(false);
                  }

                  if (context.mounted) {
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
