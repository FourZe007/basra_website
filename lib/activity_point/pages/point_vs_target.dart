import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/activity_point/widgets/dropdown_area.dart';
import 'package:stsj/activity_point/widgets/dropdown_cabang.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/datepicker_custom.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/snackbar_info.dart';
import 'package:stsj/core/models/Activities/area.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PointVsTarget extends StatefulWidget {
  const PointVsTarget({super.key});

  @override
  State<PointVsTarget> createState() => _PointVsTargetState();
}

class _PointVsTargetState extends State<PointVsTarget> {
  late String cabang, area, tgl1, tgl2;
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
  void setTgl1(String value) => tgl1 = value;
  void setTgl2(String value) => tgl2 = value;

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
    tgl1 = DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day).toString().substring(0, 10);
    tgl2 = DateTime.now().toString().substring(0, 10);
    loading = false;
  }

  Future exportExcel() async {
    setState(() => loading = true);

    String baseUrl =
        "https://wsip.yamaha-jatim.co.id:2449/Report/ExportXls?PT=BASRA&Param={'PT':'BASRA','ReportName':'TARGET VS RESULT SM','UserID':'ARMA VIEYYA','Filter1':'$cabang','Filter2':'$area','Filter3':'$tgl1','Filter4':'$tgl2','Filter5':'','Filter6':'','Filter7':'','Filter8':'','Filter9':'','Filter10':'','Filter11':'','Filter12':'','Filter13':'','Filter14':''}";

    try {
      await launchUrl(Uri.parse(baseUrl)).then((_) {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
    }

    setState(() => loading = false);
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
                const Text(' Tanggal :', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(child: DatepickerCustom(tgl1, setTgl1)),
                    const SizedBox(width: 10),
                    Expanded(child: DatepickerCustom(tgl2, setTgl2)),
                  ],
                ),
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
                onPressed: () => exportExcel(),
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
                  backgroundColor: const WidgetStatePropertyAll(Colors.indigo),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
                child: const Text('DOWNLOAD', style: TextStyle(fontSize: 13, color: Colors.white, letterSpacing: 1)),
              ),
      ],
    );
  }
}
