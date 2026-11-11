import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/service_dialog_filter.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/router/router_const.dart';

class ToolsMenuComponent extends HookWidget {
  const ToolsMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() => null);
    final provider = Provider.of<MenuState>(context);
    if (provider.getEntryLevelId.trim() == '50') {
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
                if (provider.getSubHeaderList.contains('400'))
                  _buildMenuItem(
                    context,
                    'assets/images/service.png',
                    'Service',
                    RoutesConstant.service,
                    itemWidth: itemWidth,
                    iconSize: iconSize,
                  ),
                if (provider.getSubHeaderList.contains('401'))
                  _buildMenuItem(
                    context,
                    'assets/images/stock.png',
                    'Free Stock',
                    RoutesConstant.branchFreeStock,
                    itemWidth: itemWidth,
                    iconSize: iconSize,
                  ),
                if (provider.getSubHeaderList.contains('402'))
                  _buildMenuItem(
                    context,
                    'assets/images/import.png',
                    'Import Alokasi Per BM',
                    RoutesConstant.importAlokasiBM,
                    itemWidth: itemWidth,
                    iconSize: iconSize,
                  ),
                if (provider.getSubHeaderList.contains('403'))
                  _buildMenuItem(
                    context,
                    'assets/images/edit.png',
                    'Koleksi Alokasi Per BM',
                    RoutesConstant.koreksiAlokasiBM,
                    itemWidth: itemWidth,
                    iconSize: iconSize,
                  ),
                if (provider.getSubHeaderList.contains('406'))
                  _buildMenuItem(
                    context,
                    'assets/images/import.png',
                    'Import Cetak QR',
                    RoutesConstant.importCetakQR,
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
    String route, {
    required double itemWidth,
    required double iconSize,
  }) {
    return SizedBox(
      width: itemWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMenuIcon(context, imagePath, tooltip, route, iconSize: iconSize),
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
    String route, {
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
