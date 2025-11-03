import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/service_dialog_filter.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/router/router_const.dart';

class ToolsMenuComponent extends HookWidget {
  const ToolsMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() => null);
    final provider = Provider.of<MenuState>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            // Service
            Builder(
              builder: (context) {
                if (provider.getSubHeaderList.contains('400')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/service.png',
                          'Service',
                          RoutesConstant.service,
                        ),
                        const Text('Service'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            // ~:FS Branch:~
            Builder(
              builder: (context) {
                if (provider.getSubHeaderList.contains('401')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/stock.png',
                          'Free Stock',
                          RoutesConstant.branchFreeStock,
                        ),
                        const Text('Free Stock'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            Builder(
              builder: (context) {
                if (provider.getSubHeaderList.contains('402')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/import.png',
                          'Import Alokasi Per BM',
                          RoutesConstant.importAlokasiBM,
                        ),
                        const Text('Import Alokasi Per BM'),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            Builder(
              builder: (context) {
                if (provider.getSubHeaderList.contains('403')) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    child: Column(
                      children: [
                        _buildMenuIcon(
                          context,
                          'assets/images/edit.png',
                          'Koreksi Alokasi Per BM',
                          RoutesConstant.koreksiAlokasiBM,
                        ),
                        const Text('Koreksi Alokasi Per BM'),
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
    final tooltipNull = ValueNotifier<bool>(false);

    return MouseRegion(
      onEnter: (_) {
        isHovered.value = true;
      },
      onExit: (_) {
        isHovered.value = false;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isHovered,
        builder: (context, hovered, child) {
          return AnimatedContainer(
            width: 100.0,
            height: 100.0,
            duration: Duration(milliseconds: 100),
            padding: EdgeInsets.all(hovered ? 10.0 : 0.0),
            child: IconButton(
              onPressed: () async {
                tooltipNull.value = true;
                if (tooltip == 'Dashboard Service') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ServiceDialogFilter(),
                  );
                } else if (tooltip == 'Free Stock') {
                  // await Provider.of<MenuState>(context, listen: false)
                  //     .fetchBranchFreeStock();
                }
                // else {
                //   context.goNamed(route);
                // }

                if (context.mounted) context.goNamed(route);
              },
              icon: Image.asset(imagePath),
            ),
          );
        },
      ),
    );
  }
}
