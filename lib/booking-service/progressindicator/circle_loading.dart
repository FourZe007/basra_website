import 'package:flutter/material.dart';
import 'package:stsj/global/theme/app_theme.dart';

class CircleLoading extends StatelessWidget {
  const CircleLoading({this.warna = AppColors.primaryRed, super.key});
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 36,
      child: Center(
        heightFactor: 1,
        widthFactor: 1,
        child: SizedBox(
          height: 28,
          width: 28,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: warna,
          ),
        ),
      ),
    );
  }
}
