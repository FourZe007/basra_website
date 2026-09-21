import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/models/AuthModel/Auth_Model.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/router/router_const.dart';

class WTombolLogout extends StatelessWidget {
  const WTombolLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
              ),
              radius: 17,
            ),
          ),
          Positioned.fill(
            child: PopupMenuButton<String>(
              tooltip: 'User Menu',
              color: AppColors.raisinBlack,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.md),
                side: const BorderSide(color: AppColors.borderMedium, width: 1.0),
              ),
              offset: const Offset(0, 44),
              icon: const SizedBox.shrink(),
              onSelected: (value) {
                if (value == 'logout') return;
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'logout',
                  height: 40,
                  onTap: () async {
                    await Auth.resetAuth();
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    // ignore: use_build_context_synchronously
                    context.go(RoutesConstant.login);

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
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout_rounded,
                        size: 18,
                        color: AppColors.accentCoral,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Logout',
                        style: TextStyle(
                          
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
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
    );
  }
}
