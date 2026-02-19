import 'package:flutter/material.dart';
import 'package:stsj/activity_point/models/activity01.dart';

Widget viewActivity01(Activity01 data) {
  return Padding(
    padding: const EdgeInsets.only(left: 13, right: 15, top: 2, bottom: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jenis Aktivitas', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Flexible(child: Text(data.jenisAktivitas == '' ? '-' : data.jenisAktivitas, style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lokasi', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Flexible(child: Text(data.lokasi == '' ? '-' : data.lokasi, style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jumlah Sales', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.salesman} orang', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unit Display', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Flexible(child: Text(data.unitDisplay == '' ? '-' : data.unitDisplay, style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Database', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.database}', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Hot Prospek', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.hotprospek}', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Deal', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.deal}', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unit Test Ride', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Flexible(child: Text(data.unitTestRide == '' ? '-' : data.unitTestRide, style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Peserta Test Ride', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.deal} orang', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    ),
  );
}
