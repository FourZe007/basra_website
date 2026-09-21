import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/alokasi-bm/helper/api_alokasi_bm.dart';
import 'package:stsj/alokasi-bm/helper/model_alokasi_bm.dart';
import 'package:stsj/alokasi-bm/pages/p_koreksi_alokasi_bm_detail.dart';
import 'package:stsj/alokasi-bm/widget/w_list_empty.dart';
import 'package:stsj/alokasi-bm/widget/w_tanggal.dart';
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

  void setTanggal(dynamic value) => setState(() => tanggal = value);

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
        SizedBox(height: 12),
        // ================================================================
        // ========================= Tools Header =========================
        // ================================================================
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 12.0),

              // Date Field — fixed width
              SizedBox(
                width: 200,
                child: WTanggal(tanggal, setTanggal),
              ),

              const SizedBox(width: 10.0),

              // Get Data Button
              SizedBox(
                width: 140,
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: waitAPI ? null : getData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  icon: const Icon(Icons.search_rounded, size: 16),
                  label: const Text(
                    'Get Data',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: waitAPI
              ? Center(child: SpinKitDualRing(color: Colors.blue[900]!))
              : daftarAlokasi.isEmpty
                  ? WListEmpty(
                      'ALOKASI MASIH KOSONG', Icons.info, Colors.black, 100)
                  : PKoreksiAlokasiBMDetail(tanggal, getData),
        )
      ]),
    );
  }
}
