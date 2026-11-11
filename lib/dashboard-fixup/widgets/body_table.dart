import 'package:flutter/material.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';

Widget bodyTable(String judul, {bool formatMoney = false}) {
  final formatted =
      formatMoney ? Format.rupiahFormat(judul) : Format.thousandFormat(judul);
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
    child: Align(
      alignment: Alignment.centerRight,
      child: formatted.isEmpty
          ? const SizedBox.shrink()
          : FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                formatted,
                style: const TextStyle(fontSize: 13),
                textAlign: TextAlign.right,
                maxLines: 1,
              ),
            ),
    ),
  );
}
