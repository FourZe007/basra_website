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
    if (state.getEntryLevelId.trim() == '50') {
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
                if (state.getSubHeaderList.contains('300'))
                  _buildMenuItem(
                    context,
                    'assets/images/progress-report.png',
                    'Report',
                    RoutesConstant.report,
                    'report',
                    itemWidth: itemWidth,
                    iconSize: iconSize,
                  ),
                if (state.getSubHeaderList.contains('304'))
                  _buildMenuItem(
                    context,
                    'assets/images/img_dailytask.png',
                    'Riwayat Absensi',
                    RoutesConstant.absentHistory,
                    'attendance',
                    itemWidth: itemWidth,
                    iconSize: iconSize,
                  ),
                if (state.getSubHeaderList.contains('305'))
                  _buildMenuItem(
                    context,
                    'assets/images/salesman.png',
                    'Cari Salesman',
                    RoutesConstant.browseSalesman,
                    'salesman list',
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
    BuildContext context,
    String imagePath,
    String tooltip,
    String route,
    String menuName, {
    required double itemWidth,
    required double iconSize,
  }) {
    return SizedBox(
      width: itemWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMenuIcon(context, imagePath, tooltip, route, menuName, iconSize: iconSize),
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
    String menuName, {
    required double iconSize,
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
                  if (tooltip == 'Dashboard Service') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => ServiceDialogFilter(),
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
