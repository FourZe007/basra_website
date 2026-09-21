import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/router/router_const.dart';

class LeftDrawer extends HookWidget {
  final Function onItemSelected;
  final int currentPage; // Add currentPage as a parameter

  const LeftDrawer({
    Key? key,
    required this.currentPage,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    var selectedIndex = useState<int>(0);

    // callback
    void onMenuItemSelected(int index) {
      onItemSelected(index);
      selectedIndex.value = index;
    }

    Widget _drawerItem(String label, int index, IconData icon) {
      final isSelected = index == currentPage;

      return ListTile(
        onTap: () {
          onMenuItemSelected(index); // Call the callback with the selected index.
          Navigator.of(context).pop(); // Tutup drawer setelah memilih item.
        },
        leading: Icon(
          icon,
          color: isSelected ? AppColors.accentYellow : AppColors.textSecondary,
        ),
        title: Text(
          label,
          style: TextStyle(
            
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.accentYellow : AppColors.textSecondary,
          ),
        ),
      );
    }

    return Container(
      height: screenHeight,
      color: AppColors.softCharcoal,
      child: Drawer(
        backgroundColor: AppColors.softCharcoal,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.secondaryMaroon,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: AppColors.textPrimary,
                        onPressed: () {
                          final state = Provider.of<MenuState>(context, listen: false);
                          state.setStaticMenuNotifier('report');
                          context.replaceNamed(RoutesConstant.menu);
                        },
                    ),
                  ),
                  const Center(
                    child: Text(
                      'REPORT',
                      style: TextStyle(
                        
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _drawerItem('Pembelian', 0, Icons.shopping_cart),
            _drawerItem('Penjualan', 1, Icons.store),
            _drawerItem('Service', 2, Icons.miscellaneous_services),
            _drawerItem('Inventory', 3, Icons.inventory),
            _drawerItem('Registrasi', 4, Icons.app_registration),
            _drawerItem('Finance', 5, Icons.money),
            _drawerItem('Accounting', 6, Icons.account_balance),
            _drawerItem('Master', 7, Icons.data_exploration),
            _drawerItem('Faktur Polisi', 8, Icons.print_rounded),
            _drawerItem('Bea Balik Nama', 9, Icons.document_scanner),
            _drawerItem('Faktur Pajak', 10, Icons.money),
            _drawerItem('Lain-lain', 11, Icons.devices_other),
          ],
        ),
      ),
    );
  }
}
