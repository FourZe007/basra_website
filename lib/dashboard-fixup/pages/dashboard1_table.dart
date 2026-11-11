import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:stsj/dashboard-fixup/models/dashboard1_model.dart';
import 'package:stsj/dashboard-fixup/widgets/body_table.dart';
import 'package:stsj/dashboard-fixup/widgets/header_table.dart';
import 'package:stsj/dashboard-fixup/widgets/rasio_table.dart';
import 'package:stsj/dashboard-fixup/widgets/text_table.dart';

class Dashboard1Table extends StatefulWidget {
  const Dashboard1Table(this.listDashboard, this.bln, {super.key});
  final List<Dashboard1> listDashboard;
  final String bln;

  @override
  State<Dashboard1Table> createState() => _Dashboard1TableState();
}

class _Dashboard1TableState extends State<Dashboard1Table> {
  @override
  Widget build(BuildContext context) {
    if (widget.listDashboard.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final hPad = constraints.maxWidth < 600 ? 12.0 : 20.0;
        final availWidth = constraints.maxWidth - (hPad * 2);
        final tableWidth = math.max(availWidth, 760.0);

        return ListView(
          padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 40),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                child: SelectionArea(
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(0.8),
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(0.8),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        children: [
                          const Text(''),
                          headerTable('ACTUAL'),
                          headerTable('LAST MONTH'),
                          headerTable('% LAST MONTH'),
                          headerTable('LAST YEAR'),
                          headerTable('% LAST YEAR'),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade300.withOpacity(0.3),
                        ),
                        children: [
                          textTable('TOTAL UNIT ENTRY'),
                          bodyTable(
                              widget.listDashboard[0].unitEntryTm.toString()),
                          bodyTable(
                              widget.listDashboard[0].unitEntryLm.toString()),
                          rasioTable(
                            widget.listDashboard[0].unitEntryTm *
                                100 /
                                widget.listDashboard[0].unitEntryLm,
                          ),
                          bodyTable(
                              widget.listDashboard[0].unitEntryLy.toString()),
                          rasioTable(
                            widget.listDashboard[0].unitEntryTm *
                                100 /
                                widget.listDashboard[0].unitEntryLy,
                          ),
                        ],
                      ),
                      ...widget.listDashboard[0].detail.map((e) {
                        return TableRow(
                          children: [
                            textTable(e.bsName),
                            bodyTable(e.unitEntryTmBS.toString()),
                            bodyTable(e.unitEntryLmBS.toString()),
                            rasioTable(e.unitEntryTmBS * 100 / e.unitEntryLmBS),
                            bodyTable(e.unitEntryLyBS.toString()),
                            rasioTable(e.unitEntryTmBS * 100 / e.unitEntryLyBS),
                          ],
                        );
                      }).toList(),
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade300.withOpacity(0.3),
                        ),
                        children: [
                          textTable('TOTAL OMSET'),
                          bodyTable(
                            widget.listDashboard[0].omsetTm.toString(),
                            formatMoney: true,
                          ),
                          bodyTable(
                            widget.listDashboard[0].omsetLm.toString(),
                            formatMoney: true,
                          ),
                          rasioTable(
                            widget.listDashboard[0].omsetTm *
                                100 /
                                widget.listDashboard[0].omsetLm,
                          ),
                          bodyTable(
                            widget.listDashboard[0].omsetLy.toString(),
                            formatMoney: true,
                          ),
                          rasioTable(
                            widget.listDashboard[0].omsetTm *
                                100 /
                                widget.listDashboard[0].omsetLy,
                          ),
                        ],
                      ),
                      ...widget.listDashboard[0].detail.map((e) {
                        return TableRow(
                          children: [
                            textTable(e.bsName),
                            bodyTable(e.omsetTmBS.toString(),
                                formatMoney: true),
                            bodyTable(e.omsetLmBS.toString(),
                                formatMoney: true),
                            rasioTable(e.omsetTmBS * 100 / e.omsetLmBS),
                            bodyTable(e.omsetLyBS.toString(),
                                formatMoney: true),
                            rasioTable(e.omsetTmBS * 100 / e.omsetLyBS),
                          ],
                        );
                      }).toList(),
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade300.withOpacity(0.3),
                        ),
                        children: [
                          textTable('TOTAL PART'),
                          bodyTable(
                            widget.listDashboard[0].tmP.toString(),
                            formatMoney: true,
                          ),
                          bodyTable(
                            widget.listDashboard[0].lmP.toString(),
                            formatMoney: true,
                          ),
                          rasioTable(
                            widget.listDashboard[0].tmP *
                                100 /
                                widget.listDashboard[0].lmP,
                          ),
                          bodyTable(
                            widget.listDashboard[0].lyP.toString(),
                            formatMoney: true,
                          ),
                          rasioTable(
                            widget.listDashboard[0].tmP *
                                100 /
                                widget.listDashboard[0].lyP,
                          ),
                        ],
                      ),
                      ...widget.listDashboard[0].detail.map((e) {
                        return TableRow(
                          children: [
                            textTable(e.bsName),
                            bodyTable(e.tmPBS.toString(), formatMoney: true),
                            bodyTable(e.lmPBS.toString(), formatMoney: true),
                            rasioTable(e.tmPBS * 100 / e.lmPBS),
                            bodyTable(e.lyPBS.toString(), formatMoney: true),
                            rasioTable(e.tmPBS * 100 / e.lyPBS),
                          ],
                        );
                      }).toList(),
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade300.withOpacity(0.3),
                        ),
                        children: [
                          textTable('TOTAL PART & SERVICE'),
                          bodyTable(
                            widget.listDashboard[0].tmPS.toString(),
                            formatMoney: true,
                          ),
                          bodyTable(
                            widget.listDashboard[0].lmPS.toString(),
                            formatMoney: true,
                          ),
                          rasioTable(
                            widget.listDashboard[0].tmPS *
                                100 /
                                widget.listDashboard[0].lmPS,
                          ),
                          bodyTable(
                            widget.listDashboard[0].lyPS.toString(),
                            formatMoney: true,
                          ),
                          rasioTable(
                            widget.listDashboard[0].tmPS *
                                100 /
                                widget.listDashboard[0].lyPS,
                          ),
                        ],
                      ),
                      ...widget.listDashboard[0].detail.map((e) {
                        return TableRow(
                          children: [
                            textTable(e.bsName),
                            bodyTable(e.tmPSBS.toString(), formatMoney: true),
                            bodyTable(e.lmPSBS.toString(), formatMoney: true),
                            rasioTable(e.tmPSBS * 100 / e.lmPSBS),
                            bodyTable(e.lyPSBS.toString(), formatMoney: true),
                            rasioTable(e.tmPSBS * 100 / e.lyPSBS),
                          ],
                        );
                      }).toList(),
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade300.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        children: [
                          textTable('TOTAL SERVICE'),
                          bodyTable(
                            widget.listDashboard[0].tmS.toString(),
                            formatMoney: true,
                          ),
                          bodyTable(
                            widget.listDashboard[0].lmS.toString(),
                            formatMoney: true,
                          ),
                          rasioTable(
                            widget.listDashboard[0].tmS *
                                100 /
                                widget.listDashboard[0].lmS,
                          ),
                          bodyTable(
                            widget.listDashboard[0].lyS.toString(),
                            formatMoney: true,
                          ),
                          rasioTable(
                            widget.listDashboard[0].tmS *
                                100 /
                                widget.listDashboard[0].lyS,
                          ),
                        ],
                      ),
                      ...widget.listDashboard[0].detail.map((e) {
                        return TableRow(
                          children: [
                            textTable(e.bsName),
                            bodyTable(e.tmSBS.toString(), formatMoney: true),
                            bodyTable(e.lmSBS.toString(), formatMoney: true),
                            rasioTable(e.tmSBS * 100 / e.lmSBS),
                            bodyTable(e.lySBS.toString(), formatMoney: true),
                            rasioTable(e.tmSBS * 100 / e.lySBS),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
