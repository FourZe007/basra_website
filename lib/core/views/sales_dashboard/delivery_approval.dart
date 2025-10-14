import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/alokasi-bm/widget/w_tombol_panjang_ikon.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/models/Dashboard/delivery_approval.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/core/views/sales_dashboard/delivery_approval_biaya.dart';
import 'package:stsj/global/api.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/dropdown/sis_branch_shop_dropdown.dart';
import 'package:stsj/global/widget/open_dialog.dart';
import 'package:stsj/router/router_const.dart';

class DeliveryApproval extends StatefulWidget {
  const DeliveryApproval({super.key});

  @override
  State<DeliveryApproval> createState() => _MyPageState();
}

class _MyPageState extends State<DeliveryApproval> {
  String branchshop = '', companyid = '', date = '';
  bool waitAPI = false;
  List<DeliveryApprovalModel> list = [];

  Card itemApproval(int index) {
    void submit() => wOpenDialog(context, true,
        DeliveryApprovalBiaya(list[index].transno, list, searchDelivery));

    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(5),
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
          Expanded(
              flex: 1,
              child: Text('Informasi Lain', style: GlobalFont.bigfontMBold))
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
          Expanded(
              flex: 1,
              child: Row(children: [
                Expanded(
                    child:
                        Text('Total Koli', style: GlobalFont.mediumbigfontM)),
                Expanded(
                    child: Text(list[index].koli.toString(),
                        style: GlobalFont.mediumbigfontM))
              ])),
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
          Expanded(
              flex: 1,
              child: Row(children: [
                Expanded(
                    child:
                        Text('Total Toko', style: GlobalFont.mediumbigfontM)),
                Expanded(
                    child: Text('${list[index].terkirim} / ${list[index].toko}',
                        style: GlobalFont.mediumbigfontM)),
              ])),
        ]),
        Row(children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('', style: GlobalFont.bigfontMBold),
            ),
          ),
          Expanded(
              flex: 1,
              child: Text('Pengajuan Biaya', style: GlobalFont.bigfontMBold)),
          Expanded(
              flex: 1,
              child: Text('Approval Biaya', style: GlobalFont.bigfontMBold)),
          Expanded(flex: 1, child: Text('', style: GlobalFont.bigfontMBold))
        ]),
        Row(children: [
          Expanded(flex: 2, child: SizedBox()),
          Expanded(
              flex: 1,
              child: Text(
                  NumberFormat.currency(
                          decimalDigits: 0, locale: 'id', symbol: 'Rp. ')
                      .format(list[index].amount),
                  style: GlobalFont.mediumbigfontM)),
          Expanded(
              flex: 1,
              child: Text(
                  NumberFormat.currency(
                          decimalDigits: 0, locale: 'id', symbol: 'Rp. ')
                      .format(list[index].appamount),
                  style: GlobalFont.mediumbigfontM)),
          list[index].flagapproval == 0
              ? Expanded(
                  flex: 1,
                  child: Row(children: [
                    WTombolPanjangIkon('APPROVAL', Icons.approval, Colors.white,
                        Colors.blue[900]!, submit),
                    SizedBox(width: 10)
                  ]))
              : Expanded(flex: 1, child: SizedBox()),
        ]),
      ]),
    );
  }

  void setDate(String value) => setState(() => date = value);
  void setBranchShop(String value) => branchshop = value;

  Future<void> setDateByGoogle(BuildContext context, String tgl) async {
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
    }
  }

  void searchDelivery(MenuState menuState) async {
    setState(() => waitAPI = true);
    list = [];
    if (date == '') setDate(DateTime.now().toString().substring(0, 10));

    if (branchshop.isEmpty) {
      GlobalFunction.showSnackbar(context, 'Nama Cabang Wajib Di Pilih');
      setState(() => waitAPI = false);
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      companyid = prefs.getString('CompanyName') ?? '';

      for (var branch in menuState.getBranchShopList) {
        if (branch.name == branchshop) {
          menuState.branchId = branch.branchId;
          menuState.shopId = branch.shopId;
          break;
        }
      }

      await prefs.setString('branchId', menuState.getBranchId);
      await prefs.setString('shopId', menuState.getShopId);
      await prefs.setString('date', date);

      list = await GlobalAPI.fetchDeliveryApproval(
          prefs.getString('CompanyName') ?? '',
          menuState.branchId,
          menuState.shopId,
          date);

      setState(() => waitAPI = false);
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<MenuState>(context, listen: false).resetDeliveryData();
    Provider.of<MenuState>(context, listen: false).loadSisBranches();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = Provider.of<MenuState>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(goBack: RoutesConstant.menu),
      ),
      body: Column(children: [
        SizedBox(height: 15),
        Row(children: [
          SizedBox(width: 10),
          InkWell(
            onTap: null,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(15.0)),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.filter_alt_rounded,
                        size: 25.0, color: Colors.black),
                    Text('Filter', style: GlobalFont.mediumgiantfontR)
                  ]),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ValueListenableBuilder<List<String>>(
                    valueListenable: menuState.getBranchNameListNotifier,
                    builder: (context, value, _) {
                      if (value.isEmpty) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.05,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01,
                            vertical: MediaQuery.of(context).size.height * 0.01,
                          ),
                          child: SisBranchShopDropdown(
                            listData: const [],
                            inputan: '',
                            hint: 'Cabang',
                            handle: () {},
                            disable: true,
                            isDriver: true,
                          ),
                        );
                      } else {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.05,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01,
                            vertical: MediaQuery.of(context).size.height * 0.01,
                          ),
                          child: SisBranchShopDropdown(
                            listData: value,
                            inputan: branchshop,
                            hint: 'Cabang',
                            handle: setBranchShop,
                            disable: false,
                            isDriver: true,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 10.0),
                  InkWell(
                    onTap: () async {
                      await setDateByGoogle(context, date);
                    },
                    child: Container(
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
                              width: MediaQuery.of(context).size.width * 0.003,
                            ),
                            Text(
                              date == ''
                                  ? Format.tanggalFormat(DateTime.now()
                                      .toString()
                                      .substring(0, 10))
                                  : Format.tanggalFormat(date),
                              style: GlobalFont.mediumgiantfontR,
                            )
                          ]),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  InkWell(
                    onTap: () => searchDelivery(menuState),
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
        ]),
        SizedBox(height: 10),
        Expanded(
          child: waitAPI
              ? Center(child: CircularProgressIndicator(color: Colors.black))
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 3.5),
                  itemCount: list.length,
                  itemBuilder: (context, index) => itemApproval(index),
                ),
        ),
        SizedBox(height: 10)
      ]),
    );
  }
}
