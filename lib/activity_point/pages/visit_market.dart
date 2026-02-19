import 'package:flutter/material.dart';
import 'package:stsj/activity_point/models/point_sm_dt.dart';
import 'package:stsj/activity_point/widgets/text_table2.dart';
import 'package:stsj/dashboard-fixup/utilities/format.dart';

class VisitMarket extends StatefulWidget {
  const VisitMarket(this.listDetail, {super.key});
  final List<PointSMDT> listDetail;

  @override
  State<VisitMarket> createState() => _VisitMarketState();
}

class _VisitMarketState extends State<VisitMarket> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SelectionArea(
        child: Table(
          border: TableBorder.all(color: Colors.black, borderRadius: BorderRadius.circular(10)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(1.7),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
              ),
              children: [
                textTable2('Tanggal', Alignment.center, 0),
                textTable2('Waktu', Alignment.center, 0),
                textTable2('Foto', Alignment.center, 0),
                textTable2('Caption', Alignment.center, 0),
              ],
            ),
            ...widget.listDetail.map((detail) {
              int idx = widget.listDetail.indexOf(detail) + 1;
              return TableRow(
                decoration: BoxDecoration(
                  //color: DateTime.parse(detail.currentDate).isBefore(DateTime.now()) && detail.targetHari == 0 ? Colors.redAccent[100] : Colors.white,
                  color: detail.targetHari == 0 ? Colors.redAccent[100] : Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(idx == widget.listDetail.length ? 10.0 : 0.0),
                    bottomRight: Radius.circular(idx == widget.listDetail.length ? 10.0 : 0.0),
                  ),
                ),
                children: [
                  textTable2(Format.tanggalFormat(detail.currentDate), Alignment.center, 1),
                  Center(
                    child: DateTime.parse(detail.currentDate).isAfter(DateTime.now()) || detail.targetHari == 0
                        ? SizedBox()
                        : detail.point1 == 1
                            ? Icon(Icons.check, color: Colors.green, fontWeight: FontWeight.bold)
                            : Icon(Icons.close, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: DateTime.parse(detail.currentDate).isAfter(DateTime.now()) || detail.targetHari == 0
                        ? SizedBox()
                        : detail.point2 == 1
                            ? Icon(Icons.check, color: Colors.green, fontWeight: FontWeight.bold)
                            : Icon(Icons.close, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: DateTime.parse(detail.currentDate).isAfter(DateTime.now()) || detail.targetHari == 0
                        ? SizedBox()
                        : detail.point3 == 1
                            ? Icon(Icons.check, color: Colors.green, fontWeight: FontWeight.bold)
                            : Icon(Icons.close, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
