import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/models/dashboard.dart';
import 'package:stsj/dashboard-fixup/models/dashboard2_model.dart';
import 'package:stsj/dashboard-fixup/services/api.dart';
import 'package:stsj/dashboard-fixup/utilities/basepage.dart';
import 'package:stsj/dashboard-fixup/utilities/utils.dart';
import 'package:stsj/dashboard-fixup/widgets/container_table.dart';
import 'package:stsj/dashboard-fixup/widgets/header_table.dart';
import 'package:stsj/dashboard-fixup/widgets/text_table.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class Dashboard2Page extends StatefulWidget {
  const Dashboard2Page({
    super.key,
  });

  @override
  State<Dashboard2Page> createState() => _Dashboard2PageState();
}

class _Dashboard2PageState extends State<Dashboard2Page> with BasePage, AutomaticKeepAliveClientMixin<Dashboard2Page> {
  late List<Dashboard2> listDashboard2;
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

    listDashboard2 = [];
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
      listDashboard2.addAll(await SampApi.getDashboard2(
        prefs.getString("UserID")!,
        state.getWorkshopName,
        state.getFpmDateFilter,
      ));
      //JAGA2 LIST API BERUBAH
      if (listDashboard2.length < 12) {
        throw ('DASHBOARDFUDAILY TIDAK LENGKAP');
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
        child: listDashboard2.isEmpty
            ? Container()
            : Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Center(
                        child: Text(
                          'DAILY REPORT BENGKEL',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          listDashboard2[0].bsName,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      Center(
                        child: Text(
                          'PERIODE ${listBulan[int.parse(bln) - 1]} $thn',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SelectionArea(
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: const FlexColumnWidth(2.7),
                            ...{for (var k in listInt) k: const FlexColumnWidth(1)},
                            // ...Map.fromIterable(
                            //   listInt,
                            //   key: (k) => k,
                            //   value: (v) => FlexColumnWidth(1),
                            // )
                            totalDay + 1: const FlexColumnWidth(1.3)
                          },
                          children: [
                            //JUDUL
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              children: [
                                headerTable(''),
                                for (var i = 0; i < totalDay; i++)
                                  Column(
                                    children: [
                                      Text(
                                        Dashboard.toJson(listDashboard2[0])['h${i + 1}'].toString().substring(0, 3),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        (i + 1).toString(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                headerTable('∑'),
                              ],
                            ),
                            //TIDAK FOR UNTUK KONTROL BORDER RADIUS
                            //SA
                            TableRow(
                              children: [
                                textTable(listDashboard2[1].rowName),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    Dashboard.toJson(listDashboard2[1])['h${i + 1}'],
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(
                                  sumModel(listDashboard2[1], totalDay),
                                  warna: Colors.green.shade300,
                                )
                              ],
                            ),
                            //Mekanik
                            TableRow(
                              children: [
                                textTable(listDashboard2[2].rowName),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    Dashboard.toJson(listDashboard2[2])['h${i + 1}'],
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(sumModel(listDashboard2[2], totalDay), warna: Colors.green.shade300)
                              ],
                            ),
                            //HariKerja
                            TableRow(
                              children: [
                                textTable(listDashboard2[3].rowName),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    Dashboard.toJson(listDashboard2[3])['h${i + 1}'],
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(
                                  sumModel(listDashboard2[3], totalDay),
                                  warna: Colors.green.shade300,
                                )
                              ],
                            ),
                            //Target UE
                            TableRow(
                              children: [
                                textTable(listDashboard2[4].rowName),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    Dashboard.toJson(listDashboard2[4])['h${i + 1}'],
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(
                                  sumModel(listDashboard2[4], totalDay),
                                  warna: Colors.green.shade300,
                                )
                              ],
                            ),
                            //RUT
                            TableRow(
                              children: [
                                textTable(listDashboard2[5].rowName),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    Dashboard.toJson(listDashboard2[5])['h${i + 1}'],
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(averageModel(listDashboard2[5], totalDay), warna: Colors.green.shade300, lastIdx: true)
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        ' Unit Entry',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SelectionArea(
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: const FlexColumnWidth(2.7),
                            ...{for (var k in listInt) k: const FlexColumnWidth(1)},
                            totalDay + 1: const FlexColumnWidth(1.3)
                          },
                          children: [
                            //Honda
                            TableRow(
                              children: [
                                textTable(listDashboard2[6].rowName),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    int.parse(Dashboard.toJson(listDashboard2[6])['h${i + 1}']) == 0 &&
                                            DateTime(int.parse(thn), int.parse(bln), i + 1).isAfter(
                                              DateTime.now(),
                                            )
                                        ? ''
                                        : Dashboard.toJson(listDashboard2[6])['h${i + 1}'],
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(
                                  sumModel(listDashboard2[6], totalDay),
                                  warna: Colors.green.shade300,
                                  firstIdx: true,
                                )
                              ],
                            ),
                            //Yamaha
                            TableRow(
                              children: [
                                textTable(listDashboard2[7].rowName),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    int.parse(Dashboard.toJson(listDashboard2[7])['h${i + 1}']) == 0 &&
                                            DateTime(int.parse(thn), int.parse(bln), i + 1).isAfter(
                                              DateTime.now(),
                                            )
                                        ? ''
                                        : Dashboard.toJson(listDashboard2[7])['h${i + 1}'],
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(
                                  sumModel(listDashboard2[7], totalDay),
                                  warna: Colors.green.shade300,
                                )
                              ],
                            ),
                            //Suzuki
                            TableRow(
                              children: [
                                textTable(listDashboard2[8].rowName),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    int.parse(Dashboard.toJson(listDashboard2[8])['h${i + 1}']) == 0 &&
                                            DateTime(int.parse(thn), int.parse(bln), i + 1).isAfter(
                                              DateTime.now(),
                                            )
                                        ? ''
                                        : Dashboard.toJson(listDashboard2[8])['h${i + 1}'],
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(
                                  sumModel(listDashboard2[8], totalDay),
                                  warna: Colors.green.shade300,
                                )
                              ],
                            ),
                            //Kawazaki
                            TableRow(
                              children: [
                                textTable(listDashboard2[9].rowName),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    int.parse(Dashboard.toJson(listDashboard2[9])['h${i + 1}']) == 0 &&
                                            DateTime(int.parse(thn), int.parse(bln), i + 1).isAfter(
                                              DateTime.now(),
                                            )
                                        ? ''
                                        : Dashboard.toJson(listDashboard2[9])['h${i + 1}'],
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(
                                  sumModel(listDashboard2[9], totalDay),
                                  warna: Colors.green.shade300,
                                )
                              ],
                            ),
                            //Vespa
                            TableRow(
                              children: [
                                textTable(listDashboard2[10].rowName),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    int.parse(Dashboard.toJson(listDashboard2[10])['h${i + 1}']) == 0 &&
                                            DateTime(int.parse(thn), int.parse(bln), i + 1).isAfter(
                                              DateTime.now(),
                                            )
                                        ? ''
                                        : Dashboard.toJson(listDashboard2[10])['h${i + 1}'],
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(
                                  sumModel(listDashboard2[10], totalDay),
                                  warna: Colors.green.shade300,
                                )
                              ],
                            ),
                            //Other
                            TableRow(
                              children: [
                                textTable(listDashboard2[11].rowName),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    int.parse(Dashboard.toJson(listDashboard2[11])['h${i + 1}']) == 0 &&
                                            DateTime(int.parse(thn), int.parse(bln), i + 1).isAfter(
                                              DateTime.now(),
                                            )
                                        ? ''
                                        : Dashboard.toJson(listDashboard2[11])['h${i + 1}'],
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(
                                  sumModel(listDashboard2[11], totalDay),
                                  warna: Colors.green.shade300,
                                )
                              ],
                            ),
                            //Total
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade300,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              children: [
                                textTable('UE Total'),
                                for (var i = 0; i < totalDay; i++)
                                  containerTable(
                                    sumList([
                                      listDashboard2[6],
                                      listDashboard2[7],
                                      listDashboard2[8],
                                      listDashboard2[9],
                                      listDashboard2[10],
                                      listDashboard2[11]
                                    ], i),
                                    warna: Dashboard.toJson(listDashboard2[0])['h${i + 1}'] == 'Minggu' ? Colors.red.shade300 : Colors.transparent,
                                  ),
                                containerTable(
                                  sumTotalList([
                                    listDashboard2[6],
                                    listDashboard2[7],
                                    listDashboard2[8],
                                    listDashboard2[9],
                                    listDashboard2[10],
                                    listDashboard2[11]
                                  ], totalDay),
                                  warna: Colors.green.shade300,
                                  lastIdx: true,
                                )
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

  @override
  bool get wantKeepAlive => true;
}
