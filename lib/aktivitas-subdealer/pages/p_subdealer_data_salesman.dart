import 'package:flutter/material.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_history.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_tableteks_detail.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_tableteks_header.dart';

class PSubDealerDataSalesman extends StatelessWidget {
  const PSubDealerDataSalesman(this.index, {super.key});
  final int index;

  TableRow detailRow(int i) {
    var list = showActivityReport[index].dailyReport[0].dataSalesman[i];

    return TableRow(
        decoration: BoxDecoration(
          color: i % 2 == 0 ? Colors.blueGrey[100] : Colors.blueGrey[50],
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        children: [
          WTableTeksDetail(list.sname, Alignment.centerLeft),
          WTableTeksDetail(list.statusSM, Alignment.centerLeft),
          WTableTeksDetail(list.spk.toString(), Alignment.centerRight),
          WTableTeksDetail(list.stu.toString(), Alignment.centerRight),
          WTableTeksDetail(list.stuLM.toString(), Alignment.centerRight),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    var list = showActivityReport[index].dailyReport[0].dataSalesman;
    return Padding(
      padding: EdgeInsets.all(5),
      child: Table(
          border: TableBorder.all(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(0.15),
            1: FlexColumnWidth(0.15),
            2: FlexColumnWidth(0.05),
            3: FlexColumnWidth(0.05),
            4: FlexColumnWidth(0.05),
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
                  WTableTeksHeader('JABATAN', Alignment.center),
                  WTableTeksHeader('SPK', Alignment.center),
                  WTableTeksHeader('STU', Alignment.center),
                  WTableTeksHeader('LM', Alignment.center)
                ]),
            for (var i = 0; i < list.length; i++) detailRow(i)
          ]),
    );
  }
}
