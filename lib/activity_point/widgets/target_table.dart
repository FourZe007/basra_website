import 'package:flutter/material.dart';

Widget targetTable(int target, {bool last = false}) {
  return Container(
    decoration: BoxDecoration(
      color: target == 0 ? Colors.redAccent[100] : Colors.transparent,
      borderRadius: BorderRadius.only(bottomRight: last ? Radius.circular(5.0) : Radius.zero),
    ),
    child: Align(
      alignment: Alignment.center,
      child: Text(
        target.toString(),
        style: TextStyle(fontSize: 13),
        maxLines: 1,
      ),
    ),
  );
}
