import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/models/dashboard.dart';
import 'package:stsj/dashboard-fixup/models/dashboard3_model.dart';
import 'package:stsj/dashboard-fixup/services/api.dart';
import 'package:stsj/dashboard-fixup/utilities/basepage.dart';
import 'package:stsj/dashboard-fixup/utilities/enum.dart';
import 'package:stsj/dashboard-fixup/utilities/utils.dart';
import 'package:stsj/dashboard-fixup/widgets/container_table.dart';
import 'package:stsj/dashboard-fixup/widgets/header_table.dart';
import 'package:stsj/dashboard-fixup/widgets/text_table.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class Dashboard3Page extends StatefulWidget {
  const Dashboard3Page({
    super.key,
  });

  @override
  State<Dashboard3Page> createState() => _Dashboard3PageState();
}

class _Dashboard3PageState extends State<Dashboard3Page>
    with BasePage, AutomaticKeepAliveClientMixin<Dashboard3Page> {
  late List<Dashboard3> listDashboard3;
  late List<Dashboard3> listUnitEntry,
      listJasa,
      listOli,
      listSparepart,
      listRetail,
      listIncome,
      listSPU;
  late String tgl, bln, thn;
  late int totalDay;
  late List<int> listInt;
  late Report report;

  @override
  void initState() {
    setAwal(Provider.of<MenuState>(context, listen: false));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future setAwal(MenuState state) async {
    setState(() => loading = true);

    listDashboard3 = [];
    listUnitEntry = [];
    listJasa = [];
    listOli = [];
    listSparepart = [];
    listRetail = [];
    listIncome = [];
    listSPU = [];
    reset(state);
    await getListApi(state);

    setState(() => loading = false);
  }

  void reset(MenuState state) {
    report = Report.unitEntry;
    thn = state.getFpmDateFilter.substring(0, 4);
    bln = state.getFpmDateFilter.substring(5, 7);
    tgl = state.getFpmDateFilter.substring(8, 10);
    totalDay = DateTime(int.parse(thn), int.parse(bln) + 1, 0)
        .day; //Ambil tanggal mundur dari bulan selanjutnya
    listInt = Iterable<int>.generate(totalDay, (i) => i + 1).toList();
  }

  Future getListApi(MenuState state) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      listDashboard3.addAll(
        await SampApi.getDashboard3(
          prefs.getString("UserID")!,
          state.getWorkshopName,
          state.getFpmDateFilter,
        ),
      );

      listDashboard3.map((e) {
        if (e.jenis == 'UnitEntry') {
          listUnitEntry.add(e);
        } else if (e.jenis == 'Jasa') {
          listJasa.add(e);
        } else if (e.jenis == 'Oli') {
          listOli.add(e);
        } else if (e.jenis == 'Sparepart') {
          listSparepart.add(e);
        } else if (e.jenis == 'Retail') {
          listRetail.add(e);
        } else if (e.jenis == 'Income') {
          listIncome.add(e);
        } else if (e.jenis == 'SPU') {
          listSPU.add(e);
        }
      }).toList();
    } catch (e) {
      error = true;
      txtError = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = Provider.of<MenuState>(context);

    return Scaffold(
      backgroundColor: Colors.blue[50]!.withAlpha(200),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: startUpPage(
        onRefresh: () => setAwal(state),
        child: listDashboard3.isEmpty
            ? Container()
            : Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final hPad = constraints.maxWidth < 600 ? 12.0 : 20.0;
                      final availWidth = constraints.maxWidth - (hPad * 2);

                      return ListView(
                        padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 40),
                        children: [
                          const Center(
                            child: Text(
                              'DAILY REPORT MEKANIK',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Text(
                              listDashboard3[0].bsName,
                              style: const TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Text(
                              'PERIODE ${listBulan[int.parse(bln) - 1]} $thn',
                              style: const TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 20),
                          //MENU (Responsive Wrap)
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              buttonMenu(Report.unitEntry, 'Unit Entry'),
                              buttonMenu(Report.jasa, 'Jasa'),
                              buttonMenu(Report.oli, 'Oli'),
                              buttonMenu(Report.spareparts, 'Spareparts'),
                              buttonMenu(Report.retail, 'Retail'),
                              buttonMenu(Report.income, 'Income Service'),
                              buttonMenu(Report.spu, 'SPU'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          report == Report.unitEntry
                              ? contentMenu(listUnitEntry,
                                  rutUnitEntry(listUnitEntry), availWidth)
                              : report == Report.jasa
                                  ? contentMenu(
                                      listJasa, rutJasa(listJasa), availWidth)
                                  : report == Report.oli
                                      ? contentMenu(
                                          listOli, rutOli(listOli), availWidth)
                                      : report == Report.spareparts
                                          ? contentMenu(
                                              listSparepart,
                                              rutSparepart(listSparepart),
                                              availWidth)
                                          : report == Report.retail
                                              ? contentMenu(
                                                  listRetail,
                                                  rutRetail(listRetail),
                                                  availWidth)
                                              : report == Report.income
                                                  ? contentMenu(
                                                      listIncome,
                                                      rutIncome(listIncome),
                                                      availWidth)
                                                  : contentMenu(
                                                      listSPU,
                                                      rutSPU(listSPU),
                                                      availWidth)
                        ],
                      );
                    },
                  ),
                  //*FOOTER
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      color: Colors.white.withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('\u00a9 ', style: TextStyle(fontSize: 10)),
                          Text(
                            ' 2025 IT Basra Corporation',
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ),
                  ),
                  //*TANGGAL
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      color: Colors.white.withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Format.tanggalFormat(
                              DateTime.now().toString().substring(0, 10),
                            ),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget buttonMenu(Report value, String name) {
    return IntrinsicHeight(
      child: FittedBox(
        child: ElevatedButton(
          onPressed: () => setState(() => report = value),
          style: ElevatedButton.styleFrom(
            backgroundColor: report == value ? Colors.indigo : Colors.blue[50],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: const BorderSide(color: Colors.indigo),
          ),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: report == value ? Colors.white : Colors.indigo,
            ),
          ),
        ),
      ),
    );
  }

  Widget contentMenu(
      List<Dashboard3> listData, TableRow rutTable, double availWidth) {
    final minTableWidth =
        math.max(availWidth, (listData.length + 2) * 115.0);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: minTableWidth,
        child: SelectionArea(
          child: Table(
            border: TableBorder.all(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: const FlexColumnWidth(1.2),
              ...{
                for (var k in listData)
                  listData.indexOf(k) + 1: const FlexColumnWidth(2)
              },
              listData.length + 1: const FlexColumnWidth(2),
            },
            children: [
              //HEADER
              TableRow(
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                children: [
                  headerTable('Hari / Tgl'),
                  for (Dashboard3 k in listData) headerTable((k.eName)),
                  headerTable('Total'),
                ],
              ),
              //BODY
              for (var i = 0; i < totalDay; i++)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 4,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Dashboard.toJson(listDashboard3[0])['h${i + 1}']
                                  .toString()
                                  .substring(0, 3),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              ' ${i + 1}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    for (Dashboard3 data in listData)
                      containerTable(
                        int.parse(Dashboard.toJson(data)['h${i + 1}']) == 0 &&
                                DateTime(int.parse(thn), int.parse(bln), i + 1)
                                    .isAfter(DateTime.now())
                            ? ''
                            : Dashboard.toJson(data)['h${i + 1}'],
                        warna: Dashboard.toJson(listDashboard3[0])['h${i + 1}'] ==
                                'Minggu'
                            ? Colors.red.shade300
                            : Colors.white,
                      ),
                    containerTable(
                      sumList(listData, i),
                      warna: Dashboard.toJson(listDashboard3[0])['h${i + 1}'] ==
                              'Minggu'
                          ? Colors.red.shade300
                          : Colors.green.shade300,
                    ),
                  ],
                ),
              //HASIL
              report == Report.spu
                  ? TableRow(
                      decoration: BoxDecoration(color: Colors.orange.shade300),
                      children: [
                        textTable('Hasil'),
                        for (Dashboard3 data in listData)
                          containerTable((int.parse(sumModel(
                                      listIncome.firstWhere(
                                          (element) => element.eName == data.eName),
                                      totalDay)) ~/
                                  int.parse(sumModel(
                                      listUnitEntry.firstWhere(
                                          (element) => element.eName == data.eName),
                                      totalDay)))
                              .toString()),
                        containerTable(sumTotalSPU(
                            listData, totalDay, listIncome, listUnitEntry)),
                      ],
                    )
                  : TableRow(
                      decoration: BoxDecoration(color: Colors.orange.shade300),
                      children: [
                        textTable('Hasil'),
                        for (Dashboard3 data in listData)
                          containerTable(sumModel(data, totalDay)),
                        containerTable(sumTotalList(listData, totalDay)),
                      ],
                    ),
              //TARGET
              TableRow(
                decoration: BoxDecoration(color: Colors.orange.shade300),
                children: [
                  textTable('Target'),
                  for (Dashboard3 data in listData)
                    containerTable(data.targetMekanik),
                  containerTable(sumTarget(listData)),
                ],
              ),
              //%
              report == Report.spu
                  ? TableRow(
                      decoration: BoxDecoration(color: Colors.orange.shade300),
                      children: [
                        textTable('%'),
                        for (Dashboard3 data in listData)
                          containerTable(
                              '${(int.parse(sumModel(listIncome.firstWhere((element) => element.eName == data.eName), totalDay)) ~/ int.parse(sumModel(listUnitEntry.firstWhere((element) => element.eName == data.eName), totalDay)) * 100 ~/ int.parse(data.targetMekanik))}',
                              percentFormat: true),
                        containerTable(
                            '${(int.parse(sumTotalSPU(listData, totalDay, listIncome, listUnitEntry)) * 100 ~/ int.parse(sumTarget(listData)))}',
                            percentFormat: true),
                      ],
                    )
                  : TableRow(
                      decoration: BoxDecoration(color: Colors.orange.shade300),
                      children: [
                        textTable('%'),
                        for (Dashboard3 data in listData)
                          containerTable(
                              '${(int.parse(sumModel(data, totalDay)) * 100 ~/ int.parse(data.targetMekanik))}',
                              percentFormat: true),
                        containerTable(
                            '${(int.parse(sumTotalList(listData, totalDay)) * 100 ~/ int.parse(sumTarget(listData)))}',
                            percentFormat: true),
                      ],
                    ),
              //GAB
              report == Report.spu
                  ? TableRow(
                      decoration: BoxDecoration(color: Colors.orange.shade300),
                      children: [
                        textTable('Gab'),
                        for (Dashboard3 data in listData)
                          containerTable(
                              '${(int.parse(sumModel(listIncome.firstWhere((element) => element.eName == data.eName), totalDay)) ~/ int.parse(sumModel(listUnitEntry.firstWhere((element) => element.eName == data.eName), totalDay))) - int.parse(data.targetMekanik)}'),
                        containerTable(
                            '${int.parse(sumTotalSPU(listData, totalDay, listIncome, listUnitEntry)) - int.parse(sumTarget(listData))}'),
                      ],
                    )
                  : TableRow(
                      decoration: BoxDecoration(color: Colors.orange.shade300),
                      children: [
                        textTable('Gab'),
                        for (Dashboard3 data in listData)
                          containerTable(
                              '${int.parse(sumModel(data, totalDay)) - int.parse(data.targetMekanik)}'),
                        containerTable(
                            '${int.parse(sumTotalList(listData, totalDay)) - int.parse(sumTarget(listData))}'),
                      ],
                    ),
              //RUT
              rutTable,
            ],
          ),
        ),
      ),
    );
  }

  TableRow rutUnitEntry(List<Dashboard3> listData) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      children: [
        textTable('Rut Unit'),
        for (Dashboard3 data in listData)
          containerTable(averageModel(data, totalDay)),
        containerTable(averageTotalList(listData, totalDay)),
      ],
    );
  }

  TableRow rutJasa(List<Dashboard3> listData) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      children: [
        textTable('Spu Jasa'),
        for (Dashboard3 data in listData)
          containerTable((int.parse(sumModel(data, totalDay)) ~/
                  int.parse(sumModel(
                      listUnitEntry.firstWhere(
                          (element) => element.eName == data.eName),
                      totalDay)))
              .toString()),
        containerTable(averageRUT(listData, totalDay, listUnitEntry)),
      ],
    );
  }

  TableRow rutOli(List<Dashboard3> listData) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      children: [
        textTable('Spu Oli'),
        for (Dashboard3 data in listData)
          containerTable((int.parse(sumModel(data, totalDay)) ~/
                  int.parse(sumModel(
                      listUnitEntry.firstWhere(
                          (element) => element.eName == data.eName),
                      totalDay)))
              .toString()),
        containerTable(averageRUT(listData, totalDay, listUnitEntry)),
      ],
    );
  }

  TableRow rutSparepart(List<Dashboard3> listData) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      children: [
        textTable('Spu Parts'),
        for (Dashboard3 data in listData)
          containerTable((int.parse(sumModel(data, totalDay)) ~/
                  int.parse(sumModel(
                      listUnitEntry.firstWhere(
                          (element) => element.eName == data.eName),
                      totalDay)))
              .toString()),
        containerTable(averageRUT(listData, totalDay, listUnitEntry)),
      ],
    );
  }

  TableRow rutRetail(List<Dashboard3> listData) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      children: [
        textTable('Average'),
        for (Dashboard3 data in listData)
          containerTable(averageModel(data, totalDay).split('.')[0]),
        containerTable(sumRUT(listData, totalDay)),
      ],
    );
  }

  TableRow rutIncome(List<Dashboard3> listData) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      children: [
        textTable('Average'),
        for (Dashboard3 data in listData)
          containerTable(averageModel(data, totalDay).split('.')[0]),
        containerTable(sumRUT(listData, totalDay)),
      ],
    );
  }

  TableRow rutSPU(List<Dashboard3> listData) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      children: [
        textTable('Average'),
        for (Dashboard3 data in listData)
          containerTable(averageModel(data, totalDay).split('.')[0]),
        containerTable(sumRUT(listData, totalDay)),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
