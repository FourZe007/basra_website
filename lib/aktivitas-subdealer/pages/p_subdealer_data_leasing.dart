import 'package:flutter/material.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_history.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_tableteks_detail.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_tableteks_header.dart';

class PSubDealerDataLeasing extends StatelessWidget {
  const PSubDealerDataLeasing(this.index, {super.key});
  final int index;

  TableRow detailRow(int i) {
    var list = showActivityReport[index].dailyReport[0].dataLeasing[i];

    return TableRow(
        decoration: BoxDecoration(
          color: i % 2 == 0 ? Colors.blueGrey[100] : Colors.blueGrey[50],
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        children: [
          WTableTeksDetail(list.leasing, Alignment.centerLeft),
          WTableTeksDetail(list.totalSPK.toString(), Alignment.centerRight),
          WTableTeksDetail(list.openSPK.toString(), Alignment.centerRight),
          WTableTeksDetail(list.approvedSPK.toString(), Alignment.centerRight),
          WTableTeksDetail(list.rejectedSPK.toString(), Alignment.centerRight),
          WTableTeksDetail(
              '${list.approval.toString()} %', Alignment.centerRight),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    var list = showActivityReport[index].dailyReport[0].dataLeasing;
    return Container(
      padding: EdgeInsets.all(5),
      child: Table(
          border: TableBorder.all(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(0.3),
            1: FlexColumnWidth(0.1),
            2: FlexColumnWidth(0.1),
            3: FlexColumnWidth(0.1),
            4: FlexColumnWidth(0.1),
            5: FlexColumnWidth(0.125)
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
                  WTableTeksHeader('TOT', Alignment.center),
                  WTableTeksHeader('OPN', Alignment.center),
                  WTableTeksHeader('APP', Alignment.center),
                  WTableTeksHeader('RJC', Alignment.center),
                  WTableTeksHeader('%', Alignment.center)
                ]),
            for (var i = 0; i < list.length; i++) detailRow(i)
          ]),
    );
  }
}
