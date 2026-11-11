// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/label/label_static.dart';
import 'package:stsj/booking-service/widget/button/tombol.dart';

class KotakPesanCenter extends StatelessWidget {
  const KotakPesanCenter(this.header, this.detail, {super.key});

  final String header;
  final String detail;

  @override
  Widget build(BuildContext context) {
    void submit() {
      Navigator.pop(context);
    }

    return SizedBox(
      width: 300,
      height: MediaQuery.of(context).size.height / 4,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [LabelStatic(header, GlobalFont.tinymediumfontM)],
          ),
          const Divider(
              color: Colors.black, thickness: 2, indent: 10, endIndent: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LabelStatic(detail, GlobalFont.tinymediumfontM),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Tombol('OK', submit, lebar: 50, tinggi: 30)],
            ),
          ),
        ],
      ),
    );
  }
}
