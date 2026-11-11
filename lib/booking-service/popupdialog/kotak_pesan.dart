// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stsj/booking-service/widget/button/tombol.dart';
import 'package:stsj/global/theme/app_theme.dart';

class KotakPesan extends StatelessWidget {
  const KotakPesan(this.header, this.detail, {super.key});

  final String header;
  final String detail;

  @override
  Widget build(BuildContext context) {
    void submit() {
      Navigator.pop(context);
    }

    final bool isWarningOrError = header.toUpperCase().contains('WARNING') ||
        header.toUpperCase().contains('FAILED');

    return Container(
      width: 380,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.mutedSurface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isWarningOrError
                  ? const Color(0xFFFFE4E6)
                  : AppColors.secondaryMaroon,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isWarningOrError
                  ? Icons.warning_amber_rounded
                  : Icons.info_outline_rounded,
              color: isWarningOrError
                  ? AppColors.accentCoral
                  : AppColors.primaryRed,
              size: 26,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            header,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: Tombol('OK', submit, tinggi: 40),
          ),
        ],
      ),
    );
  }
}
