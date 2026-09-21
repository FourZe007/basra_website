import 'package:flutter/material.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/globalVar.dart';
import 'package:stsj/global/theme/app_theme.dart';

class WInfoUser extends StatelessWidget {
  const WInfoUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          GlobalVar.username.isNotEmpty ? GlobalVar.username : 'User',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 12.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: AppColors.surfaceLighter,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            border: Border.all(color: AppColors.borderMedium, width: 0.8),
          ),
          child: const Text(
            'v1.0.16',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
