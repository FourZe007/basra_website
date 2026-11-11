import 'package:flutter/material.dart';

Widget rasioTable(double judul) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            judul.isInfinite || judul.isNaN
                ? Icons.all_inclusive_rounded
                : judul > 100
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
            color: judul.isInfinite || judul.isNaN
                ? Colors.black
                : judul > 100
                    ? Colors.indigo
                    : Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 4),
          Text(
            judul.isInfinite || judul.isNaN
                ? '➖'
                : '${judul.toStringAsFixed(2)}%',
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    ),
  );
}
