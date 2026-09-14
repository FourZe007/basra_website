import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stsj/alokasi-bm/widget/w_alertdialog_info.dart';
import 'package:stsj/alokasi-bm/widget/w_tombol_teks.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';
import 'package:url_launcher/url_launcher.dart';

class PImportCetakQR extends StatefulWidget {
  const PImportCetakQR({super.key});

  @override
  State<PImportCetakQR> createState() => _MyPageState();
}

class _MyPageState extends State<PImportCetakQR> {
  bool waitUpload = false, isCetakQR = false;
  List<Map> list = [];

  void processExcel() async {
    try {
      setState(() => waitUpload = true);

      list = [];
      FilePickerResult? picker =
          await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

      if (picker != null) {
        if (picker.files.first.extension == 'xlsx') {
          readExcel(picker);
          if (list.isNotEmpty) setState(() => isCetakQR = true);
        } else {
          setState(() => waitUpload = false);
          if (!mounted) return;
          wAlertDialogInfo(context, 'PERINGATAN', 'FORMAT FILE EXCEL WAJIB .XLSX');
        }
      }

      setState(() => waitUpload = false);
    } catch (e) {
      setState(() => waitUpload = false);
      if (!mounted) return;
      wAlertDialogInfo(context, 'PERINGATAN', e.toString());
    }
  }

  void readExcel(FilePickerResult picker) {
    var bytes = picker.files.single.bytes;
    var excel = Excel.decodeBytes(bytes!);
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        list.add({'LocationID': row.elementAt(0)!.value.toString()});
      }
    }
    list.removeAt(0);
  }

  void generateQR() async {
    final data = list.map((item) => "{'LocationID':'${item['LocationID']}'}").join(', ');
    final transNo = "{'Data':[$data]}";

    final String baseUrl = 'https://wsip.yamaha-jatim.co.id:2449/cetakan/viewpdf'
        '?PT=&Param={"Idx":"0","TransID":"LBL","Location":"0","TransNo":"$transNo"}';
    final url = Uri.parse(baseUrl);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(goBack: RoutesConstant.menu),
      ),
      body: Column(children: [
        SizedBox(height: 15),
        Row(children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child:
                  Text('${list.length} Data QR Di Temukan', style: GlobalFont.mediumbigfontMBold)),
          Expanded(
            flex: 1,
            child: waitUpload
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SpinKitDualRing(color: Colors.blue[900]!, size: 30),
                  ])
                : WTombolTeks('Upload Excel', Colors.black, processExcel),
          ),
          SizedBox(width: 10),
          isCetakQR
              ? Expanded(flex: 1, child: WTombolTeks('Cetak QR', Colors.blue[900]!, generateQR))
              : Expanded(flex: 1, child: SizedBox()),
          Expanded(flex: 6, child: SizedBox()),
        ])
      ]),
    );
  }
}
