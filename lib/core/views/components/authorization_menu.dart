import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/router/router_const.dart';

class AuthorizationMenuComponent extends HookWidget {
  const AuthorizationMenuComponent({super.key});

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
                // Otorisasi
                if (state.getSubHeaderList.contains('200'))
                  _buildMenuItem(
                    context,
                    imagePath: 'assets/images/authorization.png',
                    label: 'Otorisasi',
                    route: RoutesConstant.otorisasi,
                    itemWidth: itemWidth,
                    iconSize: iconSize,
                  ),

                // Otorisasi Mutasi
                if (state.getSubHeaderList.contains('201'))
                  _buildMenuItem(
                    context,
                    imagePath: 'assets/images/authorization.png',
                    label: 'Otorisasi Mutasi',
                    route: RoutesConstant.otorisasiMutasi,
                    itemWidth: itemWidth,
                    iconSize: iconSize,
                  ),

                // Otorisasi SPK
                if (state.getSubHeaderList.contains('202') ||
                    (state.getSubHeaderList.contains('200') &&
                        !state.getSubHeaderList.contains('202')))
                  _buildMenuItem(
                    context,
                    imagePath: 'assets/images/authorization.png',
                    label: 'Otorisasi SPK',
                    route: RoutesConstant.authorizationSPK,
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
