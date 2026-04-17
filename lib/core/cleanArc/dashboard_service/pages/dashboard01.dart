import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/global.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/style.dart';
import 'package:stsj/core/cleanArc/dashboard_service/models/dashboard.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/header_table.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/text_table.dart';

class Dashboard01 extends StatefulWidget {
  const Dashboard01(this.listDashboard, {super.key});
  final List<Dashboard> listDashboard;

  @override
  State<Dashboard01> createState() => _Dashboard01State();
}

class _Dashboard01State extends State<Dashboard01> with AutomaticKeepAliveClientMixin<Dashboard01> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  List<Dashboard> showDashboard = [];

  @override
  void initState() {
    super.initState();

    showDashboard = widget.listDashboard;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Theme(
      data: ThemeData(fontFamily: 'Poppins'),
      child: Scaffold(
        key: _scaffoldKey,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 5),
                Text('BY DEALER', style: text20SB),
                const Spacer(),
                ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.download), label: Text('Export', style: text12Med)),
                const SizedBox(width: 5),
                ElevatedButton.icon(
                  onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                  icon: const Icon(Icons.filter_alt),
                  label: Text('Filter', style: text12Med),
                ),
                const SizedBox(width: 5),
              ],
            ),
            const SizedBox(height: 5),
            loading
                ? SpinKitWave(color: blueOcean, size: 35)
                : SelectionArea(
                    child: Table(
                      border: TableBorder.all(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(0.75),
                        3: FlexColumnWidth(0.75),
                        4: FlexColumnWidth(0.75),
                        5: FlexColumnWidth(0.75),
                        6: FlexColumnWidth(0.75),
                        7: FlexColumnWidth(0.75),
                        8: FlexColumnWidth(0.85),
                        9: FlexColumnWidth(1.05),
                        10: FlexColumnWidth(1.05),
                        11: FlexColumnWidth(1.05),
                        12: FlexColumnWidth(1),
                        13: FlexColumnWidth(1),
                        14: FlexColumnWidth(1.05),
                        15: FlexColumnWidth(0.9),
                        16: FlexColumnWidth(0.9),
                        17: FlexColumnWidth(0.9),
                        18: FlexColumnWidth(0.9),
                        19: FlexColumnWidth(0.9),
                        20: FlexColumnWidth(0.75),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: blueUrainan,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(10),
                              topRight: const Radius.circular(10),
                              bottomLeft: Radius.circular(showDashboard.isEmpty ? 10.0 : 0.0),
                              bottomRight: Radius.circular(showDashboard.isEmpty ? 10.0 : 0.0),
                            ),
                          ),
                          children: [
                            HeaderTable(eAsd, Alignment.center),
                            HeaderTable(eKode, Alignment.center),
                            HeaderTable(eKsg1, Alignment.center),
                            HeaderTable(eKsg2, Alignment.center),
                            HeaderTable(eKsg3, Alignment.center),
                            HeaderTable(eKsg4, Alignment.center),
                            HeaderTable(eKsg, Alignment.center),
                            HeaderTable(eKsb, Alignment.center),
                            HeaderTable(eUnitEntry, Alignment.center),
                            HeaderTable(eJasaTotal, Alignment.center),
                            HeaderTable(eWsPart, Alignment.center),
                            HeaderTable(eWsOli, Alignment.center),
                            HeaderTable(eRetailPart, Alignment.center),
                            HeaderTable(eRetailOli, Alignment.center),
                            HeaderTable(eOmzet, Alignment.center),
                            HeaderTable(eSpu, Alignment.center),
                            HeaderTable(eSpuJasa, Alignment.center),
                            HeaderTable(eSpuPart, Alignment.center),
                            HeaderTable(eSpuOli, Alignment.center),
                            HeaderTable(eSpuRetail, Alignment.center),
                            HeaderTable(eRut, Alignment.center),
                          ],
                        ),
                        ...showDashboard.map((item) {
                          int idx = showDashboard.indexOf(item);
                          return TableRow(
                            decoration: (idx + 1) % 2 == 0
                                ? BoxDecoration(
                                    color: lighPurple100.withOpacity(0.3),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular((idx + 1) == showDashboard.length ? 10.0 : 0.0),
                                      bottomRight: Radius.circular((idx + 1) == showDashboard.length ? 10.0 : 0.0),
                                    ),
                                  )
                                : const BoxDecoration(),
                            children: [
                              TextTable(item.asd, Alignment.centerLeft, 1),
                              Tooltip(
                                message: 'Group : ${item.groupDealer}\nArea : ${item.area}\nKab/Kota : ${item.cDistrict}\nBengkel : ${item.cName}',
                                textStyle: text11Reg.copyWith(color: white),
                                waitDuration: const Duration(milliseconds: 500),
                                excludeFromSemantics: true,
                                child: TextTable(item.dpackId, Alignment.centerLeft, 1),
                              ),
                              TextTable(Format.thousandFormat(item.ksg1.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.ksg2.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.ksg3.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.ksg4.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.ksg.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.ksb.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.unitEntry.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.labourCost.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.workshopPart.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.workshopOli.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.retailPart.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.retailOli.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.omzet.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.spu.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.labourSpu.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.workshopPartSpu.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.workshopOliSpu.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.workshopSpu.toString()), Alignment.centerRight, 1),
                              TextTable(Format.thousandFormat(item.rtu.toString()), Alignment.centerRight, 1),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
