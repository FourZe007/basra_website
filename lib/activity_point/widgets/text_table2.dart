import 'package:flutter/material.dart';

Widget textTable2(String judul, Alignment align, int jenis) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    child: Align(
      alignment: align,
      child: Text(
        judul,
        style: jenis == 0 ? TextStyle(fontSize: 14, fontWeight: FontWeight.bold) : TextStyle(fontSize: 13),
        maxLines: 1,
      ),
    ),
  );
}
