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

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 24.0,
          runSpacing: 24.0,
          alignment: WrapAlignment.start,
          children: [
            if (provider.getSubHeaderList.contains('400'))
              _buildMenuItem(context, 'assets/images/service.png', 'Service', RoutesConstant.service),
            if (provider.getSubHeaderList.contains('401'))
              _buildMenuItem(context, 'assets/images/new_freestock.png', 'Free Stock', RoutesConstant.branchFreeStock),
            if (provider.getSubHeaderList.contains('402'))
              _buildMenuItem(context, 'assets/images/new_import_alokasi.png', 'Import Alokasi Per BM', RoutesConstant.importAlokasiBM),
            if (provider.getSubHeaderList.contains('403'))
              _buildMenuItem(context, 'assets/images/new_koreksi_alokasi_perbm.png', 'Koleksi Alokasi Per BM', RoutesConstant.koreksiAlokasiBM),
            if (provider.getSubHeaderList.contains('406'))
              _buildMenuItem(context, 'assets/images/import.png', 'Import Cetak QR', RoutesConstant.importCetakQR),
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
  ) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuIcon(context, imagePath, tooltip, route),
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
                  if (tooltip == 'Dashboard Service') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => ServiceDialogFilter(),
                    );
                  }

                  if (context.mounted) context.goNamed(route);
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
