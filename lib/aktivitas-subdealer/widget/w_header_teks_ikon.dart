import 'package:flutter/material.dart';
import 'package:stsj/global/font.dart';

class WHeaderTeksIkon extends StatelessWidget {
  const WHeaderTeksIkon(this.value, this.ikon, this.warna, {super.key});
  final String value;
  final IconData ikon;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(children: [
        Icon(ikon, color: warna),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(value, style: GlobalFont.bigfontMBold),
        ),
      ]),
    );
  }
}
