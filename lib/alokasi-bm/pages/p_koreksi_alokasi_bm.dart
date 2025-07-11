import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/alokasi-bm/helper/api_alokasi_bm.dart';
import 'package:stsj/alokasi-bm/helper/model_alokasi_bm.dart';
import 'package:stsj/alokasi-bm/pages/p_koreksi_alokasi_bm_detail.dart';
import 'package:stsj/alokasi-bm/widget/w_list_empty.dart';
import 'package:stsj/alokasi-bm/widget/w_tanggal.dart';
import 'package:stsj/alokasi-bm/widget/w_tombol_panjang_ikon.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

late List<ModelBrowseAlokasi> daftarAlokasi;

class PKoreksiAlokasiBM extends StatefulWidget {
  const PKoreksiAlokasiBM({super.key});

  @override
  State<PKoreksiAlokasiBM> createState() => _MyPageState();
}

class _MyPageState extends State<PKoreksiAlokasiBM> {
  DateTime tanggal = DateTime.now();
  bool waitAPI = false;

  void setTanggal(dynamic value) => tanggal = value;

  void getData() async {
    setState(() => waitAPI = true);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString('UserID') ?? '';
    daftarAlokasi = await ApiAlokasiBM.getDataAlokasiBM(
        userid, '51', tanggal.toString().substring(0, 10));
    setState(() => waitAPI = false);
  }

  @override
  void initState() {
    super.initState();
    daftarAlokasi = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(goBack: RoutesConstant.menu),
      ),
      body: Column(children: [
        SizedBox(height: 15),
        Row(children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: WTanggal('Tanggal', tanggal, setTanggal),
            ),
          ),
          Expanded(
            flex: 2,
            child: waitAPI
                ? Container()
                : WTombolPanjangIkon('Get Data', Icons.cloud_download,
                    Colors.white, Colors.black, getData),
          ),
          Expanded(flex: 12, child: SizedBox())
        ]),
        SizedBox(height: 10),
        Expanded(
          child: waitAPI
              ? Center(child: SpinKitDualRing(color: Colors.blue[900]!))
              : daftarAlokasi.isEmpty
                  ? WListEmpty(
                      'ALOKASI MASIH KOSONG', Icons.info, Colors.black, 100)
                  : PKoreksiAlokasiBMDetail(tanggal),
        )
      ]),
    );
  }
}
