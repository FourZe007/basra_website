import 'package:flutter/material.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';

Widget containerTable(String judul,
    {Color warna = Colors.transparent,
    bool formatMoney = false,
    bool percentFormat = false,
    bool firstIdx = false,
    bool lastIdx = false}) {
  final textValue = formatMoney
      ? Format.rupiahFormat(judul)
      : '${Format.thousandFormat(judul)}${percentFormat ? '%' : ''}';
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    decoration: BoxDecoration(
      color: warna,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(firstIdx ? 10 : 0),
        bottomRight: Radius.circular(lastIdx ? 10 : 0),
      ),
    ),
    child: Align(
      alignment: Alignment.centerRight,
      child: textValue.isEmpty
          ? const SizedBox.shrink()
          : FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                textValue,
                style: const TextStyle(fontSize: 13),
                textAlign: TextAlign.right,
                maxLines: 1,
              ),
            ),
    ),
  );
}
