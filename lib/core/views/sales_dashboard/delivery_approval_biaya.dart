import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/models/Dashboard/delivery_approval.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/api.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/input_currency.dart';

class DeliveryApprovalBiaya extends StatefulWidget {
  const DeliveryApprovalBiaya(this.numerator, this.list, this.handle,
      {super.key});
  final String numerator;
  final List<DeliveryApprovalModel> list;
  final Function handle;

  @override
  State<DeliveryApprovalBiaya> createState() => _MyPageState();
}

class _MyPageState extends State<DeliveryApprovalBiaya> {
  String companyid = '', branch = '', shop = '', employeeid = '';
  bool waitAPI = false;
  List<DeliveryApprovalModel> list = [];

  DataRow rowDetail(int i) {
    var listBiaya = list[0].detail[i];
    void setAppAmount(dynamic value) => listBiaya.appamount = value;

    return DataRow(cells: [
      DataCell(Text(listBiaya.expensename)),
      DataCell(
        Text(NumberFormat.currency(
                decimalDigits: 0, symbol: 'Rp. ', locale: 'id')
            .format(int.parse(listBiaya.amount))),
      ),
      DataCell(WInputCurrency(
          NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'id')
              .format(int.parse(listBiaya.appamount)),
          'Nominal',
          setAppAmount)),
    ]);
  }

  void submitApproval(MenuState menuState) async {
    setState(() => waitAPI = true);
    List<Map> detail = [];

    for (var x in list[0].detail) {
      if (x.appamount != '0') {
        detail.add({'Line': x.line, 'Amount': x.appamount.replaceAll('.', '')});
      }
    }

    var getInsert = await GlobalAPI.fetchModifyApprovalBiaya(
        companyid, branch, shop, widget.numerator, employeeid, detail);

    if (getInsert.isNotEmpty) {
      if (!mounted) return;
      Navigator.pop(context);
      widget.handle(menuState);
    } else {
      setState(() => waitAPI = false);
      if (!mounted) return;
      GlobalFunction.showSnackbar(context, 'DATA GAGAL DI PROSES');
    }
  }

  void init() async {
    setState(() => waitAPI = true);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyid = prefs.getString('CompanyName') ?? '';
    branch = prefs.getString('branchId') ?? '';
    shop = prefs.getString('shopId') ?? '';
    employeeid = prefs.getString('EmployeeID') ?? '';

    list = widget.list.where((x) => x.transno == widget.numerator).toList();

    for (var x in list[0].detail) {
      x.appamount = x.amount;
    }

    setState(() => waitAPI = false);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = Provider.of<MenuState>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: waitAPI
          ? Center(child: CircularProgressIndicator(color: Colors.black))
          : Column(children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.black),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('RINCIAN BIAYA',
                        style: GlobalFont.gigafontRBoldWhite),
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DataTable(columns: [
                  DataColumn(
                    columnWidth: FlexColumnWidth(3),
                    label:
                        Text('JENIS BIAYA', style: GlobalFont.mediumfontRBold),
                  ),
                  DataColumn(
                    columnWidth: FlexColumnWidth(1),
                    label: Text('PENGAJUAN', style: GlobalFont.mediumfontRBold),
                  ),
                  DataColumn(
                      columnWidth: FlexColumnWidth(1),
                      label:
                          Text('APPROVAL', style: GlobalFont.mediumfontRBold))
                ], rows: [
                  for (var i = 0; i < list[0].detail.length; i++) rowDetail(i)
                ]),
              ),
              ElevatedButton.icon(
                onPressed: () => submitApproval(menuState),
                label: Text('SETUJU', style: GlobalFont.mediumfontCWhite),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green[900]),
                ),
                icon: Icon(Icons.save, color: Colors.white),
              )
            ]),
    );
  }
}
