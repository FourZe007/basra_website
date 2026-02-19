import 'package:flutter/material.dart';
import 'package:stsj/activity_point/models/activity02.dart';

Widget viewActivity02(Activity02 data) {
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
            Text('Media Sosial', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Flexible(child: Text(data.media == '' ? '-' : data.media, style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Info Lowongan', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Flexible(child: Text(data.posisi == '' ? '-' : data.posisi, style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),
          ],
        ),
      ],
    ),
  );
}
