import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/activity_point/models/point_sm_hd.dart';
import 'package:stsj/activity_point/pages/activities_point_2.dart';
import 'package:stsj/activity_point/services/api.dart';
import 'package:stsj/activity_point/utilities/global.dart';
import 'package:stsj/activity_point/widgets/dropdown_area.dart';
import 'package:stsj/activity_point/widgets/dropdown_cabang.dart';
import 'package:stsj/activity_point/widgets/dropdown_month.dart';
import 'package:stsj/activity_point/widgets/dropdown_year.dart';
import 'package:stsj/core/models/Activities/area.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/widgets/snackbar_info.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late String cabang, area, thn, bln;
  late bool loading;
  late List<String> provinceList;
  late List<ModelAreas> areaList;

  void setCabang(String value) async {
    await Provider.of<MenuState>(context, listen: false).fetchAreas(value);
    setState(() {
      cabang = value;
      area = '';
      areaList = Provider.of<MenuState>(context, listen: false).getAreaList;
    });
  }

  void setArea(String value) => setState(() => area = value);
  void setThn(String value) => setState(() => thn = value);
  void setBln(String value) => setState(() => bln = value);

  @override
  void initState() {
    setAwal();
    reset();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setAwal() async {
    await Provider.of<MenuState>(context, listen: false).loadProvinces();
    setState(() {
      provinceList = Provider.of<MenuState>(context, listen: false).getProvinceList;
    });
  }

  void reset() {
    provinceList = Provider.of<MenuState>(context, listen: false).getProvinceList;
    areaList = [];
    cabang = '';
    area = '';
    thn = DateTime.now().year.toString();
    bln = DateTime.now().month.toString().padLeft(2, '0');
    loading = false;
  }

  void find() async {
    try {
      setState(() => loading = true);

      String tgl1 = DateTime(int.parse(thn), int.parse(bln), 1).toString().substring(0, 10);
      String tgl2 = DateTime(int.parse(thn), int.parse(bln) + 1, 0).toString().substring(0, 10);

      List<PointSMHD> listData = await ApiPoint.getSMPoint('ARMA VIEYYA', cabang, area, tgl1, tgl2);

      if (listData.isEmpty) {
        throw ('Hasil Tidak Ditemukan');
      } else {
        if (mounted) Navigator.pop(context);
        if (mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => ActivitiesPoint2(listData)));
      }
    } catch (e) {
      setState(() => loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.only(bottom: 20, top: 10, left: 20, right: 20),
      contentPadding: const EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 5),
      title: const Text('FILTER', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
      actionsAlignment: MainAxisAlignment.center,
      content: IntrinsicHeight(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(' Cabang :', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                DropdownCabang(provinceList, cabang, 'Pilih Cabang', setCabang, disable: false),
                const SizedBox(height: 10),
                const Text(' Area :', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                DropdownArea(areaList, area, 'Pilih Area', setArea, disable: cabang == '' ? true : false),
                const SizedBox(height: 10),
                const Text(' Tahun :', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                DropdownYear(2025, DateTime.now().year, thn, 'Pilih Tahun', setThn),
                const SizedBox(height: 10),
                const Text(' Bulan :', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                DropdownMonth(listMapBulan, bln, 'Pilih Bulan', setBln),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      actions: [
        loading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.indigo,
                  valueColor: AlwaysStoppedAnimation(Colors.cyan.shade200),
                  strokeWidth: 5.0,
                ),
              )
            : ElevatedButton(
                onPressed: () => find(),
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
                  backgroundColor: const WidgetStatePropertyAll(Colors.indigo),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
                child: const Text(' CARI ', style: TextStyle(fontSize: 13, color: Colors.white, letterSpacing: 1)),
              ),
      ],
    );
  }
}
