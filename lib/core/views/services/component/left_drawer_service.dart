import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/router/router_const.dart';

class LeftDrawerService extends HookWidget {
  final Function onItemSelected;
  final int currentPage; // Add currentPage as a parameter

  const LeftDrawerService({
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
          onMenuItemSelected(
              index); // Call the callback with the selected index.
          Navigator.of(context).pop(); // Tutup drawer setelah memilih item.
        },
        leading: Icon(
          icon,
          color:
              isSelected ? Colors.blue : null, // Ganti warna ikon jika dipilih
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.blue
                : null, // Ganti warna teks jika dipilih
          ),
        ),
      );
    }

    return Container(
      height: screenHeight,
      color: Theme.of(context).cardColor,
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 0, top: 0), // Atur margin sesuai kebutuhan
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          final state = Provider.of<MenuState>(context, listen: false);
                          state.setStaticMenuNotifier('tools');
                          context.replaceNamed(RoutesConstant.menu);
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'REPORT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  // Tambahkan widget lain di dalam Stack jika diperlukan.
                ],
              ),
            ),
            _drawerItem('MotorCycle History', 0, Icons.motorcycle),
          ],
        ),
      ),
    );
  }
}
