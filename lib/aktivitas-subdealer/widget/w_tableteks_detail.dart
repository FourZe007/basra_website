import 'package:flutter/material.dart';
import 'package:stsj/global/font.dart';

class WTableTeksDetail extends StatelessWidget {
  const WTableTeksDetail(this.value, this.posisi, {super.key});
  final String value;
  final Alignment posisi;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: posisi,
      padding: const EdgeInsets.all(5),
      child: Text(value, style: GlobalFont.smallfontR),
    );
  }
}
