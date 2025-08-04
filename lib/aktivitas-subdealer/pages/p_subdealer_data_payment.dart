import 'package:flutter/material.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_history.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_tableteks_detail.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_tableteks_header.dart';

class PSubDealerDataPayment extends StatelessWidget {
  const PSubDealerDataPayment(this.index, {super.key});
  final int index;

  TableRow detailRow(int i) {
    var list = showActivityReport[index].dailyReport[0].dataPayment[i];

    return TableRow(
        decoration: BoxDecoration(
          color: i % 2 == 0 ? Colors.blueGrey[100] : Colors.blueGrey[50],
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        children: [
          WTableTeksDetail(list.payment, Alignment.centerLeft),
          WTableTeksDetail(
              list.resultPayment.toString(), Alignment.centerRight),
          WTableTeksDetail(list.lmPayment.toString(), Alignment.centerRight),
          WTableTeksDetail(
              '${list.growthPayment.toString()} %', Alignment.centerRight)
        ]);
  }

  @override
  Widget build(BuildContext context) {
    var list = showActivityReport[index].dailyReport[0].dataPayment;
    return Padding(
      padding: EdgeInsets.all(5),
      child: Table(
          border: TableBorder.all(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(0.2),
            1: FlexColumnWidth(0.05),
            2: FlexColumnWidth(0.05),
            3: FlexColumnWidth(0.05)
          },
          children: [
            TableRow(
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                children: const [
                  WTableTeksHeader('', Alignment.center),
                  WTableTeksHeader('R', Alignment.center),
                  WTableTeksHeader('LM', Alignment.center),
                  WTableTeksHeader('G', Alignment.center)
                ]),
            for (var i = 0; i < list.length; i++) detailRow(i)
          ]),
    );
  }
}
