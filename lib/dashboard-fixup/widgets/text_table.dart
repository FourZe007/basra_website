import 'package:flutter/material.dart';

Widget textTable(String judul) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: Align(
      alignment: Alignment.center,
      child: Text(
        judul,
        style: const TextStyle(fontSize: 13),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    ),
  );
}
