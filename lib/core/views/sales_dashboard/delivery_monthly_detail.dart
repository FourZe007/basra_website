import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/models/Dashboard/delivery_approval.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/api.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/input_field/currency.dart';

class DeliveryMonthlyDetail extends StatefulWidget {
  const DeliveryMonthlyDetail(this.tanggal, this.refreshKalendar, {super.key});
  final DateTime tanggal;
  final Function refreshKalendar;

  @override
  State<DeliveryMonthlyDetail> createState() => _MyPageState();
}

class _MyPageState extends State<DeliveryMonthlyDetail> {
  int allowApprove = 0, adaApprove = 0;
  bool waitAPI = false;
  List<DeliveryApprovalModel> list = [];

  Card itemApproval(int index) {
    void submit(int index) async {
      setState(() => list[index].waitApprove = true);
      List<Map> detail = [];

      for (var x in list[index].detail) {
        detail.add({'Line': x.line, 'Amount': x.appamount.replaceAll('.', '')});
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var getInsert = await GlobalAPI.fetchModifyApprovalBiaya(
          prefs.getString('CompanyName') ?? '',
          prefs.getString('branchId') ?? '',
          prefs.getString('shopId') ?? '',
          list[index].transno,
          prefs.getString('EmployeeID') ?? '',
          detail);

      if (getInsert.isEmpty) {
        setState(() => list[index].waitApprove = false);
        if (!mounted) return;
        GlobalFunction.showSnackbar(context, 'DATA GAGAL DI PROSES');
      } else {
        setState(() => list[index].waitApprove = false);
        getData();
      }
    }

    DataRow rowDetail(int i) {
      var listBiaya = list[index].detail[i];
      void setAppAmount(dynamic value) => listBiaya.appamount = value;

      return DataRow(cells: [
        DataCell(Text(listBiaya.line.toString())),
        DataCell(Text(listBiaya.expensename)),
        DataCell(
          Text(NumberFormat.currency(
                  decimalDigits: 0, symbol: 'Rp. ', locale: 'id')
              .format(int.parse(listBiaya.amount))),
        ),
        DataCell(CurrencyInputField(
            NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'id')
                .format(int.parse(listBiaya.appamount.replaceAll('.', ''))),
            setAppAmount)),
      ]);
    }

    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(list[index].ename, style: GlobalFont.giantfontMBold),
            ),
          ),
          Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            list[index].flagapproval == 0
                ? Icon(Icons.info, color: Colors.red, size: 30)
                : Icon(Icons.check_circle, color: Colors.green, size: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                  list[index].flagapproval == 0 ? 'PENDING' : 'APPROVED',
                  style: GlobalFont.giantfontMBold),
            )
          ]))
        ]),
        Row(children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('Data Kendaraan', style: GlobalFont.bigfontMBold),
            ),
          ),
          Expanded(
              flex: 1,
              child: Text('Keberangkatan', style: GlobalFont.bigfontMBold)),
          Expanded(
              flex: 1,
              child: Text('Kedatangan', style: GlobalFont.bigfontMBold)),
          Expanded(flex: 1, child: SizedBox()),
        ]),
        Row(children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Expanded(
                      flex: 1,
                      child:
                          Text('No Chasis', style: GlobalFont.mediumbigfontM)),
                  Expanded(
                      flex: 2,
                      child: Text(list[index].chasisno,
                          style: GlobalFont.mediumbigfontM)),
                ]),
              )),
          Expanded(
              flex: 1,
              child: Text('Pukul ${list[index].starttime}',
                  style: GlobalFont.mediumbigfontM)),
          Expanded(
              flex: 1,
              child: Text('Pukul ${list[index].enddtime}',
                  style: GlobalFont.mediumbigfontM)),
          Expanded(flex: 1, child: SizedBox())
        ]),
        Row(children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Expanded(
                      flex: 1,
                      child:
                          Text('No Polisi', style: GlobalFont.mediumbigfontM)),
                  Expanded(
                      flex: 2,
                      child: Text(list[index].plateno,
                          style: GlobalFont.mediumbigfontM)),
                ]),
              )),
          Expanded(flex: 1, child: Text('', style: GlobalFont.mediumbigfontM)),
          Expanded(flex: 1, child: Text('', style: GlobalFont.mediumbigfontM)),
          Expanded(flex: 1, child: SizedBox()),
        ]),
        SizedBox(height: 10),
        Row(children: [
          Expanded(
            flex: 2,
            child: Stack(alignment: Alignment.center, children: [
              Container(
                height: 30,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  value: list[0].persenterkirim / 100,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[900]!),
                ),
              ),
              Text(
                  'Total Koli ${list[index].totalterkirim} / ${list[index].totalterkirim} (${list[index].persenterkirim} %)',
                  style: GlobalFont.mediumbigfontMWhiteBold),
            ]),
          ),
          Expanded(
              flex: 1,
              child: Text('Total Pengajuan', style: GlobalFont.bigfontMBold)),
          Expanded(
              flex: 1,
              child: Text('Total Approval', style: GlobalFont.bigfontMBold)),
          Expanded(flex: 1, child: Text('', style: GlobalFont.bigfontMBold)),
        ]),
        Row(children: [
          Expanded(
            flex: 2,
            child: Stack(alignment: Alignment.center, children: [
              Container(
                height: 30,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  value: list[0].persenterkirim / 100,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red[900]!),
                ),
              ),
              Text(
                  'Total Toko ${list[index].totaltokoterkirim} / ${list[index].totaltoko} (${list[index].persentasetokoterkirim} %)',
                  style: GlobalFont.mediumbigfontMWhiteBold),
            ]),
          ),
          Expanded(
              flex: 1,
              child: Text(
                  NumberFormat.currency(
                          decimalDigits: 0, symbol: 'Rp. ', locale: 'id')
                      .format(list[index].amount),
                  style: GlobalFont.bigfontMBold)),
          Expanded(
              flex: 1,
              child: Text(
                  NumberFormat.currency(
                          decimalDigits: 0, symbol: 'Rp. ', locale: 'id')
                      .format(list[index].appamount),
                  style: GlobalFont.bigfontMBold)),
          Expanded(flex: 1, child: Text('', style: GlobalFont.mediumbigfontM)),
        ]),
        Padding(
          padding: const EdgeInsets.all(10),
          child: DataTable(
            border: TableBorder.all(
              color: Colors.black,
              borderRadius: BorderRadius.circular(0),
            ),
            columnSpacing: 25,
            headingRowHeight: 25,
            headingRowColor: WidgetStatePropertyAll(Colors.blue[900]),
            dataRowMinHeight: 25,
            dataRowMaxHeight: 30,
            dataRowColor: WidgetStatePropertyAll(Colors.grey[200]),
            columns: [
              DataColumn(
                columnWidth: FlexColumnWidth(0.5),
                label: Text('NO', style: GlobalFont.mediumbigfontRBoldWhite),
              ),
              DataColumn(
                columnWidth: FlexColumnWidth(2),
                label: Text('JENIS BIAYA',
                    style: GlobalFont.mediumbigfontRBoldWhite),
              ),
              DataColumn(
                columnWidth: FlexColumnWidth(1.5),
                label: Text('PENGAJUAN',
                    style: GlobalFont.mediumbigfontRBoldWhite),
              ),
              DataColumn(
                  columnWidth: FlexColumnWidth(1.5),
                  label: Text('APPROVAL',
                      style: GlobalFont.mediumbigfontRBoldWhite))
            ],
            rows: [
              for (var i = 0; i < list[index].detail.length; i++) rowDetail(i)
            ],
          ),
        ),
        allowApprove == 1
            ? Row(children: [
                Expanded(flex: 4, child: SizedBox()),
                list[index].flagapproval == 0
                    ? Expanded(
                        flex: 1,
                        child: list[index].waitApprove
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Colors.black),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ElevatedButton(
                                    onPressed: () => submit(index),
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.green[900])),
                                    child: Text('SETUJU',
                                        style: GlobalFont.mediumfontRWhite)),
                              ),
                      )
                    : Expanded(flex: 1, child: SizedBox()),
              ])
            : Container()
      ]),
    );
  }

  void getData() async {
    list = [];
    setState(() => waitAPI = true);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    list = await GlobalAPI.fetchDeliveryApproval(
        prefs.getString('CompanyName') ?? '',
        prefs.getString('branchId') ?? '',
        prefs.getString('shopId') ?? '',
        widget.tanggal.toString().substring(0, 10));

    for (var header in list) {
      for (var detail in header.detail) {
        if (detail.appamount == '0') detail.appamount = detail.amount;
      }
    }

    setState(() => waitAPI = false);
  }

  void cekPrivilege() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList('subheaderallowedit');

    for (var x in list!) {
      if (x == '006') {
        allowApprove = 1;
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    cekPrivilege();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = Provider.of<MenuState>(context);
    return Column(children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.blue[900]!),
        padding: EdgeInsets.all(10),
        child: Row(children: [
          Expanded(
            flex: 7,
            child: Row(children: [
              Text(DateFormat('dd-MMMM-yyyy').format(widget.tanggal),
                  style: GlobalFont.gigafontRBoldWhite)
            ]),
          ),
          Expanded(
            flex: 1,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                  onPressed: () {
                    if (adaApprove == 1) widget.refreshKalendar(menuState);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel, color: Colors.red, size: 40)),
            ]),
          )
        ]),
      ),
      SizedBox(height: 10),
      Expanded(
        child: waitAPI
            ? Center(child: CircularProgressIndicator(color: Colors.black))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1.25),
                itemCount: list.length,
                itemBuilder: (context, index) => itemApproval(index),
              ),
      ),
      SizedBox(height: 10)
    ]);
  }
}
