import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stsj/core/models/Dashboard/delivery_memo.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/widget/gridtable/delivery_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalFunction {
  static tampilkanDialog(
    BuildContext context,
    bool isDismissible,
    Widget widget, {
    bool isBackgroundDisable = false,
    bool isCustomizable = false,
    Color color = Colors.white,
  }) {
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isCustomizable
              ? color
              : isBackgroundDisable
                  ? Colors.transparent
                  : Colors.blue.shade50,
          elevation: 16,
          child: widget,
        );
      },
    );
  }

  static showSnackbar(
    BuildContext context,
    String text, {
    int duration = 3,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Text(text),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.005,
          vertical: MediaQuery.of(context).size.height * 0.005,
        ),
      ),
    );
  }

  static Widget showLegend(
    Color color,
    String text, {
    IconData icon = Icons.location_pin,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 30,
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ~:Image Preview Function:~
  static void viewImage(
    BuildContext context,
    MenuState state,
    String timelineType,
    String activityNumber,
    String shippingNumber, {
    double shopLat = 0,
    double shopLng = 0,
    // String img,
    double deliveryLat = 0,
    double deliveryLng = 0,
  }) async {
    if (activityNumber.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => FutureBuilder<String>(
          future: state.fetchDeliveryHDImage(
            timelineType,
            activityNumber,
            timelineType == 'DETAIL' ? shippingNumber : '',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(
                  minHeight: 5.0,
                  color: Colors.black,
                ),
              );
            } else if (snapshot.hasError) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.blue.shade50,
                elevation: 16,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.0175,
                    vertical: MediaQuery.of(context).size.height * 0.025,
                  ),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: GlobalFont.bigfontR,
                  ),
                ),
              );
            } else if (!snapshot.hasData) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.blue.shade50,
                elevation: 16,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.0175,
                    vertical: MediaQuery.of(context).size.height * 0.025,
                  ),
                  child: Text(
                    'Data tidak ditemukan.',
                    style: GlobalFont.bigfontR,
                  ),
                ),
              );
            } else {
              print('snapshot result: ${snapshot.data}');
              if (snapshot.data != '') {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.blue.shade50,
                  elevation: 16,
                  child: Container(
                    //width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.0175,
                      vertical: MediaQuery.of(context).size.height * 0.025,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                              bottomLeft: (timelineType == 'DETAIL')
                                  ? Radius.circular(0.0)
                                  : Radius.circular(15.0),
                              bottomRight: (timelineType == 'DETAIL')
                                  ? Radius.circular(0.0)
                                  : Radius.circular(15.0),
                            ),
                            child: Image.memory(
                              base64Decode(snapshot.data!),
                              fit: BoxFit.cover,
                              //width: MediaQuery.of(context).size.width * 0.325,
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (timelineType == 'DETAIL') {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text('Koordinat toko')),
                                            Expanded(
                                              flex: 2,
                                              child: InkWell(
                                                onTap: () async {
                                                  Uri uri = Uri.parse(
                                                    'https://maps.google.com/?q=$shopLat,$shopLng',
                                                  );

                                                  if (await canLaunchUrl(uri)) {
                                                    await launchUrl(uri);
                                                  } else {
                                                    if (context.mounted) {
                                                      GlobalFunction
                                                          .showSnackbar(
                                                        context,
                                                        'Gagal membuka Google Maps.',
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  '${shopLat.toString()}, ${shopLng.toString()}',
                                                  style: GlobalFont
                                                      .mediumbigfontRUnderlinedBlue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Koordinat pengiriman',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: InkWell(
                                                onTap: () async {
                                                  Uri uri = Uri.parse(
                                                    'https://maps.google.com/?q=$deliveryLat,$deliveryLng',
                                                  );

                                                  if (await canLaunchUrl(uri)) {
                                                    await launchUrl(uri);
                                                  } else {
                                                    if (context.mounted) {
                                                      GlobalFunction
                                                          .showSnackbar(
                                                        context,
                                                        'Gagal membuka Google Maps.',
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  '${deliveryLat.toString()}, ${deliveryLng.toString()}',
                                                  style: GlobalFont
                                                      .mediumbigfontRUnderlinedBlue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.blue.shade50,
                  elevation: 16,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.0175,
                      vertical: MediaQuery.of(context).size.height * 0.025,
                    ),
                    child: Text(
                      'Gambar tidak ditemukan.',
                      style: GlobalFont.bigfontR,
                    ),
                  ),
                );
              }
            }
          },
        ),
      );
    } else {
      GlobalFunction.showSnackbar(
        context,
        'Aktivitas tidak ditemukan.',
      );
    }
  }

  // ~:Delivery Memo:~
  static void viewMemo(
    BuildContext context,
    MenuState state,
    String transNumber,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.blue.shade50,
        elevation: 16,
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.0125,
            vertical: MediaQuery.of(context).size.height * 0.025,
          ),
          child: FutureBuilder(
            future: state.fetchDeliveryMemo(
              state.getBranchId,
              state.getShopId,
              transNumber,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.black),
                      SizedBox(height: 10),
                      Text(
                        'Loading...',
                        style: GlobalFont.bigfontR,
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('terjadi kesalahan, mohon coba lagi.'),
                );
              } else if (!snapshot.hasData) {
                return Center(child: Text('Data tidak ditemukan'));
              } else {
                final List<DeliveryMemoModel> memos = snapshot.data![0];
                final String status = snapshot.data![1];

                if (status == 'failed') {
                  return Center(child: Text('Gagal memuat data.'));
                } else if (status == 'not found' || status == 'error') {
                  return Center(
                    child: Text('terjadi kesalahan, mohon coba lagi.'),
                  );
                } else {
                  return SfDataGrid(
                    source: DeliveryDataSource(deliveryData: memos),
                    columnWidthMode: ColumnWidthMode.fill,
                    checkboxShape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'transId',
                        width: MediaQuery.of(context).size.width * 0.1,
                        label: Container(
                          padding: EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: Text('ID Transaksi'),
                        ),
                      ),
                      GridColumn(
                        columnName: 'date',
                        width: MediaQuery.of(context).size.width * 0.075,
                        label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('Tanggal'),
                        ),
                      ),
                      GridColumn(
                        columnName: 'duNumber',
                        width: MediaQuery.of(context).size.width * 0.075,
                        label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Nomor DU',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'casingNo',
                        width: MediaQuery.of(context).size.width * 0.1,
                        label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            'ID Casing',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'koli',
                        width: MediaQuery.of(context).size.width * 0.05,
                        label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Koli',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'caseQty',
                        width: MediaQuery.of(context).size.width * 0.075,
                        label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Jumlah Casing',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'unitId',
                        width: MediaQuery.of(context).size.width * 0.145,
                        label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            'ID Unit',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'itemName',
                        label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Nama Barang',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'itemQty',
                        width: MediaQuery.of(context).size.width * 0.1,
                        label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Jumlah Barang',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    stackedHeaderRows: [
                      StackedHeaderRow(
                        cells: [
                          StackedHeaderCell(
                            columnNames: ['casingNo', 'koli', 'caseQty'],
                            child: Center(
                              child: Text(
                                'Casing',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          StackedHeaderCell(
                            columnNames: ['unitId', 'itemName', 'itemQty'],
                            child: Center(
                              child: Text(
                                'Keterangan Casing',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  // ~:Picking:~
  // static void viewPicking(
  //   BuildContext context,
  //   MenuState state,
  //   String dealerName,
  //   String date,
  //   String pic,
  // ) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (context) => Dialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       backgroundColor: Colors.blue.shade50,
  //       elevation: 16,
  //       child: Container(
  //         // width: MediaQuery.of(context).size.width * 0.35,
  //         height: MediaQuery.of(context).size.height * 0.9,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(15.0),
  //         ),
  //         padding: EdgeInsets.symmetric(
  //           horizontal: MediaQuery.of(context).size.width * 0.0125,
  //           vertical: MediaQuery.of(context).size.height * 0.025,
  //         ),
  //         child: FutureBuilder(
  //           future: state.fetchPickingData(date, pic),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return SizedBox(
  //                 width: MediaQuery.of(context).size.width,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     CircularProgressIndicator(color: Colors.black),
  //                     SizedBox(height: 10),
  //                     Text(
  //                       'Loading...',
  //                       style: GlobalFont.bigfontR,
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             } else if (snapshot.hasError) {
  //               return Center(
  //                 child: Text('terjadi kesalahan, mohon coba lagi.'),
  //               );
  //             } else if (!snapshot.hasData) {
  //               return Center(child: Text('Data tidak ditemukan'));
  //             } else {
  //               final List<PickPackModel> picking = snapshot.data![0];
  //               final String status = snapshot.data![1];

  //               if (status == 'failed') {
  //                 return Center(child: Text('Gagal memuat data.'));
  //               } else if (status == 'not found' || status == 'error') {
  //                 return Center(
  //                   child: Text('terjadi kesalahan, mohon coba lagi.'),
  //                 );
  //               } else {
  //                 return SfDataGrid(
  //                   source: PPDataSource(ppData: picking),
  //                   columnWidthMode: ColumnWidthMode.fill,
  //                   checkboxShape: RoundedRectangleBorder(
  //                     side: BorderSide(color: Colors.grey),
  //                     borderRadius: BorderRadius.circular(15.0),
  //                   ),
  //                   columns: <GridColumn>[
  //                     GridColumn(
  //                       columnName: 'header',
  //                       width: MediaQuery.of(context).size.width * 0.1,
  //                       label: Container(
  //                         padding: EdgeInsets.all(16.0),
  //                         alignment: Alignment.center,
  //                         child: Text(''),
  //                       ),
  //                     ),
  //                     GridColumn(
  //                       columnName: 'tDu',
  //                       width: MediaQuery.of(context).size.width * 0.1,
  //                       label: Container(
  //                         padding: EdgeInsets.all(16.0),
  //                         alignment: Alignment.center,
  //                         child: Text('Total'),
  //                       ),
  //                     ),
  //                     GridColumn(
  //                       columnName: 'tLine',
  //                       width: MediaQuery.of(context).size.width * 0.075,
  //                       label: Container(
  //                         padding: EdgeInsets.all(8.0),
  //                         alignment: Alignment.center,
  //                         child: Text('On Going'),
  //                       ),
  //                     ),
  //                     GridColumn(
  //                       columnName: 'tLeadTime',
  //                       width: MediaQuery.of(context).size.width * 0.075,
  //                       label: Container(
  //                         padding: EdgeInsets.all(8.0),
  //                         alignment: Alignment.center,
  //                         child: Text('On Going'),
  //                       ),
  //                     ),
  //                     GridColumn(
  //                       columnName: 'avgLeadTime',
  //                       width: MediaQuery.of(context).size.width * 0.075,
  //                       label: Container(
  //                         padding: EdgeInsets.all(8.0),
  //                         alignment: Alignment.center,
  //                         child: Text('On Going'),
  //                       ),
  //                     ),
  //                     GridColumn(
  //                       columnName: 'diff',
  //                       width: MediaQuery.of(context).size.width * 0.075,
  //                       label: Container(
  //                         padding: EdgeInsets.all(8.0),
  //                         alignment: Alignment.center,
  //                         child: Text('On Going'),
  //                       ),
  //                     ),
  //                     GridColumn(
  //                       columnName: 'avgDiff',
  //                       width: MediaQuery.of(context).size.width * 0.1,
  //                       label: Container(
  //                         padding: EdgeInsets.all(16.0),
  //                         alignment: Alignment.center,
  //                         child: Text('Total'),
  //                       ),
  //                     ),
  //                     GridColumn(
  //                       columnName: 'tAmount',
  //                       width: MediaQuery.of(context).size.width * 0.075,
  //                       label: Container(
  //                         padding: EdgeInsets.all(8.0),
  //                         alignment: Alignment.center,
  //                         child: Text('On Going'),
  //                       ),
  //                     ),
  //                     GridColumn(
  //                       columnName: 'onGoingDU',
  //                       width: MediaQuery.of(context).size.width * 0.075,
  //                       label: Container(
  //                         padding: EdgeInsets.all(8.0),
  //                         alignment: Alignment.center,
  //                         child: Text('On Going'),
  //                       ),
  //                     ),
  //                     GridColumn(
  //                       columnName: 'onGoingLine',
  //                       width: MediaQuery.of(context).size.width * 0.075,
  //                       label: Container(
  //                         padding: EdgeInsets.all(8.0),
  //                         alignment: Alignment.center,
  //                         child: Text('On Going'),
  //                       ),
  //                     ),
  //                     GridColumn(
  //                       columnName: 'onGoingAmount',
  //                       width: MediaQuery.of(context).size.width * 0.075,
  //                       label: Container(
  //                         padding: EdgeInsets.all(8.0),
  //                         alignment: Alignment.center,
  //                         child: Text('On Going'),
  //                       ),
  //                     ),
  //                   ],
  //                 );
  //               }
  //             }
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
