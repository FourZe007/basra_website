import 'package:flutter/material.dart';

Widget headerTable(String judul) {
  return Center(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Align(
        alignment: Alignment.center,
        child: judul.isEmpty
            ? const SizedBox.shrink()
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
      ),
    ),
  );
}
