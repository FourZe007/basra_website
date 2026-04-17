import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/models/dashboard.dart';
import 'package:stsj/dashboard-fixup/models/dashboard4_model.dart';
import 'package:stsj/dashboard-fixup/services/api.dart';
import 'package:stsj/dashboard-fixup/utilities/basepage.dart';
import 'package:stsj/dashboard-fixup/utilities/utils.dart';
import 'package:stsj/dashboard-fixup/widgets/container_table.dart';
import 'package:stsj/dashboard-fixup/widgets/header_table.dart';
import 'package:stsj/dashboard-fixup/widgets/text_table.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class Dashboard4Page extends StatefulWidget {
  const Dashboard4Page({
    super.key,
  });

  @override
  State<Dashboard4Page> createState() => _Dashboard4PageState();
}

class _Dashboard4PageState extends State<Dashboard4Page> with BasePage, AutomaticKeepAliveClientMixin<Dashboard4Page> {
  late List<Dashboard4> listDashboard4;
  late String tgl, bln, thn;
  late int totalDay;
  late List<int> listInt;

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

    listDashboard4 = [];
    reset(state);
    await getListApi(state);

    setState(() => loading = false);
  }

  void reset(MenuState state) {
    thn = state.getFpmDateFilter.substring(0, 4);
    bln = state.getFpmDateFilter.substring(5, 7);
    tgl = state.getFpmDateFilter.substring(8, 10);
    totalDay = DateTime(int.parse(thn), int.parse(bln) + 1, 0).day; //Ambil tanggal mundur dari bulan selanjutnya
    listInt = Iterable<int>.generate(totalDay, (i) => i + 1).toList();
  }

  Future getListApi(MenuState state) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      listDashboard4.addAll(
        await SampApi.getDashboard4(
          prefs.getString("UserID")!,
          state.getWorkshopName,
          state.getFpmDateFilter,
        ),
      );
      //JAGA2 LIST API BERUBAH
      if (listDashboard4.length < 21) {
        throw ('DASHBOARDFUMONTHLY TIDAK LENGKAP');
      }
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
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: startUpPage(
        onRefresh: () => setAwal(state),
        child: listDashboard4.isEmpty
            ? Container()
            : Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Center(child: Text('MONTHLY REPORT BENGKEL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      Center(child: Text(listDashboard4[0].bsName, style: const TextStyle(fontSize: 15))),
                      Center(child: Text('PERIODE ${listBulan[int.parse(bln) - 1]} $thn', style: const TextStyle(fontSize: 15))),
                      const SizedBox(height: 15),
                      SelectionArea(
                        child: Table(
                          border: TableBorder.all(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(1.3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(1),
                            7: FlexColumnWidth(1),
                            8: FlexColumnWidth(1),
                            9: FlexColumnWidth(1),
                            10: FlexColumnWidth(1),
                            11: FlexColumnWidth(1),
                            12: FlexColumnWidth(1),
                          },
                          children: [
                            //JUDUL
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              children: [
                                headerTable(''),
                                for (var i = 0; i < 12; i++)
                                  Column(
                                    children: [
                                      Text(
                                        Dashboard.toJson(listDashboard4[0])['h${i + 1}'].toString().split('-')[0],
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Text(
                                        listBulan[int.parse(Dashboard.toJson(listDashboard4[0])['h${i + 1}'].toString().split('-')[1]) - 1],
                                        style: const TextStyle(fontSize: 13, color: Colors.white),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            //1:SA  2:SC  3:MEKANIK
                            for (var j = 1; j < 4; j++)
                              TableRow(
                                children: [
                                  textTable(listDashboard4[j].rowName),
                                  for (var i = 0; i < 12; i++)
                                    containerTable(
                                      Dashboard.toJson(listDashboard4[j])['h${i + 1}'],
                                    )
                                ],
                              ),
                          ],
                        ),
                      ),
                      const Text(' Unit Entry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SelectionArea(
                        child: Table(
                          border: TableBorder.all(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(1.3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(1),
                            7: FlexColumnWidth(1),
                            8: FlexColumnWidth(1),
                            9: FlexColumnWidth(1),
                            10: FlexColumnWidth(1),
                            11: FlexColumnWidth(1),
                            12: FlexColumnWidth(1),
                          },
                          children: [
                            //4:HONDA  5:YAMAHA  6:SUZUKI  7:KAWASAKI  8:VESPA  9:OTHERS
                            for (var j = 4; j < 10; j++)
                              TableRow(
                                children: [
                                  textTable(listDashboard4[j].rowName),
                                  for (var i = 0; i < 12; i++) containerTable(Dashboard.toJson(listDashboard4[j])['h${i + 1}'])
                                ],
                              ),
                            //TOTAL
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade300,
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                              ),
                              children: [
                                textTable('Total'),
                                for (var i = 0; i < 12; i++)
                                  containerTable(
                                    sumList([
                                      listDashboard4[4],
                                      listDashboard4[5],
                                      listDashboard4[6],
                                      listDashboard4[7],
                                      listDashboard4[8],
                                      listDashboard4[9]
                                    ], i),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Text(' Income Bengkel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SelectionArea(
                        child: Table(
                          border: TableBorder.all(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(1.3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(1),
                            7: FlexColumnWidth(1),
                            8: FlexColumnWidth(1),
                            9: FlexColumnWidth(1),
                            10: FlexColumnWidth(1),
                            11: FlexColumnWidth(1),
                            12: FlexColumnWidth(1),
                          },
                          children: [
                            //10:HONDA  11:YAMAHA  12:SUZUKI
                            for (var j = 10; j < 13; j++)
                              TableRow(
                                children: [
                                  textTable(listDashboard4[j].rowName),
                                  for (var i = 0; i < 12; i++) containerTable(Dashboard.toJson(listDashboard4[j])['h${i + 1}'])
                                ],
                              ),
                            //TOTAL
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade300,
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                              ),
                              children: [
                                textTable('Total'),
                                for (var i = 0; i < 12; i++)
                                  containerTable(
                                    sumList([listDashboard4[10], listDashboard4[11], listDashboard4[12]], i),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Text(' Retail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SelectionArea(
                        child: Table(
                          border: TableBorder.all(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(1.3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(1),
                            7: FlexColumnWidth(1),
                            8: FlexColumnWidth(1),
                            9: FlexColumnWidth(1),
                            10: FlexColumnWidth(1),
                            11: FlexColumnWidth(1),
                            12: FlexColumnWidth(1),
                          },
                          children: [
                            //13:OLI  14:SPAREPARTS
                            for (var j = 13; j < 15; j++)
                              TableRow(
                                children: [
                                  textTable(listDashboard4[j].rowName),
                                  for (var i = 0; i < 12; i++) containerTable(Dashboard.toJson(listDashboard4[j])['h${i + 1}'])
                                ],
                              ),
                            //TOTAL
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade300,
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                              ),
                              children: [
                                textTable('Total'),
                                for (var i = 0; i < 12; i++)
                                  containerTable(
                                    sumList([listDashboard4[13], listDashboard4[14]], i),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Text(' Total Income', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SelectionArea(
                        child: Table(
                          border: TableBorder.all(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(1.3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(1),
                            7: FlexColumnWidth(1),
                            8: FlexColumnWidth(1),
                            9: FlexColumnWidth(1),
                            10: FlexColumnWidth(1),
                            11: FlexColumnWidth(1),
                            12: FlexColumnWidth(1),
                          },
                          children: [
                            //TOTAL
                            TableRow(
                              decoration: BoxDecoration(color: Colors.orange.shade300, borderRadius: BorderRadius.circular(10)),
                              children: [
                                textTable('Total'),
                                for (var i = 0; i < 12; i++)
                                  containerTable(
                                    (int.parse(sumList([listDashboard4[10], listDashboard4[11], listDashboard4[12]], i)) +
                                            int.parse(sumList([listDashboard4[13], listDashboard4[14]], i)))
                                        .toString(),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Text(' SPU', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SelectionArea(
                        child: Table(
                          border: TableBorder.all(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(1.3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(1),
                            7: FlexColumnWidth(1),
                            8: FlexColumnWidth(1),
                            9: FlexColumnWidth(1),
                            10: FlexColumnWidth(1),
                            11: FlexColumnWidth(1),
                            12: FlexColumnWidth(1),
                          },
                          children: [
                            //TOTAL
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade300,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              children: [
                                textTable('Total'),
                                for (var i = 0; i < 12; i++)
                                  containerTable(((int.parse(sumList([
                                                listDashboard4[10],
                                                listDashboard4[11],
                                                listDashboard4[12],
                                              ], i)) +
                                              int.parse(sumList([
                                                listDashboard4[13],
                                                listDashboard4[14],
                                              ], i))) ~/
                                          int.parse(sumList([
                                            listDashboard4[4],
                                            listDashboard4[5],
                                            listDashboard4[6],
                                            listDashboard4[7],
                                            listDashboard4[8],
                                            listDashboard4[9]
                                          ], i)))
                                      .toString()),
                              ],
                            ),
                            //15:JASA  16:OLI  17:PARTS
                            for (var j = 15; j < 18; j++)
                              TableRow(
                                children: [
                                  textTable(listDashboard4[j].rowName),
                                  for (var i = 0; i < 12; i++) containerTable(Dashboard.toJson(listDashboard4[j])['h${i + 1}'])
                                ],
                              ),
                          ],
                        ),
                      ),
                      const Text(' IPM', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SelectionArea(
                        child: Table(
                          border: TableBorder.all(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(1.3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(1),
                            7: FlexColumnWidth(1),
                            8: FlexColumnWidth(1),
                            9: FlexColumnWidth(1),
                            10: FlexColumnWidth(1),
                            11: FlexColumnWidth(1),
                            12: FlexColumnWidth(1),
                          },
                          children: [
                            //TOTAL
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade300,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              children: [
                                textTable('Total'),
                                for (var i = 0; i < 12; i++)
                                  containerTable(int.parse(Dashboard.toJson(listDashboard4[3])['h${i + 1}']) == 0
                                      ? '-'
                                      : ((int.parse(sumList([
                                                    listDashboard4[10],
                                                    listDashboard4[11],
                                                    listDashboard4[12],
                                                  ], i)) +
                                                  int.parse(sumList([
                                                    listDashboard4[13],
                                                    listDashboard4[14],
                                                  ], i))) ~/
                                              int.parse(Dashboard.toJson(listDashboard4[3])['h${i + 1}']))
                                          .toString()),
                              ],
                            ),
                            //18:JASA  19:OLI  20:PARTS
                            for (var j = 18; j < 21; j++)
                              TableRow(
                                children: [
                                  textTable(listDashboard4[j].rowName),
                                  for (var i = 0; i < 12; i++) containerTable(Dashboard.toJson(listDashboard4[j])['h${i + 1}'])
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
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
                          Text(' 2025 IT Basra Corporation', style: TextStyle(fontSize: 10))
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
                          Text(Format.tanggalFormat(DateTime.now().toString().substring(0, 10)), style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
