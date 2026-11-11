import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stsj/booking-service/global/model.dart';
import 'package:stsj/global/theme/app_theme.dart';

class GlobalUser {
  static String userID = '';
  static String adminID = '';
  static String password = '';
  static int flag = 0;
  static String fCMToken = '';
  static String accessToken = '';
}

class GlobalVar {
  static bool isAccept = false;
  static bool isReject = false;
  static bool isLoading = false;

  static List<ModelResultMessage> listbooking = [];
  static List<ModelBooking> listBrowseBooking = [];
  static List<ModelResultMessage> listModelModify = [];
  static List<ModelBrowseUser> listUserData = [];
  static List<ModelLogin> listLogin = [];
  static List<ModelUserLogin> listUserLogin = [];
  static List<ModelBrowseUser> browseAccList = [];
  static List<ModelBrowseUser> tempList = [];

  // Paging Settings
  static int currentPage = 1;
  static int indexawal = 0;
  static int indexakhir = 0;
  static double totalPage = 0;

  static var tglFormat = DateFormat('dd/MM/yyyy');
}

class GlobalFunction {
  static tampilkanDialog(BuildContext context, Widget widget) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            side: const BorderSide(color: AppColors.border, width: 1.0),
          ),
          backgroundColor: AppColors.mutedSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          child: widget,
        );
      },
    );
  }
}

class GlobalDecoration {
  static BoxDecoration dekorasiExpansionTile = BoxDecoration(
    color: AppColors.mutedSurface,
    border: Border.all(color: AppColors.border, width: 1),
    borderRadius: BorderRadius.circular(AppRadii.lg),
  );
  static BoxDecoration dekorasiExpansionTileNoBorder = BoxDecoration(
    borderRadius: BorderRadius.circular(AppRadii.lg),
  );
  static BoxDecoration dekorasiTabView = BoxDecoration(
    borderRadius: BorderRadius.circular(AppRadii.lg),
    color: AppColors.mutedSurface,
  );
}

class GlobalFont {
  static TextStyle mediumBigFontC = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bigfontC = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontCWhite = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    backgroundColor: Colors.transparent,
  );

  static TextStyle giantfontC = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static TextStyle gigafontC = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static TextStyle titleLoginFontW2C = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tinymediumfontM = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tinymediumfontMWhite = const TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumbigfontM = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
  );

  static TextStyle mediumfontR = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bigfontR = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    backgroundColor: Colors.transparent,
  );

  static TextStyle giantfontR = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static TextStyle giantfontRWhite = const TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static TextStyle giantfontRGreen = const TextStyle(
    color: AppColors.accentGreen,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static TextStyle giantfontRRed = const TextStyle(
    color: AppColors.accentCoral,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static TextStyle mediumBigFontCGR = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumFontCGR = const TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}

class GlobalColor {
  static Color? colorBoxMenu =
      const Color.fromARGB(136, 198, 205, 205).withValues(alpha: 0.3);
  static Color colorCenterContainerLogin =
      const Color.fromARGB(171, 255, 255, 255);
}
