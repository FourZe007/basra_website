import 'package:flutter/material.dart';
import 'package:stsj/activity_point/models/activity04.dart';

Widget viewActivity04(Activity04 data) {
  return Padding(
    padding: const EdgeInsets.only(left: 13, right: 15, top: 2, bottom: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jumlah Lamaran Masuk', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.dipanggil}', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          'Asal Lamaran',
          style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        ...data.listMedia.map((med) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(med.mediaName, style: TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(width: 20),
              Text('${med.qty}', style: TextStyle(fontSize: 12)),
            ],
          );
        }),
        const SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jumlah Dipanggil', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.dipanggil}', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jumlah Datang', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.datang}', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jumlah Diterima', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.diterima}', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    ),
  );
}
