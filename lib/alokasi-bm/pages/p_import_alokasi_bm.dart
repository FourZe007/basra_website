import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/alokasi-bm/helper/api_alokasi_bm.dart';
import 'package:stsj/alokasi-bm/widget/w_alertdialog_info.dart';
import 'package:stsj/alokasi-bm/widget/w_tanggal.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';
import 'package:universal_html/html.dart' as html;

class PImportAlokasiBM extends StatefulWidget {
  const PImportAlokasiBM({super.key});

  @override
  State<PImportAlokasiBM> createState() => _MyPageState();
}

class _MyPageState extends State<PImportAlokasiBM> {
  DateTime tanggal = DateTime.now();
  bool waitUpload = false;
  List<Map> list = [];

  void setTanggal(dynamic value) => setState(() => tanggal = value);

  void processExcel() async {
    try {
      setState(() => waitUpload = true);

      list = [];
      FilePickerResult? picker = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

      if (picker != null) {
        if (picker.files.first.extension == 'xlsx') {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final userid = prefs.getString('UserID') ?? '';
          readExcel(picker);
          if (list.isNotEmpty) {
            await ApiAlokasiBM.uploadExcelAlokasiBM(
                '51', tanggal.toString().substring(0, 10), userid, list);
            if (!mounted) return;
            wAlertDialogInfo(context, 'INFORMASI', msg);
          }
        } else {
          setState(() => waitUpload = false);
          if (!mounted) return;
          wAlertDialogInfo(
              context, 'PERINGATAN', 'FORMAT FILE EXCEL WAJIB .XLSX');
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
        list.add({
          'UnitID': row.elementAt(0)!.value.toString(),
          'Color': row.elementAt(2)!.value.toString(),
          'Qty1': row.elementAt(4)!.value.toString(),
          'Qty2': row.elementAt(5)!.value.toString(),
          'Qty3': row.elementAt(6)!.value.toString(),
        });
      }
    }
    list.removeAt(0);
  }

  void getFormatExcel(String url) {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
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
              // Tools Badge

              const SizedBox(width: 12.0),

              // Date Field — fixed width
              SizedBox(
                width: 200,
                child: WTanggal(tanggal, setTanggal),
              ),

              const SizedBox(width: 10.0),

              // Upload Button
              waitUpload
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SpinKitDualRing(color: Colors.blue[900]!, size: 28),
                      ],
                    )
                  : SizedBox(
                      width: 160,
                      height: 36,
                      child: ElevatedButton.icon(
                        onPressed: processExcel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        icon: const Icon(Icons.upload_file_rounded, size: 16),
                        label: const Text(
                          'Upload Alokasi',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

              const SizedBox(width: 10.0),

              // Download Button
              SizedBox(
                width: 160,
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: () => getFormatExcel("Bagi FS Per BM.xlsx"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: const Text(
                    'Download Excel',
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
      ]),
    );
  }
}
