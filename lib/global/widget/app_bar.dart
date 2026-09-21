import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/controller/Login_controller.dart';
import 'package:stsj/core/models/AuthModel/Auth_Model.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/globalVar.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/core/views/app_shell.dart';
import 'package:stsj/dashboard-fixup/utilities/utils.dart';
import 'package:stsj/router/router_const.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    Key? key,
    this.goBack,
    this.isRoutes = true,
    this.imageSize = 50,
    this.profileRadius = 20,
    this.returnButtonSize = 25,
    this.onHamburgerTap,
  }) : super(key: key);

  final String? goBack;
  final bool isRoutes;
  final double imageSize;
  final double profileRadius;
  final double returnButtonSize;
  /// When provided, a hamburger icon button is shown in the leading area
  /// instead of the back arrow. Used by [MenuPages] on narrow screens to
  /// open the sidebar drawer.
  final VoidCallback? onHamburgerTap;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}


class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildBackButton({required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        icon: Icon(
          Icons.arrow_back_rounded,
          size: widget.returnButtonSize,
          color: AppColors.textPrimary,
        ),
        onPressed: onTap,
        splashRadius: 20,
        tooltip: 'Back',
      ),
    );
  }

  Widget _buildUserActions({required VoidCallback onLogout}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.darkGrey,
            borderRadius: BorderRadius.circular(AppRadii.full),
            border: Border.all(color: AppColors.border, width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                GlobalVar.username,
                style: const TextStyle(
                  
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadii.full),
                ),
                child: const Text(
                  'v1.0.16',
                  style: TextStyle(
                    
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentYellow,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accentYellow.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: const NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                  ),
                  radius: widget.profileRadius,
                ),
              ),
              Positioned.fill(
                child: PopupMenuButton<String>(
                  icon: const SizedBox.shrink(),
                  color: AppColors.softCharcoal,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      onLogout();
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: const [
                          Icon(Icons.logout_rounded, size: 16, color: AppColors.accentCoral),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              
                              fontSize: 13,
                              color: AppColors.accentCoral,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouterState.of(context).name;
    final state = Provider.of<MenuState>(context);
    print('CustomAppbar Current route: ${GoRouterState.of(context).name}');

    double screenWidth = MediaQuery.of(context).size.width;
    bool screen = screenWidth >= 768; // Or import screenHeight.screen if needed

    if (widget.isRoutes) {
      final canGoBack = router != RoutesConstant.homepage &&
          router != RoutesConstant.report &&
          widget.goBack != null;

      return AppBar(
        centerTitle: true,
        backgroundColor: AppColors.softCharcoal,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1.0),
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.065,
        leading: (!screen)
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.darkGrey,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  border: Border.all(color: AppColors.border, width: 1.0),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu_rounded,
                    size: 22,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {
                    if (widget.onHamburgerTap != null) {
                      widget.onHamburgerTap!();
                    } else {
                      appShellScaffoldKey.currentState?.openDrawer();
                    }
                  },
                  tooltip: 'Menu',
                ),
              )
            : canGoBack
                ? _buildBackButton(
                    onTap: () {
                      if (router == RoutesConstant.absentHistory) {
                        state.resetAbsentHistory();
                      }
                      
                      if (widget.goBack == RoutesConstant.menu) {
                        final infoRoutes = [
                          RoutesConstant.report,
                          RoutesConstant.absentHistory,
                          RoutesConstant.browseSalesman,
                          RoutesConstant.bikesHistory,
                          RoutesConstant.serviceHistory,
                          RoutesConstant.mdsSparepartStock,
                        ];
                        
                        final toolRoutes = [
                          RoutesConstant.service,
                          RoutesConstant.branchFreeStock,
                          RoutesConstant.importAlokasiBM,
                          RoutesConstant.koreksiAlokasiBM,
                          RoutesConstant.importCetakQR,
                        ];

                        if (infoRoutes.contains(router)) {
                          state.setStaticMenuNotifier('report');
                        } else if (toolRoutes.contains(router)) {
                          state.setStaticMenuNotifier('tools');
                        }
                      }
                      
                      context.goNamed(widget.goBack!);
                    },
                  )
                : null,
        title: Image.asset(
          'assets/images/stsj.png',
          width: widget.imageSize,
        ),
        actions: [
          _buildUserActions(
            onLogout: () async {
              await Auth.resetAuth();
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              if (context.mounted) context.go(RoutesConstant.login);

              Fluttertoast.showToast(
                msg: 'Logout berhasil!',
                textColor: Colors.black,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                webPosition: 'center',
                webBgColor: 'linear-gradient(to right, #00FF00, #00FF00)',
                timeInSecForIosWeb: 2,
              );
            },
          ),
        ],
      );
    } else {
      return AppBar(
        centerTitle: true,
        backgroundColor: AppColors.raisinBlack,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1.0),
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.065,
        leading: _buildBackButton(
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          'assets/images/stsj.png',
          width: widget.imageSize,
        ),
        actions: [
          _buildUserActions(
            onLogout: () {
              DataLoginController.removeDataUser();
              context.go(RoutesConstant.login);

              Fluttertoast.showToast(
                msg: "Anda telah Logout",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                webPosition: "center",
                webBgColor: "linear-gradient(to right, #00FF00, #00FF00)",
                timeInSecForIosWeb: 2,
              );
            },
          ),
        ],
      );
    }
  }
}
