import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/cleanArc/dashboard_service/pages/service_dialog_filter.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/pages/fpm_dialog_filter.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/router/router_const.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data models (private to this file)
// ─────────────────────────────────────────────────────────────────────────────

class _SidebarItem {
  final String label;
  final IconData icon;
  final String routeName;
  final String accessCode;
  /// When true, tapping opens a dialog rather than navigating to the route.
  final bool isDialogRoute;

  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.routeName,
    required this.accessCode,
    this.isDialogRoute = false,
  });
}

class _SidebarCategory {
  final String label;
  final IconData icon;
  final String categoryKey; // matches headerList entries
  final String menuValue;   // matches staticMenuNotifier values
  final List<_SidebarItem> items;

  const _SidebarCategory({
    required this.label,
    required this.icon,
    required this.categoryKey,
    required this.menuValue,
    required this.items,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Static catalog — mirrors the existing menu components
// Access codes must match those in subHeaderList (loaded from SharedPreferences)
// ─────────────────────────────────────────────────────────────────────────────

const List<_SidebarCategory> _catalog = [
  _SidebarCategory(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    categoryKey: 'DASHBOARD',
    menuValue: 'dashboard',
    items: [
      _SidebarItem(label: 'Sales Dashboard',    icon: Icons.bar_chart_rounded,        routeName: 'salesDashboard',    accessCode: '000'),
      _SidebarItem(label: 'Dashboard Service',  icon: Icons.build_circle_outlined,    routeName: 'dashboardService',  accessCode: '002', isDialogRoute: true),
      _SidebarItem(label: 'Delivery',           icon: Icons.local_shipping_outlined,  routeName: 'delivery',          accessCode: '003'),
      _SidebarItem(label: 'Delivery Approval',  icon: Icons.verified_outlined,        routeName: 'deliveryApproval',  accessCode: '006'),
      _SidebarItem(label: 'Delivery Monthly',   icon: Icons.calendar_month_outlined,  routeName: 'deliveryMonthly',   accessCode: '007'),
      _SidebarItem(label: 'Picking',            icon: Icons.fact_check_outlined,      routeName: 'picking',           accessCode: '004'),
      _SidebarItem(label: 'Packing',            icon: Icons.inventory_2_outlined,     routeName: 'packing',           accessCode: '005'),
      _SidebarItem(label: 'FPM Dashboard',      icon: Icons.analytics_outlined,       routeName: 'fpmDashboard',      accessCode: 'SAMP_FPM', isDialogRoute: true),
      _SidebarItem(label: 'FPM Import Excel',   icon: Icons.upload_file_outlined,     routeName: 'fpmImportExcel',    accessCode: 'SAMP_FPM'),
    ],
  ),
  _SidebarCategory(
    label: 'Sales Activity',
    icon: Icons.show_chart_rounded,
    categoryKey: 'SALES ACTIVITY',
    menuValue: 'activity',
    items: [
      _SidebarItem(label: 'Peta',                   icon: Icons.map_outlined,                     routeName: 'maps',                      accessCode: '100'),
      _SidebarItem(label: 'Aktivitas Sales',         icon: Icons.directions_walk_outlined,         routeName: 'salesActivities',           accessCode: '101'),
      _SidebarItem(label: 'Aktivitas Manager',       icon: Icons.supervisor_account_outlined,      routeName: 'managerActivities',         accessCode: '110'),
      _SidebarItem(label: 'Dashboard Pemetaan',      icon: Icons.place_outlined,                   routeName: 'filterPemetaan',            accessCode: '110'),
      _SidebarItem(label: 'Aktivitas Mingguan',      icon: Icons.summarize_outlined,               routeName: 'weeklyActivitiesReport',    accessCode: '111'),
      _SidebarItem(label: 'Aktivitas Sub Dealer',    icon: Icons.store_mall_directory_outlined,    routeName: 'historyAktivitasSubDealer', accessCode: '113'),
      _SidebarItem(label: 'Points',                  icon: Icons.stars_outlined,                   routeName: 'filterPoint',               accessCode: '112'),
      _SidebarItem(label: 'Import Target',           icon: Icons.upload_rounded,                   routeName: 'importTargetActivites',     accessCode: '110'),
      _SidebarItem(label: 'Target VS Result',        icon: Icons.track_changes_outlined,           routeName: 'targetResult',              accessCode: '110'),
      _SidebarItem(label: 'Dashboard Sales',         icon: Icons.leaderboard_outlined,             routeName: 'dashboardsales',            accessCode: '114'),
      _SidebarItem(label: 'Operational Dealer',      icon: Icons.store_outlined,                   routeName: 'operationaldealer',         accessCode: '115'),
      _SidebarItem(label: 'Google Review',           icon: Icons.star_outline_rounded,             routeName: 'dashboardgooglereview',     accessCode: '116'),
      _SidebarItem(label: 'Sales Supervisor',        icon: Icons.manage_accounts_outlined,         routeName: 'operationalsalessupervisor',accessCode: '117'),
      _SidebarItem(label: 'Manpower Condition',      icon: Icons.groups_outlined,                  routeName: 'manpowercondition',         accessCode: '118'),
      _SidebarItem(label: 'Network Report',          icon: Icons.network_check_outlined,           routeName: 'networkreport',             accessCode: '119'),
      _SidebarItem(label: 'Sparepart STSJ',          icon: Icons.build_outlined,                   routeName: 'dashboardSparepartSTSJ',   accessCode: '120'),
      _SidebarItem(label: 'Sparepart SAMP',          icon: Icons.build_outlined,                   routeName: 'dashboardSparepartSAMP',   accessCode: '121'),
    ],
  ),
  _SidebarCategory(
    label: 'Authorization',
    icon: Icons.verified_user_outlined,
    categoryKey: 'AUTHORIZATION',
    menuValue: 'authorization',
    items: [
      _SidebarItem(label: 'Otorisasi',        icon: Icons.how_to_reg_outlined,           routeName: 'authorization',  accessCode: '200'),
      _SidebarItem(label: 'Otorisasi Mutasi', icon: Icons.swap_horiz_rounded,            routeName: 'otorisasiMutasi',accessCode: '201'),
      _SidebarItem(label: 'Otorisasi SPK',    icon: Icons.assignment_turned_in_outlined, routeName: 'otorisasiSPK',   accessCode: '202'),
    ],
  ),
  _SidebarCategory(
    label: 'Information',
    icon: Icons.description_outlined,
    categoryKey: 'INFORMATION',
    menuValue: 'report',
    items: [
      _SidebarItem(label: 'Report',           icon: Icons.bar_chart_rounded,         routeName: 'report',          accessCode: '300'),
      _SidebarItem(label: 'Riwayat Absensi',  icon: Icons.history_outlined,          routeName: 'absentHistory',   accessCode: '304'),
      _SidebarItem(label: 'Cari Salesman',    icon: Icons.people_outline_rounded,    routeName: 'browseSalesman',  accessCode: '305'),
    ],
  ),
  _SidebarCategory(
    label: 'Tools',
    icon: Icons.construction_outlined,
    categoryKey: 'TOOLS',
    menuValue: 'tools',
    items: [
      _SidebarItem(label: 'Service Input',    icon: Icons.home_repair_service_outlined, routeName: 'service',          accessCode: '400'),
      _SidebarItem(label: 'Free Stock',       icon: Icons.inventory_outlined,           routeName: 'branchFreeStock',  accessCode: '401'),
      _SidebarItem(label: 'Import Alokasi BM',icon: Icons.file_upload_outlined,         routeName: 'importAlokasiBM',  accessCode: '402'),
      _SidebarItem(label: 'Koreksi Alokasi',  icon: Icons.edit_note_outlined,           routeName: 'koreksiAlokasiBM', accessCode: '403'),
      _SidebarItem(label: 'Cetak QR',         icon: Icons.qr_code_rounded,              routeName: 'importCetakQR',    accessCode: '406'),
    ],
  ),
];



// ─────────────────────────────────────────────────────────────────────────────
// Main sidebar widget
// ─────────────────────────────────────────────────────────────────────────────

/// Persistent collapsible left sidebar for the BASRA menu shell.
///
/// Pass [onItemSelected] to react when the user taps a menu item (the sidebar
/// will call [setStaticMenuNotifier] on the state internally and then invoke
/// the callback with the selected category [menuValue]).
class CollapsibleSidebar extends StatefulWidget {
  const CollapsibleSidebar({
    super.key,
    this.onItemSelected,
    this.initiallyExpanded = true,
  });

  /// Called after the user taps a sidebar item. Receives the category
  /// [menuValue] (e.g. `'dashboard'`, `'activity'`).
  final void Function(String menuValue)? onItemSelected;

  /// Whether the sidebar starts expanded (true) or collapsed (false).
  final bool initiallyExpanded;

  @override
  State<CollapsibleSidebar> createState() => _CollapsibleSidebarState();
}

class _CollapsibleSidebarState extends State<CollapsibleSidebar>
    with SingleTickerProviderStateMixin {
  static const double _expandedWidth = 240.0;
  static const double _collapsedWidth = 60.0;
  static const Duration _animDuration = Duration(milliseconds: 220);

  late bool _expanded;
  String _companyName = '';
  // Track which categories are "open" when expanded (for accordion behavior)
  final Set<String> _openCategories = {};

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _loadCompanyName();

    // Pre-open the active category
    final state = Provider.of<MenuState>(context, listen: false);
    final activeMenu = state.getStaticMenuNotifier.value;
    for (final cat in _catalog) {
      if (cat.menuValue == activeMenu) {
        _openCategories.add(cat.categoryKey);
        break;
      }
    }
    // Default: open dashboard category
    if (_openCategories.isEmpty) {
      _openCategories.add('DASHBOARD');
    }
  }

  Map<String, bool> _companyAccess = {};

  Future<void> _loadCompanyName() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _companyName = prefs.getString('CompanyName') ?? '';
        _companyAccess = {
          'STSJ': prefs.getBool('STSJ') ?? false,
          'RSSM': prefs.getBool('RSSM') ?? false,
          'SAMP': prefs.getBool('SAMP') ?? false,
          'SPAA': prefs.getBool('SPAA') ?? false,
          'SS': prefs.getBool('SS') ?? false,
          'ST': prefs.getBool('ST') ?? false,
          'SP': prefs.getBool('SP') ?? false,
          'SPr': prefs.getBool('Spr') ?? false,
        };
      });
    }
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  /// Resolve company logo path from company code
  String _logoForCompany(String code) {
    const map = {
      'STSJ': 'assets/images/stsj.png',
      'RSSM': 'assets/images/rssm.png',
      'SAMP': 'assets/images/SAMP.png',
      'SPAA': 'assets/images/SPAA.png',
      'SS':   'assets/images/SS.png',
      'ST':   'assets/images/ST.png',
      'SP':   'assets/images/SP.png',
      'SPr':  'assets/images/SPr.png',
      'Spr':  'assets/images/SPr.png',
    };
    return map[code] ?? 'assets/images/stsj.png';
  }

  /// Determine whether a sidebar item is accessible given the current
  /// [subHeaderList] and [companyAuthorization].
  bool _isItemAccessible(_SidebarItem item, MenuState state) {
    // FPM items require SAMP company authorization
    if (item.accessCode == 'SAMP_FPM') {
      return state.getCompanyAuthorization.contains('SAMP');
    }
    return state.getSubHeaderList.contains(item.accessCode);
  }

  bool _isCategoryAccessible(_SidebarCategory cat, MenuState state) {
    return state.getHeaderList.contains(cat.categoryKey);
  }

  void _permissionCheck(
    BuildContext context,
    MenuState state,
    String companyCode,
  ) async {
    final loginpt = Provider.of<PtModel>(context, listen: false);
    state.setStaticMenuNotifier('');
    loginpt.setPT(companyCode);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    for (var data in state.getUserCompanyAccList) {
      if (data.pt == companyCode) {
        state.entryLevelId = data.accessId;
        prefs.setString('EntryLevelID', data.accessId);
        prefs.setString('EntryLevelName', data.accessName);
        prefs.setString('CompanyName', companyCode);
      }
    }

    state.entryLevelId = prefs.getString('EntryLevelID') ?? '';
    state.entryLevelName = prefs.getString('EntryLevelName') ?? '';
    state.companyName = prefs.getString('CompanyName') ?? '';

    setState(() {
      _companyName = state.companyName;
    });

    final access = await state.fetchUserAccess(companyCode, state.getEntryLevelId);
    await state.fetchSipSalesBranches(companyCode);

    if (access.isNotEmpty) {
      state.userAccessList.addAll(access);

      String category = '';
      for (var userAccess in access) {
        if (userAccess.isAllowView == 1) {
          category = userAccess.category;
          break;
        }
      }

      if (category == 'DASHBOARD') {
        state.setStaticMenuNotifier('dashboard');
      } else if (category == 'SALES ACTIVITY') {
        state.setStaticMenuNotifier('activity');
      } else if (category == 'AUTHORIZATION') {
        state.setStaticMenuNotifier('authorization');
      } else if (category == 'INFORMATION') {
        state.setStaticMenuNotifier('report');
      } else if (category == 'TOOLS') {
        state.setStaticMenuNotifier('tools');
      } else {
        state.setStaticMenuNotifier('');
      }

      state.headerList.clear();
      state.headerList.addAll(access.map((e) => e.category).toSet().toList());
      state.headerList.addAll(access.map((e) {
        if (e.isAllowView == 1) {
          return e.category;
        } else {
          return '-';
        }
      }).toList());

      if (state.headerList.isEmpty) {
        state.headerList.add('dashboard');
      }
      await prefs.setStringList('header', state.headerList);

      state.subHeaderList.clear();
      state.subHeaderList.addAll(access.map((e) {
        if (e.isAllowView == 1) {
          return e.menuNumber;
        } else {
          return '-';
        }
      }).toList());

      await prefs.setStringList('subheader', state.subHeaderList);

      // Pre-open the new active category
      final activeMenu = state.getStaticMenuNotifier.value;
      setState(() {
        _openCategories.clear();
        for (final cat in _catalog) {
          if (cat.menuValue == activeMenu) {
            _openCategories.add(cat.categoryKey);
            break;
          }
        }
        if (_openCategories.isEmpty) _openCategories.add('DASHBOARD');
      });

      // Route to menu if not already there
      context.goNamed('menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);

    return AnimatedContainer(
      duration: _animDuration,
      curve: Curves.easeInOut,
      width: _expanded ? _expandedWidth : _collapsedWidth,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBackground,
        border: Border(
          right: BorderSide(color: AppColors.sidebarBorder, width: 1.0),
        ),
      ),
      child: OverflowBox(
        alignment: Alignment.topLeft,
        minWidth: _expanded ? _expandedWidth : _collapsedWidth,
        maxWidth: _expanded ? _expandedWidth : _collapsedWidth,
        child: Column(
          children: [
            // ── Company badge ─────────────────────────────────────────────────
            _buildCompanyBadge(context),

            const Divider(color: AppColors.border, height: 1, thickness: 1),
            const Divider(color: AppColors.sidebarBorder, height: 1, thickness: 1),

            // ── Navigation items ──────────────────────────────────────────────
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: state.getStaticMenuNotifier,
                builder: (context, activeMenu, _) {
                  return ValueListenableBuilder<String>(
                    valueListenable: state.getSidebarItemNotifier,
                    builder: (context, activeItem, _) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _catalog.map((cat) {
                            return _buildCategory(
                              context: context,
                              cat: cat,
                              state: state,
                              activeMenu: activeMenu,
                              activeItem: activeItem,
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const Divider(color: AppColors.border, height: 1, thickness: 1),
            const Divider(color: AppColors.sidebarBorder, height: 1, thickness: 1),

            // ── Collapse toggle ───────────────────────────────────────────────
            _buildCollapseToggle(),
          ],
        ),
      ),
    );
  }

  // ── Company badge ──────────────────────────────────────────────────────────

  Widget _buildCompanyBadge(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Return to company-selection page
          context.goNamed(RoutesConstant.homepage);
        },
        child: Tooltip(
          message: _expanded ? '' : _companyName.isNotEmpty ? _companyName : 'Switch Company',
          child: AnimatedContainer(
            duration: _animDuration,
            height: 64,
            padding: EdgeInsets.symmetric(horizontal: _expanded ? 12 : 11, vertical: 8),
            color: AppColors.sidebarBackgroundDark,
            child: Row(
              children: [
                // Logo
                Container(
                  width: 36,
                  height: 36,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.0),
                  ),
                  child: Image.asset(
                    _logoForCompany(_companyName),
                    fit: BoxFit.contain,
                  ),
                ),

                // Company name + hint
                if (_expanded) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _companyName.isNotEmpty ? _companyName : 'BASRA',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Tap to switch',
                          style: TextStyle(
                            
                            fontSize: 9.5,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.swap_horiz_rounded,
                    size: 16,
                    color: Colors.white70,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Category block ─────────────────────────────────────────────────────────

  Widget _buildCategory({
    required BuildContext context,
    required _SidebarCategory cat,
    required MenuState state,
    required String activeMenu,
    required String activeItem,
  }) {
    final isCatAccessible = _isCategoryAccessible(cat, state);
    final isCatActive = activeMenu == cat.menuValue ||
        (activeMenu == '' && cat.menuValue == 'dashboard');
    final isOpen = _openCategories.contains(cat.categoryKey);

    // Accessible items within this category
    final visibleItems = cat.items
        .where((item) => _isItemAccessible(item, state))
        .toList();

    if (!isCatAccessible) {
      // Render a locked / greyed category header only
      return _buildCategoryHeader(
        cat: cat,
        isCatActive: false,
        isAccessible: false,
        isOpen: false,
        onTapMain: () {
          _showAccessDenied(context);
        },
        onTapArrow: () {},
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header row
        _buildCategoryHeader(
          cat: cat,
          isCatActive: isCatActive,
          isAccessible: true,
          isOpen: isOpen,
          onTapMain: () {
            // Switch active category in state, but don't toggle accordion
            state.setStaticMenuNotifier(cat.menuValue);
            widget.onItemSelected?.call(cat.menuValue);
          },
          onTapArrow: () {
            // Toggle accordion, but don't navigate
            if (_expanded) {
              setState(() {
                if (isOpen) {
                  _openCategories.remove(cat.categoryKey);
                } else {
                  _openCategories.add(cat.categoryKey);
                }
              });
            }
          },
        ),

        // Animated items list (only when expanded)
        if (_expanded)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 180),
            crossFadeState:
                isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Column(
              children: visibleItems.map((item) {
                return _buildSidebarItem(
                  context: context,
                  item: item,
                  state: state,
                  activeItem: activeItem,
                );
              }).toList(),
            ),
            secondChild: const SizedBox.shrink(),
          ),
      ],
    );
  }

  Widget _buildCategoryHeader({
    required _SidebarCategory cat,
    required bool isCatActive,
    required bool isAccessible,
    required bool isOpen,
    required VoidCallback onTapMain,
    required VoidCallback onTapArrow,
  }) {
    final color = !isAccessible
        ? Colors.white.withValues(alpha: 0.45)
        : isCatActive
            ? Colors.white
            : Colors.white.withValues(alpha: 0.85);

    return Tooltip(
      message: _expanded ? '' : cat.label,
      preferBelow: false,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTapMain,
          child: AnimatedContainer(
            duration: _animDuration,
            height: 44,
            padding: EdgeInsets.only(
              left: _expanded ? 12 : 0,
              right: _expanded ? 4 : 0,
            ),
            decoration: BoxDecoration(
              color: isCatActive && isAccessible
                  ? AppColors.sidebarActiveItem
                  : Colors.transparent,
              border: isCatActive && isAccessible
                  ? const Border(
                      left: BorderSide(
                        color: Colors.white,
                        width: 3,
                      ),
                    )
                  : const Border(
                      left: BorderSide(color: Colors.transparent, width: 3),
                    ),
            ),
            child: Row(
              children: [
                if (!_expanded)
                  Expanded(
                    child: Icon(
                      isAccessible ? cat.icon : Icons.lock_outline_rounded,
                      size: 20,
                      color: color,
                    ),
                  )
                else ...[
                  Icon(
                    isAccessible ? cat.icon : Icons.lock_outline_rounded,
                    size: 18,
                    color: color,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      cat.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        
                        fontSize: 12,
                        fontWeight: isCatActive
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                  if (isAccessible)
                    IconButton(
                      icon: Icon(
                        isOpen
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                      onPressed: onTapArrow,
                      splashRadius: 20,
                      padding: const EdgeInsets.all(4.0),
                      constraints: const BoxConstraints(),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Sidebar item row ───────────────────────────────────────────────────────

  Widget _buildSidebarItem({
    required BuildContext context,
    required _SidebarItem item,
    required MenuState state,
    required String activeItem,
  }) {
    final isActive = activeItem == item.routeName;
    final isHovered = ValueNotifier<bool>(false);

    return ValueListenableBuilder<bool>(
      valueListenable: isHovered,
      builder: (ctx, hovered, _) {
        return MouseRegion(
          onEnter: (_) => isHovered.value = true,
          onExit: (_) => isHovered.value = false,
          child: InkWell(
            onTap: () {
              if (item.isDialogRoute) {
                // Open a dialog instead of navigating
                if (item.routeName == 'fpmDashboard') {
                  showDialog(
                    context: context,
                    builder: (ctx) => const FPMDialogFilter(),
                  );
                } else if (item.routeName == 'dashboardService') {
                  showDialog(
                    context: context,
                    builder: (ctx) => const ServiceDialogFilter(),
                  );
                }
              } else {
                state.setSidebarItem(item.routeName);
                context.goNamed(item.routeName);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 130),
              height: 38,
              padding: const EdgeInsets.only(left: 28, right: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.sidebarActiveItem
                    : hovered
                        ? AppColors.sidebarHoverItem
                        : Colors.transparent,
                border: isActive
                    ? const Border(
                        left: BorderSide(
                          color: Colors.white,
                          width: 3,
                        ),
                      )
                    : const Border(
                        left: BorderSide(color: Colors.transparent, width: 3),
                      ),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 15,
                    color: isActive
                        ? Colors.white
                        : hovered
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.72),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        
                        fontSize: 11.5,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive
                            ? Colors.white
                            : hovered
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Collapse toggle button ─────────────────────────────────────────────────

  Widget _buildCollapseToggle() {
    return InkWell(
      onTap: _toggle,
      child: Container(
        height: 44,
        padding: EdgeInsets.symmetric(
          horizontal: _expanded ? 12 : 0,
        ),
        color: AppColors.sidebarBackgroundDark,
        child: Row(
          mainAxisAlignment:
              _expanded ? MainAxisAlignment.end : MainAxisAlignment.center,
          children: [
            if (_expanded)
              const Text(
                'Collapse',
                style: TextStyle(
                  
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),
            const SizedBox(width: 6),
            AnimatedRotation(
              duration: _animDuration,
              turns: _expanded ? 0.0 : 0.5,
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 18,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Access denied dialog ───────────────────────────────────────────────────

  void _showAccessDenied(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.raisinBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: const BorderSide(color: AppColors.borderMedium, width: 1.0),
        ),
        title: const Row(
          children: [
            Icon(Icons.lock_outline_rounded,
                color: AppColors.accentCoral, size: 20),
            SizedBox(width: 8),
            Text(
              'Akses Terbatas',
              style: TextStyle(
                
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: const Text(
          'Anda tidak memiliki hak akses untuk membuka menu ini.',
          style: TextStyle(
            
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
