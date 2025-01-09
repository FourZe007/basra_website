import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/models/Dashboard/picking_packing.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/core/views/otorisasi/component/StyleService.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/autocomplete/pic.dart';
import 'package:stsj/global/widget/dropdown/sis_branch_shop_dropdown.dart';
import 'package:stsj/global/widget/gridtable/picking_packing_data_source.dart';
import 'package:stsj/router/router_const.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PackingPage extends StatefulWidget {
  const PackingPage({super.key});

  @override
  State<PackingPage> createState() => _PackingPageState();
}

class _PackingPageState extends State<PackingPage> {
  String date = '';
  String pic = '';

  String get getPic => pic;

  void setDate(String value) {
    setState(() {
      date = value;
    });
    Provider.of<MenuState>(context, listen: false).searchTriggerNotifier.value =
        false;
  }

  void setPIC(String value) {
    pic = value;
    Provider.of<MenuState>(context, listen: false).searchTriggerNotifier.value =
        false;
  }

  Future<void> setDateByGoogle(
    BuildContext context,
    String tgl,
  ) async {
    tgl = tgl == '' ? DateTime.now().toString().substring(0, 10) : tgl;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == '' ? DateTime.now() : DateTime.parse(tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1, 1, 0),
    );

    if (picked != null && picked != DateTime.parse(tgl)) {
      tgl = picked.toString().substring(0, 10);
      setDate(tgl);
    } else {
      // Nothing happened
    }
  }

  void search(MenuState state) {
    if (date == '') {
      setDate(
        DateTime.now().toString().substring(0, 10),
      );
    }

    state.setSearchTriggerNotifier(false);
    print('Branch: ${state.getSelectedBranch}');
    // branch = state.getSelectedBranch;
    // print('Shop: ${state.getSelectedShop}');
    // shop = state.getSelectedShop;
    print('Date: $date');
    state.setSearchTriggerNotifier(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<MenuState>(context, listen: false).setPpBranchName('');
    Provider.of<MenuState>(context, listen: false).loadSisBranches();
    Provider.of<MenuState>(context, listen: false)
        .setSearchTriggerNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.065,
        ),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.01,
          right: MediaQuery.of(context).size.width * 0.01,
          top: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Column(
          children: [
            // ==================================================================
            // =========================== Filter ===============================
            // ==================================================================
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Filter Title
                  InkWell(
                    onTap: null,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.filter_alt_rounded,
                            size: 25.0,
                            color: Colors.black,
                          ),
                          Text(
                            'Filter',
                            style: GlobalFont.mediumgiantfontR,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 10.0),

                  // Filter Content
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // ~:Branch Shop Name:~
                          Consumer<MenuState>(
                            builder: (context, value, _) {
                              if (value.getBranchNameList.isEmpty) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.01,
                                  ),
                                  child: SisBranchShopDropdown(
                                    listData: const [],
                                    inputan: '',
                                    hint: 'Cabang',
                                    handle: () {},
                                    disable: true,
                                  ),
                                );
                              } else {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.01,
                                  ),
                                  child: SisBranchShopDropdown(
                                    listData: value.getBranchNameList,
                                    inputan: state.ppBranchName,
                                    hint: 'Cabang',
                                    handle: state.setPpBranchName,
                                    disable: false,
                                  ),
                                );
                              }
                            },
                          ),

                          // ~:Devider:~
                          SizedBox(width: 10.0),

                          // ~:PIC Autocomplete:~
                          PicAutoComplete(pic, setPIC),

                          // ~:Devider:~
                          SizedBox(width: 10.0),

                          // ~:Date:~
                          InkWell(
                            onTap: () async => await setDateByGoogle(
                              context,
                              date,
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.date_range_rounded),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.003,
                                  ),
                                  Text(
                                    date == ''
                                        ? Format.tanggalFormat(
                                            DateTime.now()
                                                .toString()
                                                .substring(0, 10),
                                          )
                                        : Format.tanggalFormat(date),
                                    style: GlobalFont.mediumgiantfontR,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ~:Devider:~
                          SizedBox(width: 10.0),

                          // ~:Search Button:~
                          InkWell(
                            onTap: () => search(state),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: const Icon(
                                Icons.search_rounded,
                                size: 25.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =================================================================
            // ========================== Devider ==============================
            // =================================================================
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),

            // =================================================================
            // ========================== Content ==============================
            // =================================================================
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: state.getSearchTriggerNotifier,
                builder: (context, value, _) {
                  print('Search Trigger: $value');
                  if (!value) {
                    return Center(
                      child: Text('Data tidak tersedia.'),
                    );
                  } else {
                    return FutureBuilder(
                      future: state.fetchPackingData(
                        date,
                        pic, // still unavailable, UI need to be created
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.black,
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Loading...',
                                style: GlobalFont.bigfontR,
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Terjadi kesalahan.'),
                          );
                        } else if (!snapshot.hasData) {
                          return Center(
                            child: Text('Data tidak tersedia.'),
                          );
                        } else {
                          final status = snapshot.data!['status'];

                          if (status == 'failed') {
                            return Center(child: Text('Data tidak ditemukan.'));
                          } else if (status == 'not found' ||
                              status == 'error') {
                            return Center(
                              child:
                                  Text('terjadi kesalahan, mohon coba lagi.'),
                            );
                          } else {
                            final PickPackModel data =
                                snapshot.data!['data'][0];

                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.8,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 30,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ~:Picking Data:~
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 7.5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ~:PIC Information:~
                                        Container(
                                          height: 60,
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Wrap(
                                            spacing: 5,
                                            direction: Axis.vertical,
                                            children: [
                                              Text(
                                                getPic,
                                                style: GlobalFont.bigfontR,
                                              ),
                                              Text(
                                                'Mulai ${data.time.replaceAll(RegExp(r':'), '.')}',
                                                style: GlobalFont.bigfontR,
                                              ),
                                            ],
                                          ),
                                        ),

                                        // ~:Picking Table:~
                                        SizedBox(
                                          width: 400,
                                          child: Table(
                                            border: TableBorder.all(
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TableRow(
                                                children: const [
                                                  Text(''),
                                                  Text(
                                                    'Total',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    'On Going',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  Text(
                                                    'DU',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    data.tdu.toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    data.onGoingDU.toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  Text(
                                                    'Line',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    data.tLine.toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    data.onGoingLine.toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  Text(
                                                    'Total Leadtime',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    data.tLeadTime.toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    '',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  Text(
                                                    'Avg Leadtime',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    data.avgLeadTime.toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    '',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  Text(
                                                    'Total Jeda Waktu',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    data.avgDiff.toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    '',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  Text(
                                                    'Jeda Waktu',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    data.diff.toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    '',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  Text(
                                                    'Amount Picking',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    StyleService.convertToIdr(
                                                      data.tAmount,
                                                      0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    data.onGoingAmount
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // ~:Picking Details:~
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 7.5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 70,
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              'Details',
                                              style:
                                                  GlobalFont.mediumgiantfontR,
                                            ),
                                          ),
                                          FutureBuilder(
                                            future: state.fetchPackingDetails(
                                              date,
                                              pic,
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(
                                                    children: [
                                                      CircularProgressIndicator(
                                                          color: Colors.black),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'Loading...',
                                                        style:
                                                            GlobalFont.bigfontR,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                    'terjadi kesalahan, mohon coba lagi.',
                                                  ),
                                                );
                                              } else if (!snapshot.hasData) {
                                                return Center(
                                                  child: Text(
                                                    'Data tidak ditemukan',
                                                  ),
                                                );
                                              } else {
                                                final List<PickPackDetailsModel>
                                                    picking =
                                                    snapshot.data!['data'];
                                                final String status =
                                                    snapshot.data!['status'];

                                                if (status == 'failed') {
                                                  return Center(
                                                    child: Text(
                                                      'Gagal memuat data.',
                                                    ),
                                                  );
                                                } else if (status ==
                                                        'not found' ||
                                                    status == 'error') {
                                                  return Center(
                                                    child: Text(
                                                      'terjadi kesalahan, mohon coba lagi.',
                                                    ),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.65,
                                                    child: SfDataGrid(
                                                      source: PPDataSource(
                                                          ppData: picking),
                                                      columnWidthMode:
                                                          ColumnWidthMode.fill,
                                                      checkboxShape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      columns: <GridColumn>[
                                                        GridColumn(
                                                          columnName: 'header',
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                          label: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text('No'),
                                                          ),
                                                        ),
                                                        GridColumn(
                                                          columnName:
                                                              'duNumber',
                                                          label: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                Text('No DU'),
                                                          ),
                                                        ),
                                                        GridColumn(
                                                          columnName: 'start',
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.075,
                                                          label: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                Text('Start'),
                                                          ),
                                                        ),
                                                        GridColumn(
                                                          columnName: 'end',
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.075,
                                                          label: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                Text('Finish'),
                                                          ),
                                                        ),
                                                        GridColumn(
                                                          columnName: 'line',
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                          label: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text('Line'),
                                                          ),
                                                        ),
                                                        GridColumn(
                                                          columnName:
                                                              'timeDiff',
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.075,
                                                          label: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                                'Jeda Waktu'),
                                                          ),
                                                        ),
                                                        GridColumn(
                                                          columnName:
                                                              'leadTime',
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          label: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                                'Leadtime'),
                                                          ),
                                                        ),
                                                        GridColumn(
                                                          columnName: 'amt',
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.075,
                                                          label: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                Text('Amount'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
