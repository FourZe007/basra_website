// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LabelStatic extends StatelessWidget {
  const LabelStatic(this.judul, this.modelfont,
      {this.gap = const EdgeInsets.all(20), super.key});

  final String judul;
  final EdgeInsetsGeometry gap;
  final TextStyle modelfont;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text(
        judul,
        style: modelfont,
        textAlign: TextAlign.center,
      ),
    );
  }
}
