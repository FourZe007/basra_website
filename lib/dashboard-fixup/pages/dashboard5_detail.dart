import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/dashboard-fixup/models/dashboard5_model.dart';
import 'package:stsj/dashboard-fixup/widgets/header_table.dart';
import 'package:stsj/dashboard-fixup/widgets/text_table.dart';

class Dashboard5Detail extends StatefulWidget {
  const Dashboard5Detail(this.listData, this.handle, {super.key});
  final List<Dashboard5> listData;
  final Function handle;

  @override
  State<Dashboard5Detail> createState() => _Dashboard5DetailState();
}

class _Dashboard5DetailState extends State<Dashboard5Detail> {
  int indexPage = 0;
  int range = 15;
  int startIndex = 0;
  int lastIndex = 0;
  late ScrollController _scrollController;
  late List<Dashboard5> showList = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //SET SETIAP SETSTATE INDEX
    if (widget.listData.isEmpty) {
      showList = [];
      startIndex = 0;
      lastIndex = 0;
    } else {
      if (widget.listData.length > ((indexPage * range) + range)) {
        showList = widget.listData
            .sublist((indexPage * range), ((indexPage * range) + range));
        startIndex = indexPage * range + 1;
        lastIndex = (indexPage * range) + range;
      } else {
        showList = widget.listData.sublist((indexPage * range));
        startIndex = indexPage * range + 1;
        lastIndex = widget.listData.length;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.indigo.withAlpha(80),
          width: double.infinity,
          child: const Padding(
            padding: EdgeInsets.only(
                left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
            child: Text(
              'DETAIL',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            indexPage > 0
                ? ElevatedButton(
                    onPressed: () async {
                      if (indexPage > 0) {
                        setState(() => indexPage -= 1);
                        await _scrollController.animateTo(0,
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 100));
                      }
                    },
                    child: const Text(
                      '<',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox(width: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '$startIndex-$lastIndex of ${widget.listData.length}',
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            indexPage < ((widget.listData.length - 1) / range).floor()
                ? ElevatedButton(
                    onPressed: () async {
                      if (indexPage <
                          ((widget.listData.length - 1) / range).floor()) {
                        setState(() => indexPage += 1);
                        await _scrollController.animateTo(0,
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 100));
                      }
                    },
                    child: const Text(
                      '>',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox(width: 60)
          ],
        ),
        const SizedBox(height: 10),
        Flexible(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final hPad = constraints.maxWidth < 600 ? 12.0 : 20.0;
              final availWidth = constraints.maxWidth - (hPad * 2);
              final minTableWidth = math.max(availWidth, 820.0);

              return ListView(
                controller: _scrollController,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: minTableWidth,
                        child: SelectionArea(
                          child: Table(
                            border: TableBorder.all(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            columnWidths: const {
                              0: FlexColumnWidth(0.4),
                              1: FlexColumnWidth(0.9),
                              2: FlexColumnWidth(1.3),
                              3: FlexColumnWidth(1),
                              4: FlexColumnWidth(1.4),
                              5: FlexColumnWidth(0.7),
                              6: FlexColumnWidth(0.7),
                              7: FlexColumnWidth(0.8),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(10),
                                    topRight: const Radius.circular(10),
                                    bottomLeft: Radius.circular(
                                        showList.isEmpty ? 10.0 : 0.0),
                                    bottomRight: Radius.circular(
                                        showList.isEmpty ? 10.0 : 0.0),
                                  ),
                                ),
                                children: [
                                  headerTable(''),
                                  headerTable('MEMBER ID'),
                                  headerTable('NAMA'),
                                  headerTable('TELEPON'),
                                  headerTable('EMAIL'),
                                  headerTable('POIN'),
                                  headerTable('KUNJUNGAN'),
                                  headerTable('TANGGAL'),
                                ],
                              ),
                              ...showList.map((item) {
                                return TableRow(
                                  children: [
                                    IconButton(
                                      onPressed: item.detail.isEmpty
                                          ? null
                                          : () => widget.handle(item),
                                      icon: const Icon(Icons.remove_red_eye),
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                    ),
                                    textTable(item.memberId),
                                    textTable(item.memberName),
                                    textTable(Format.phoneFormat(item.phoneNo)),
                                    textTable(item.emailAddress),
                                    textTable(
                                      Format.thousandFormat(
                                          item.pointQty.toString()),
                                    ),
                                    textTable(item.totalVisit.toString()),
                                    textTable(
                                        Format.tanggalFormat(item.lastVisit)),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
