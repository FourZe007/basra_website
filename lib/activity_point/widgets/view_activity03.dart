import 'package:flutter/material.dart';
import 'package:stsj/activity_point/models/activity03.dart';

Widget viewActivity03(Activity03 data) {
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
            Text('DEALER', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Flexible(
              child: Text(
                data.bsName == '' ? '-' : data.bsName,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AREA', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Flexible(
              child: Text(
                data.area == '' ? '-' : data.area,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          '*Sales to User*',
          style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        ...data.listStu.map((stu) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stu.category, style: TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  '${stu.tm}/${stu.target} (${stu.acv}%) - LM ${stu.lm} (${stu.growth.toStringAsFixed(2)}%)',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 3),
        Text(
          '*Cash/Credit*',
          style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        ...data.listPayment.map((pay) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pay.payment, style: TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  '${pay.tm}/${pay.lm} (${pay.growth.toStringAsFixed(2)}%)',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 3),
        Text(
          '*SPK Leasing Total*',
          style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TERBUKA', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.listSpk[0].terbuka}', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TOTAL SPK', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.listSpk[0].total}/25 (${(data.listSpk[0].total / 25 * 100).toStringAsFixed(2)}%)', style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('RATIO', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 20),
            Text('${data.listSpk[0].persentase.toStringAsFixed(2)}%', style: TextStyle(fontSize: 12)),
          ],
        ),
        const Text('-----', style: TextStyle(color: Colors.black54)),
        ...data.listSpk.map((spk) {
          if (data.listSpk.indexOf(spk) == 0) return SizedBox();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(spk.leasingId, style: TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  'SPK:${spk.total}/Terbuka:${spk.terbuka}/Approval:${spk.persentase.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 3),
        Text(
          '*Sales Team Condition*',
          style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        ...data.listEmployee.map((emp) {
          String tmpPos = emp.eType == '00'
              ? 'F'
              : emp.position == '01'
                  ? 'G'
                  : emp.position == '02'
                      ? 'P'
                      : 'SC';
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: Text('${emp.eName} ($tmpPos)', style: TextStyle(fontSize: 12, color: Colors.black54))),
              const SizedBox(width: 20),
              Text('${emp.spk}-${emp.stu}/${emp.stulm}', style: TextStyle(fontSize: 12)),
            ],
          );
        }),
      ],
    ),
  );
}
