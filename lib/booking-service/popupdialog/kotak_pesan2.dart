// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stsj/booking-service/widget/button/tombol.dart';
import 'package:stsj/global/theme/app_theme.dart';

class KotakPesan2 extends StatelessWidget {
  const KotakPesan2(this.header, this.detail, this.subdetail, {super.key});

  final String header;
  final String detail;
  final String subdetail;

  @override
  Widget build(BuildContext context) {
    void submit() {
      Navigator.pop(context);
    }

    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.mutedSurface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.accentGreen,
              size: 28,
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
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.secondaryMaroon.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadii.sm),
              border: Border.all(
                color: AppColors.primaryRed.withValues(alpha: 0.25),
              ),
            ),
            child: SelectableText(
              detail,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryRed,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subdetail,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
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
