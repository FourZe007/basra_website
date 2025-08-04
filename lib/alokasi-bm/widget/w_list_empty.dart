import 'package:flutter/material.dart';
import 'package:stsj/global/font.dart';

class WListEmpty extends StatelessWidget {
  const WListEmpty(this.value, this.ikon, this.warna, this.ukuran, {super.key});

  final String value;
  final double ukuran;
  final IconData ikon;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(ikon, color: warna, size: ukuran),
      Text(value, style: GlobalFont.petafontRBold),
    ]);
  }
}
