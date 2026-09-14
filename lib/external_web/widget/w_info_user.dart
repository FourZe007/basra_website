import 'package:flutter/material.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/globalVar.dart';

class WInfoUser extends StatelessWidget {
  const WInfoUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(GlobalVar.username, style: TextStyle(fontWeight: FontWeight.bold)),
        Text('v1.0.16', style: GlobalFont.smallfontR),
      ],
    );
  }
}
