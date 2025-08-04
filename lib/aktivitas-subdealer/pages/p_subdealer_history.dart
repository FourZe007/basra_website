import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/aktivitas-subdealer/helper/api_aktivitas_subdealer.dart';
import 'package:stsj/aktivitas-subdealer/helper/model_aktivitas_subdealer.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_daily_report.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_morning_briefing.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_dd_provinsi.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_dd_wilayah.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_header_teks_ikon.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_header_tombol_ikon.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_header_tombol_teks.dart';
import 'package:stsj/aktivitas-subdealer/widget/w_input_teks.dart';
import 'package:stsj/alokasi-bm/widget/w_alertdialog_info.dart';
import 'package:stsj/alokasi-bm/widget/w_tanggal.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

List<ModelSDActivityReport> showActivityReport = [];

class PSubDealerHistory extends StatefulWidget {
  const PSubDealerHistory({super.key});

  @override
  State<PSubDealerHistory> createState() => _MyPageState();
}

class _MyPageState extends State<PSubDealerHistory> {
  String provinsi = '', wilayah = '', userID = '';
  DateTime tanggal = DateTime.now();
  bool waitInit = false, waitSearch = false, waitWilayah = false;
  TextEditingController controllerCustomerID = TextEditingController();
  List<ModelProvinsi> showProvinsi = [];
  List<ModelWilayah> showWilayah = [];

  Widget wContentHeader() {
    void setTanggal(dynamic value) => setState(() => tanggal = value);
    void setWilayah(dynamic value) => setState(() => wilayah = value);
    void setCustomerID(dynamic value) {
      controllerCustomerID = TextEditingController(text: value);
    }

    void setProvinsi(dynamic value) async {
      setState(() => waitWilayah = true);
      try {
        showWilayah = await APIAktivitasSubDealer.getMWilayah(userID, value);
        await Future.delayed(Duration(milliseconds: 500));
        showWilayah.insert(0, ModelWilayah(smallarea: ''));
        wilayah = '';
        provinsi = value;
      } catch (e) {
        rethrow;
      }
      setState(() => waitWilayah = false);
    }

    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        WHeaderTeksIkon('FILTER', Icons.filter_alt, Colors.black),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: WDDProvinsi(provinsi, showProvinsi, setProvinsi),
          ),
        ),
        Expanded(
          flex: 2,
          child: waitWilayah
              ? SpinKitCircle(color: Colors.blue[900]!, size: 30)
              : WDDWilayah(wilayah, showWilayah, setWilayah),
        ),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: WTanggal(tanggal, setTanggal),
            )),
        Expanded(
            flex: 2,
            child: WInputTeks(controllerCustomerID, setCustomerID,
                hint: 'Kode Customer, Contoh : XE00001')),
        SizedBox(
            width: 50,
            child: waitSearch
                ? SpinKitCircle(color: Colors.blue[900]!, size: 40)
                : WHeaderTombolIkon(Icons.search, search)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: WHeaderTombolTeks('RESET', reset),
        ),
        Expanded(flex: 1, child: SizedBox())
      ]),
    );
  }

  Widget wContentDetail(int index) {
    var list = showActivityReport[index];

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(children: [
        Row(children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: Text('${list.cName} (${list.customerID})',
                style: GlobalFont.giantfontMBold),
          )),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: Text('${list.bigArea} (${list.smallArea})',
                style: GlobalFont.giantfontMBold, textAlign: TextAlign.end),
          )),
        ]),
        Row(children: [
          PSubDealerMorningBriefing(index),
          PSubDealerDailyReport(index)
        ]),
      ]),
    );
  }

  void search() async {
    if (provinsi.isEmpty) {
      wAlertDialogInfo(context, 'INFORMASI', 'PROVINSI WAJIB DI ISI');
    } else {
      setState(() => waitSearch = true);
      showActivityReport = await APIAktivitasSubDealer.getSDActivityReport(
          userID,
          provinsi,
          wilayah,
          controllerCustomerID.text,
          tanggal.toString().substring(0, 10));
      await Future.delayed(Duration(milliseconds: 500));
      setState(() => waitSearch = false);
    }
  }

  void reset() => setState(() {
        provinsi = wilayah = '';
        tanggal = DateTime.now();
        controllerCustomerID.text = '';
        showActivityReport = [];
      });

  void loadAPI() async {
    setState(() => waitInit = true);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      userID = prefs.getString('UserID') ?? '';
      showProvinsi = await APIAktivitasSubDealer.getMProvinsi(userID);
      await Future.delayed(Duration(milliseconds: 500));
      showProvinsi.insert(0, ModelProvinsi(bigarea: ''));
      showWilayah.insert(0, ModelWilayah(smallarea: ''));
    } catch (e) {
      rethrow;
    }
    setState(() => waitInit = false);
  }

  @override
  void initState() {
    super.initState();
    loadAPI();
    showActivityReport = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(goBack: RoutesConstant.menu),
      ),
      body: waitInit
          ? Center(child: SpinKitDualRing(color: Colors.blue[900]!))
          : Column(children: [
              wContentHeader(),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(children: [
                  for (var i = 0; i < showActivityReport.length; i++)
                    wContentDetail(i),
                ]),
              )),
            ]),
    );
  }
}
