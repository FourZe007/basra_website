import 'package:flutter/material.dart';
import 'package:stsj/activity_point/models/activity00.dart';

Widget viewActivity00(Activity00 data) {
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
            Text('Lokasi', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Flexible(child: Text(data.lokasi == '' ? '-' : data.lokasi, style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jumlah Peserta', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.peserta} orang', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shop Manager', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.shopManager} orang', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sales Counter', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.salesCounter} orang', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Salesman', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.salesman} orang', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Other', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.other} orang', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Topik', style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
            const SizedBox(width: 20),
            Flexible(child: Text(data.topic == '' ? '-' : data.topic, style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),
          ],
        ),
        const SizedBox(height: 3),
        Text('Detail Briefing Pagi:', style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
        ...data.detail.map((det) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('◾', style: TextStyle(fontSize: 12)),
              Flexible(child: Text(det['detailTopic'], style: TextStyle(fontSize: 12))),
            ],
          );
        }),
      ],
    ),
  );
}
