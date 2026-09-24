import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/core/views/components/collapsible_sidebar.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/static/screenConstant.dart';

final GlobalKey<ScaffoldState> appShellScaffoldKey = GlobalKey<ScaffoldState>();

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({Key? key, required this.child}) : super(key: key);

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  void _setStaticMenu(MenuState state, String value) {
    state.setStaticMenuNotifier(value);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);
    bool isDesktopLayout = MediaQuery.sizeOf(context).width >= kTabletBreakpoint;

    return isDesktopLayout
        ? _desktopView(context, state)
        : _mobileView(context, state);
  }

  Widget _desktopView(BuildContext context, MenuState state) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Row(
        children: [
          // Left: collapsible sidebar
          CollapsibleSidebar(
            onItemSelected: (menuValue) {
              _setStaticMenu(state, menuValue);
            },
          ),
          // Right: content area (child provides its own Scaffold/AppBar)
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }

  Widget _mobileView(BuildContext context, MenuState state) {
    return Scaffold(
      key: appShellScaffoldKey,
      backgroundColor: AppColors.primaryBackground,
      // No AppBar here! The child provides its own.
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: CollapsibleSidebar(
          onItemSelected: (menuValue) {
            _setStaticMenu(state, menuValue);
            appShellScaffoldKey.currentState?.closeDrawer();
          },
        ),
      ),
      body: widget.child, // The child will have a Scaffold and CustomAppBar
    );
  }
}
