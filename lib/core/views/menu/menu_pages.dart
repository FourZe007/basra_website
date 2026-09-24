// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/core/providers/refresh_detector.dart';
import 'package:stsj/core/views/components/authorization_menu.dart';
import 'package:stsj/core/views/components/dashboard_menu.dart';
import 'package:stsj/core/views/components/report_menu.dart';
import 'package:stsj/core/views/components/activity_menu.dart';
import 'package:stsj/core/views/components/tools_menu.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/global/widget/app_bar.dart';

/// The BASRA application shell rendered at `/menu`.
///
/// Displays a persistent [CollapsibleSidebar] on the left and the active
/// category menu component on the right.  On narrow viewports the sidebar
/// collapses into a drawer accessible via a hamburger button in the app bar.
class MenuPages extends StatefulWidget {
  const MenuPages({super.key});

  @override
  State<MenuPages> createState() => _MenuPagesState();
}

class _MenuPagesState extends State<MenuPages>
    with AutomaticKeepAliveClientMixin<MenuPages> {
  late RefreshDetector refreshDetector;

  // ── Breakpoints ────────────────────────────────────────────────────────────
  static const double _mobileBreakpoint = 768.0;

  // ── Init / Dispose ─────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final state = Provider.of<MenuState>(context, listen: false);
    state.loadHeader();
    state.loadSubHeader();
    state.readDashboardList();
    state.readCompanyAuthorization();
  }

  // ── Content panel ──────────────────────────────────────────────────────────

  /// Builds the right-hand content area that shows the active category's menu
  /// component.
  Widget _buildContentPanel(BuildContext context, MenuState state, bool isMobile) {
    return ValueListenableBuilder<String>(
      valueListenable: state.getStaticMenuNotifier,
      builder: (context, activeMenu, _) {
        Widget content;

        if (activeMenu == 'dashboard' || activeMenu == '') {
          content = DashboardMenuComponent();
        } else if (activeMenu == 'activity') {
          content = const ActivityMenuComponent();
        } else if (activeMenu == 'authorization') {
          content = const AuthorizationMenuComponent();
        } else if (activeMenu == 'report') {
          content = ReportMenuComponent();
        } else if (activeMenu == 'tools') {
          content = ToolsMenuComponent();
        } else {
          content = _buildWelcomePanel(context, state);
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: KeyedSubtree(
            key: ValueKey<String>(activeMenu),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 28,
                vertical: isMobile ? 16 : 24,
              ),
              child: content,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomePanel(BuildContext context, MenuState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1.0),
            ),
            child: const Icon(
              Icons.apps_rounded,
              size: 48,
              color: AppColors.accentYellow,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Selamat datang, ${state.getUserId.isNotEmpty ? state.getUserId : 'User'}',
            style: const TextStyle(
              
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pilih menu dari sidebar untuk memulai.',
            style: TextStyle(
              
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading state ──────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentYellow),
      ),
    );
  }

  // ── Company header bar (shown above content on mobile) ─────────────────────

  Widget _buildCompanyInfoBar(MenuState state) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.deepBackground,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.business_outlined,
              size: 14, color: AppColors.textMuted),
          const SizedBox(width: 6),
          ValueListenableBuilder<String>(
            valueListenable: state.getStaticMenuNotifier,
            builder: (_, activeMenu, __) {
              final categoryLabels = {
                'dashboard': 'Dashboard',
                'activity': 'Sales Activity',
                'authorization': 'Authorization',
                'report': 'Information',
                'tools': 'Tools',
              };
              return Text(
                categoryLabels[activeMenu] ?? 'Menu',
                style: const TextStyle(
                  
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Desktop / Tablet view (sidebar always visible) ─────────────────────────

  Widget _desktopView(BuildContext context, MenuState state) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: const CustomAppBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb / active category bar
          _buildCompanyInfoBar(state),

          // Main menu content
          Expanded(
            child: state.headerList.isEmpty
                ? _buildLoading()
                : _buildContentPanel(context, state, false),
          ),
        ],
      ),
    );
  }

  // ── Mobile view (sidebar as drawer) ────────────────────────────────────────

  Widget _mobileView(BuildContext context, MenuState state) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: const CustomAppBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb / active category bar
          _buildCompanyInfoBar(state),

          // Main menu content
          Expanded(
            child: state.headerList.isEmpty
                ? _buildLoading()
                : _buildContentPanel(context, state, true),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = Provider.of<MenuState>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _mobileBreakpoint) {
          return _desktopView(context, state);
        } else {
          return _mobileView(context, state);
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
