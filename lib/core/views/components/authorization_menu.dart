import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/service_dialog_filter.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/router/router_const.dart';

class AuthorizationMenuComponent extends HookWidget {
  const AuthorizationMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() => null);
    final state = Provider.of<MenuState>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            // SPK Authorization
            Builder(
              builder: (context) {
                if (state.getSubHeaderList.contains('200')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        // Otorisasi
                        _buildMenuIcon(
                          context,
                          'assets/images/authorization.png',
                          'Otorisasi',
                          RoutesConstant.authorizationSPK,
                        ),
                        const Text('Otorisasi SPK'),
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
