import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/models/Dashboard/delivery.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/api.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/input_currency.dart';

class DeliveryBiaya extends StatefulWidget {
  const DeliveryBiaya(this.numerator, this.list, this.handle, {super.key});
  final String numerator;
  final List<DeliveryModel> list;
  final Function handle;

  @override
  State<DeliveryBiaya> createState() => _MyPageState();
}

class _MyPageState extends State<DeliveryBiaya> {
  String companyid = '', branch = '', shop = '', employeeid = '';
  bool waitAPI = false;

  DataRow rowDetail(int i) {
    var list = widget.list[0].rincianBiayaDetail[i];
    void setAppAmount(dynamic value) => list.appamount = value;

    return DataRow(cells: [
      DataCell(Text(list.expensename)),
      DataCell(
        Text(NumberFormat.currency(
                decimalDigits: 0, symbol: 'Rp. ', locale: 'id')
            .format(int.parse(list.amount))),
      ),
      DataCell(WInputCurrency(
          NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'id')
              .format(int.parse(list.appamount)),
          'Nominal',
          setAppAmount)),
    ]);
  }

  void submitApproval(MenuState menuState) async {
    setState(() => waitAPI = true);
    List<Map> detail = [];

    for (var x in widget.list[0].rincianBiayaDetail) {
      if (x.appamount != '0') {
        detail.add({'Line': x.line, 'Amount': x.appamount.replaceAll('.', '')});
      }
    }

    var list = await GlobalAPI.fetchModifyApprovalBiaya(
        companyid, branch, shop, widget.numerator, employeeid, detail);

    if (list.isNotEmpty) {
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

    for (var x in widget.list[0].rincianBiayaDetail) {
      if (x.amount != '0') x.appamount = x.amount;
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
                  for (var i = 0;
                      i < widget.list[0].rincianBiayaDetail.length;
                      i++)
                    rowDetail(i)
                ]),
              ),
              menuState.getDeliveryList[0].flagApproval == 0
                  ? ElevatedButton.icon(
                      onPressed: () => submitApproval(menuState),
                      label: Text('SETUJU', style: GlobalFont.mediumfontCWhite),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.green[900]),
                      ),
                      icon: Icon(Icons.save, color: Colors.white),
                    )
                  : Container()
            ]),
    );
  }
}
