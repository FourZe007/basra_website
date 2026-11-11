// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stsj/global/theme/app_theme.dart';

class LabelTable extends StatelessWidget {
  const LabelTable(
    this.judul,
    this.align,
    this.jenis, {
    this.isAlign = false,
    super.key,
  });

  final String judul;
  final Alignment align;
  final int jenis;
  final bool isAlign;

  @override
  Widget build(BuildContext context) {
    final bool isHeader = jenis == 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      color: isHeader ? AppColors.primaryRed : Colors.transparent,
      child: Align(
        alignment: align,
        child: Text(
          judul,
          textAlign: isAlign ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: isHeader ? Colors.white : AppColors.textPrimary,
            fontSize: isHeader ? 12.5 : 13,
            fontWeight: isHeader ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: isHeader ? 0.4 : 0.0,
          ),
        ),
      ),
    );
  }
}
