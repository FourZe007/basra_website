import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/nip_auto_complete.dart';
import 'package:stsj/global/widget/padded_table_cell.dart';
import 'package:stsj/router/router_const.dart';

class SalesActivitiesPage extends StatefulWidget {
  const SalesActivitiesPage({super.key});

  @override
  State<SalesActivitiesPage> createState() => _SalesActivitiesPageState();
}

class _SalesActivitiesPageState extends State<SalesActivitiesPage> {
  String employeeID = '';
  String date = '';
  ValueNotifier<String> employeeIDNotifier = ValueNotifier('');
  ValueNotifier<String> dateNotifier = ValueNotifier('');
  ValueNotifier<List<String>> filterDataNotifier = ValueNotifier([]);

  String get getEmployeeID => employeeID;

  String get getDate => date;

  void setEmployeeID(String value) {
    employeeID = value;
  }

  void setDate(String value) {
    setState(() {
      date = value;
    });
  }

  void setDateByGoogle(
    BuildContext context,
    String tgl,
  ) async {
    tgl = tgl == ''
        ? DateTime.now().subtract(Duration(days: 7)).toString().substring(0, 10)
        : tgl;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == ''
          ? DateTime.now().subtract(Duration(days: 7))
          : DateTime.parse(tgl),
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

  // Delete -> remove later
  // void setEndDateByGoogle(
  //   BuildContext context,
  //   String tgl,
  // ) async {
  //   tgl = tgl == '' ? DateTime.now().toString().substring(0, 10) : tgl;
  //
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: tgl == '' ? DateTime.now() : DateTime.parse(tgl),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2100),
  //   );
  //
  //   if (picked != null && picked != DateTime.parse(tgl)) {
  //     tgl = picked.toString().substring(0, 10);
  //     setEndDate(tgl);
  //   } else {
  //     // Nothing happened
  //   }
  // }

  void previewImage(String value) {
    GlobalFunction.tampilkanDialog(
      context,
      true,
      Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.55,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: PhotoView(
                maxScale: PhotoViewComputedScale.covered * 2,
                minScale: PhotoViewComputedScale.contained,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                imageProvider: MemoryImage(
                  base64Decode(value),
                ),
              ),
            ),
            Text('Press anywhere to dismiss'),
          ],
        ),
      ),
    );
  }

  // Delete -> remove later
  // void openMoreDetails(ModelSalesmanActivities route) {
  //   GlobalFunction.tampilkanDialog(
  //     context,
  //     true,
  //     Container(
  //       width: MediaQuery.of(context).size.width * 0.35,
  //       height: MediaQuery.of(context).size.height * 0.5,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(20.0),
  //       ),
  //       padding: EdgeInsets.symmetric(
  //         horizontal: MediaQuery.of(context).size.width * 0.025,
  //         vertical: MediaQuery.of(context).size.height * 0.025,
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Expanded(child: Text('Jenis Aktivitas: ')),
  //                     Expanded(
  //                       flex: 2,
  //                       child: Text(route.actName),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Expanded(
  //                       child: Text('Deskripsi Aktivitas: '),
  //                     ),
  //                     Expanded(
  //                       flex: 2,
  //                       child: Text(route.actDesc),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Expanded(child: Text('Nama: ')),
  //                     Expanded(
  //                       flex: 2,
  //                       child: Text(route.contactName),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Expanded(child: Text('No Telp: ')),
  //                     Expanded(
  //                       flex: 2,
  //                       child: Text('+62${route.contactNumber}'),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Expanded(child: Text('Timeline: ')),
  //                     Expanded(
  //                       flex: 2,
  //                       child: Text('${route.startTime} - ${route.endTime}'),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Text('Press anywhere to dismiss'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void getFilterData(
    BuildContext context,
    MenuState salesActivitiesState,
  ) {
    setState(() {
      employeeIDNotifier.value = employeeID;

      if (date == '') {
        setDate(
          DateTime.now()
              .subtract(Duration(days: 7))
              .toString()
              .substring(0, 10),
        );
        dateNotifier.value = date;
      } else {
        dateNotifier.value = date;
      }
    });
  }

  void resetData() {
    print('Reset Data');
    setState(() {
      employeeID = '';
      date = '';
      employeeIDNotifier.value = '';
      dateNotifier.value = '';
      filterDataNotifier.value.clear();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('Initiate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    print('Dispose');
    resetData();
  }

  @override
  Widget build(BuildContext context) {
    final salesActivitiesState = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Column(
          children: [
            // ==================================================================
            // =========================== Filter ===============================
            // ==================================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  // Note -> fix this feature later, Unable to expand & shrink
                  // or remove later if it's not being use
                  // onTap: () {
                  //   print('Filter button pressed');
                  //   salesActivitiesState.toggleFilter();
                  // },
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

                // Filter's Expand and Collapse Animation
                AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  reverseDuration: const Duration(milliseconds: 500),
                  curve: salesActivitiesState.isFilterOpen
                      ? Curves.easeInOut
                      : Curves.easeIn,
                  child: SizedBox(
                    width: salesActivitiesState.isFilterOpen
                        ? MediaQuery.of(context).size.width * 0.5
                        : 0.0,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                      children: [
                        // Note -> Old version of Employee ID TextField
                        // new version is using an Autocomplete widget
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.125,
                        //   height: MediaQuery.of(context).size.height * 0.05,
                        //   alignment: Alignment.center,
                        //   decoration: BoxDecoration(
                        //     color: Colors.grey[400],
                        //     borderRadius: BorderRadius.circular(15.0),
                        //   ),
                        //   child: TextField(
                        //     textAlign: TextAlign.center,
                        //     inputFormatters: [
                        //       FilteringTextInputFormatter.allow(
                        //         RegExp(r'[a-zA-Z0-9./@\s]*'),
                        //       ),
                        //       UpperCaseText(),
                        //     ],
                        //     controller: TextEditingController(
                        //       text: employeeID,
                        //       // text: isNew ? '' : employeeID,
                        //     ),
                        //     enabled: true,
                        //     style: GlobalFont.mediumgiantfontR,
                        //     decoration: InputDecoration(
                        //       filled: true,
                        //       fillColor: Colors.grey[400],
                        //       hintStyle: GlobalFont.mediumbigfontM,
                        //       hintText: 'Masukkan Employee ID',
                        //       border: OutlineInputBorder(
                        //         borderSide: BorderSide.none,
                        //         borderRadius: BorderRadius.circular(15.0),
                        //       ),
                        //     ),
                        //     onChanged: (newValues) => setEmployeeID(newValues),
                        //   ),
                        // ),
                        NIPAutoComplete(
                          employeeID,
                          setEmployeeID,
                        ),
                        SizedBox(width: 10.0),
                        InkWell(
                          onTap: () => setDateByGoogle(
                            context,
                            date,
                          ),
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.height * 0.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.date_range_rounded),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.003,
                                ),
                                Text(
                                  date == ''
                                      ? Format.tanggalFormat(
                                          DateTime.now()
                                              .subtract(Duration(days: 7))
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
                        // Delete -> remove later
                        // SizedBox(width: 10.0),
                        // Text(
                        //   ' - ',
                        //   style: GlobalFont.mediumgiantfontR,
                        // ),
                        // SizedBox(width: 10.0),
                        // InkWell(
                        //   onTap: () => setEndDateByGoogle(
                        //     context,
                        //     endDate,
                        //   ),
                        //   child: Container(
                        //     // width: MediaQuery.of(context).size.width * 0.1,
                        //     height: MediaQuery.of(context).size.height * 0.05,
                        //     alignment: Alignment.center,
                        //     decoration: BoxDecoration(
                        //       color: Colors.grey[400],
                        //       borderRadius: BorderRadius.circular(15.0),
                        //     ),
                        //     padding: EdgeInsets.symmetric(horizontal: 15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //       children: [
                        //         Icon(Icons.date_range_rounded),
                        //         SizedBox(
                        //           width:
                        //               MediaQuery.of(context).size.width * 0.003,
                        //         ),
                        //         Text(
                        //           endDate == ''
                        //               ? Format.tanggalFormat(
                        //                   DateTime.now()
                        //                       .toString()
                        //                       .substring(0, 10),
                        //                 )
                        //               : Format.tanggalFormat(endDate),
                        //           style: GlobalFont.mediumgiantfontR,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(width: 10.0),
                        InkWell(
                          onTap: () {
                            getFilterData(
                              context,
                              salesActivitiesState,
                            );

                            filterDataNotifier.value
                                .add(employeeIDNotifier.value);
                            filterDataNotifier.value.add(dateNotifier.value);
                            // filterDataNotifier.value.add(endDateNotifier.value);
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.03,
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
                        SizedBox(width: 10.0),
                        InkWell(
                          onTap: () {
                            resetData();
                            salesActivitiesState.setIsReset();
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.05,
                            height: MediaQuery.of(context).size.height * 0.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              'Reset',
                              style: GlobalFont.mediumgiantfontR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            // =================================================================
            // ========================== Devider ==============================
            // =================================================================
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),

            // =================================================================
            // ====================== Routes List View =========================
            // =================================================================
            Container(
              height: MediaQuery.of(context).size.height * 0.82,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.01,
                horizontal: MediaQuery.of(context).size.width * 0.01,
              ),
              child: ValueListenableBuilder(
                valueListenable: filterDataNotifier,
                builder: (context, value, child) {
                  if (value.isNotEmpty) {
                    String id = value[0];
                    String date = value[1];

                    return FutureBuilder(
                      future: salesActivitiesState.fetchSalesActivities(
                        id,
                        date,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                                Text(
                                  'Loading...',
                                  style: GlobalFont.mediumbigfontR,
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.data!.salesman.isEmpty &&
                            snapshot.data!.activities.isEmpty) {
                          return Center(child: Text('Data not available'));
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: (MediaQuery.of(context).size.width <
                                        1050)
                                    ? MediaQuery.of(context).size.width * 0.35
                                    : MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.11,
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.01,
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.075,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      child: FittedBox(
                                        child: Icon(
                                          Icons.person,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            snapshot.data!.salesman[0].name,
                                            style:
                                                GlobalFont.mediumgiantfontRBold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            snapshot.data!.salesman[0].id,
                                            style: GlobalFont.bigfontR,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            snapshot.data!.salesman[0].location,
                                            style: GlobalFont.bigfontR,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // =================== Divider ===================
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),

                              // ============ Table of Filter Result ===========
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.66,
                                child: (snapshot.data!.activities.isEmpty)
                                    ? Center(
                                        child: Text(
                                          'Activities are not available',
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025,
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          child: Table(
                                            border: TableBorder.all(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            defaultVerticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            columnWidths: const {
                                              0: FlexColumnWidth(0.75),
                                              1: FlexColumnWidth(0.65),
                                              2: FlexColumnWidth(1.75),
                                              3: FlexColumnWidth(0.8),
                                              4: FlexColumnWidth(0.8),
                                              5: FlexColumnWidth(0.7),
                                              6: FlexColumnWidth(0.4),
                                            },
                                            children: [
                                              // ============== Header =============
                                              TableRow(
                                                children: [
                                                  PaddedTableCell(
                                                    'Jenis Aktivitas',
                                                  ),
                                                  PaddedTableCell(
                                                    'Tanggal',
                                                  ),
                                                  PaddedTableCell(
                                                    'Deskripsi Aktivitas',
                                                  ),
                                                  PaddedTableCell(
                                                    'Nama Customer',
                                                  ),
                                                  PaddedTableCell(
                                                    'Kontak Customer',
                                                  ),
                                                  PaddedTableCell(
                                                    'Timeline',
                                                  ),
                                                  PaddedTableCell(
                                                    'Image',
                                                  ),
                                                ],
                                              ),

                                              // ============= Content =============
                                              for (var route
                                                  in snapshot.data!.activities)
                                                TableRow(
                                                  children: [
                                                    PaddedTableCell(
                                                      route.actName,
                                                    ),
                                                    PaddedTableCell(
                                                      Format.tanggalFormat(
                                                        route.currentDate,
                                                      ),
                                                    ),
                                                    PaddedTableCell(
                                                      route.actDesc,
                                                    ),
                                                    PaddedTableCell(
                                                      route.contactName != ''
                                                          ? route.contactName
                                                          : '-',
                                                    ),
                                                    PaddedTableCell(
                                                      route.contactNumber != ''
                                                          ? '+62${route.contactNumber}'
                                                          : '-',
                                                    ),
                                                    PaddedTableCell(
                                                      '${route.startTime} - ${route.endTime}',
                                                    ),
                                                    PaddedTableCell(
                                                      route.pic1,
                                                      isText: false,
                                                      valueFunction:
                                                          previewImage,
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          );
                        }
                      },
                    );
                  } else {
                    return Center(child: Text('Data are not available'));
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
