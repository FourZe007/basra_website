import 'package:dotted_border/dotted_border.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stsj/activity_point/models/klasifikasi.dart';
import 'package:stsj/activity_point/services/api.dart';
import 'package:stsj/activity_point/utilities/global.dart';
import 'package:stsj/activity_point/widgets/dropdown_month.dart';
import 'package:stsj/activity_point/widgets/dropdown_year.dart';
import 'package:stsj/activity_point/widgets/target_table.dart';
import 'package:stsj/dashboard-fixup/utilities/basepage.dart';
import 'package:stsj/dashboard-fixup/widgets/button_widget.dart';
import 'package:stsj/dashboard-fixup/widgets/snackbar_info.dart';
import 'package:stsj/global/globalVar.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class ImportTargetDealer extends StatefulWidget {
  const ImportTargetDealer({super.key});

  @override
  State<ImportTargetDealer> createState() => _ImportTargetDealerState();
}

class _ImportTargetDealerState extends State<ImportTargetDealer> with BasePage, AutomaticKeepAliveClientMixin<ImportTargetDealer> {
  bool _waiting = false;
  late String namaFile, thn, bln;
  late dynamic uploadFile;
  late bool _proses;
  late List<String> header;
  late List<Klasifikasi> detail;

  void setThn(String value) => setState(() => thn = value);
  void setBln(String value) => setState(() => bln = value);

  void setReset() {
    namaFile = 'Upload File';
    uploadFile = null;
    _proses = false;
    header = [];
    detail = [];
  }

  @override
  void initState() {
    thn = DateTime.now().year.toString();
    bln = DateTime.now().month.toString().padLeft(2, '0');

    setReset();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openFileExplorer() async {
    if (_waiting == false) {
      try {
        FilePickerResult? pidkedFile = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
          allowMultiple: false,
        );
        if (pidkedFile != null) {
          uploadFile = pidkedFile.files.single.bytes;
          setState(() => namaFile = pidkedFile.files.single.name);
        } else {
          setState(() => setReset());
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, 'GAGAL MEMILIH FILE'));
        }
      } on PlatformException catch (_) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, 'MEMBUTUHKAN AKSES MEDIA PENYIMPANAN'));
      } catch (ex) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, 'TERJADI KESALAHAN'));
      }
    }
  }

  void _readExcelFile() async {
    setState(() => _waiting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      header = [];
      detail = [];

      if (uploadFile != null) {
        var excel = Excel.decodeBytes(uploadFile);

        var table = excel.tables.keys.first;

        bool flexHeader = false;
        for (var row in excel.tables[table]!.rows) {
          if (flexHeader == false) {
            row.map((data) {
              header.add(data!.value.toString());
            }).toList();
            flexHeader = true;
          } else {
            List<String> tempDetail = [];
            row.map((data) {
              tempDetail.add(data!.value == null ? '0' : data.value.toString());
            }).toList();
            detail.add(Klasifikasi.fromJson(tempDetail));
          }
        }

        if (header[0] == 'BigArea' &&
            header[1] == 'SmallArea' &&
            header[2] == 'Kode DPack' &&
            header[3] == 'Branch' &&
            header[4] == 'Shop' &&
            header[5] == 'Nama Dealer' &&
            header[6] == '01' &&
            header[7] == '02' &&
            header[8] == '03' &&
            header[9] == '04' &&
            header[10] == '05' &&
            header[11] == '06' &&
            header[12] == '07' &&
            header[13] == '08' &&
            header[14] == '09' &&
            header[15] == '10' &&
            header[16] == '11' &&
            header[17] == '12' &&
            header[18] == '13' &&
            header[19] == '14' &&
            header[20] == '15' &&
            header[21] == '16' &&
            header[22] == '17' &&
            header[23] == '18' &&
            header[24] == '19' &&
            header[25] == '20' &&
            header[26] == '21' &&
            header[27] == '22' &&
            header[28] == '23' &&
            header[29] == '24' &&
            header[30] == '25' &&
            header[31] == '26' &&
            header[32] == '27' &&
            header[33] == '28' &&
            header[34] == '29' &&
            header[35] == '30' &&
            header[36] == '31') {
          _proses = true;
        } else {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, 'FILE DATA TIDAK SESUAI FORMAT'));
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, 'PILIH FILE TERLEBIH DAHULU'));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, 'FILE GAGAL DIPROSES'));
    }

    setState(() => _waiting = false);
  }

  void _uploadDataExcel() async {
    setState(() => loading = true);

    try {
      await ApiPoint.prosesUploadTarget(GlobalVar.username, thn, bln, detail).then((value) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(false, 'DATA BERHASIL DIUPLOAD'));
        setReset();
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
    }

    setState(() => loading = false);
  }

  @override
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: startUpPage(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              color: Colors.blue[300]!.withValues(alpha: 0.3),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(' Tahun:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          DropdownYear(2025, DateTime.now().year, thn, 'Pilih Tahun', setThn),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(' Bulan:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          DropdownMonth(listMapBulan, bln, 'Pilih Bulan', setBln),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    VerticalDivider(color: Colors.black26, thickness: 1.2, width: 1),
                    const SizedBox(width: 20),
                    const Text('File Excel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 3,
                      child: DottedBorder(
                        radius: const Radius.circular(5),
                        color: namaFile == 'Upload File' ? Colors.blueGrey[300]! : Colors.indigo,
                        dashPattern: namaFile == 'Upload File' ? [8, 4] : [8, 0],
                        borderType: BorderType.RRect,
                        child: ListTile(
                          horizontalTitleGap: 10,
                          minLeadingWidth: 25,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                          leading: const Icon(Icons.upload_file),
                          iconColor: namaFile == 'Upload File' ? Colors.blueGrey[300]! : Colors.indigo,
                          textColor: namaFile == 'Upload File' ? Colors.blueGrey[300]! : Colors.indigo,
                          title: Text(namaFile),
                          onTap: _openFileExplorer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 100,
                      child: _waiting
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.orange.shade50,
                                valueColor: const AlwaysStoppedAnimation(Colors.orange),
                                strokeWidth: 5.0,
                              ),
                            )
                          : ButtonWidget('Proses', _readExcelFile),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 13),
                child: _proses
                    ? Table(
                        border: TableBorder.all(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(0.8),
                          5: FlexColumnWidth(0.8),
                          6: FlexColumnWidth(0.8),
                          7: FlexColumnWidth(0.8),
                          8: FlexColumnWidth(0.8),
                          9: FlexColumnWidth(0.8),
                          10: FlexColumnWidth(0.8),
                          11: FlexColumnWidth(0.8),
                          12: FlexColumnWidth(0.8),
                          13: FlexColumnWidth(0.8),
                          14: FlexColumnWidth(0.8),
                          15: FlexColumnWidth(0.8),
                          16: FlexColumnWidth(0.8),
                          17: FlexColumnWidth(0.8),
                          18: FlexColumnWidth(0.8),
                          19: FlexColumnWidth(0.8),
                          20: FlexColumnWidth(0.8),
                          21: FlexColumnWidth(0.8),
                          22: FlexColumnWidth(0.8),
                          23: FlexColumnWidth(0.8),
                          24: FlexColumnWidth(0.8),
                          25: FlexColumnWidth(0.8),
                          26: FlexColumnWidth(0.8),
                          27: FlexColumnWidth(0.8),
                          28: FlexColumnWidth(0.8),
                          29: FlexColumnWidth(0.8),
                          30: FlexColumnWidth(0.8),
                          31: FlexColumnWidth(0.8),
                        },
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                            ),
                            children: [
                              Center(child: Text('No.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('Dpack', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('Branch', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('Shop', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('01', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('02', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('03', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('04', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('05', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('06', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('07', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('08', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('09', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('10', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('11', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('12', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('13', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('14', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('15', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('16', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('17', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('18', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('19', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('20', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('21', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('22', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('23', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('24', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('25', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('26', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('27', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('28', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('29', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('30', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                              Center(child: Text('31', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1)),
                            ],
                          ),
                          ...detail.map((item) {
                            bool lastRow = detail.length == detail.indexOf(item) + 1;
                            return TableRow(
                              children: [
                                Center(child: Text((detail.indexOf(item) + 1).toString(), style: const TextStyle(fontSize: 13), maxLines: 1)),
                                Center(child: Text(item.kodeDpack, style: TextStyle(fontSize: 13), maxLines: 1)),
                                Center(child: Text(item.branch, style: TextStyle(fontSize: 13), maxLines: 1)),
                                Center(child: Text(item.shop, style: TextStyle(fontSize: 13), maxLines: 1)),
                                targetTable(item.t1),
                                targetTable(item.t2),
                                targetTable(item.t3),
                                targetTable(item.t4),
                                targetTable(item.t5),
                                targetTable(item.t6),
                                targetTable(item.t7),
                                targetTable(item.t8),
                                targetTable(item.t9),
                                targetTable(item.t10),
                                targetTable(item.t11),
                                targetTable(item.t12),
                                targetTable(item.t13),
                                targetTable(item.t14),
                                targetTable(item.t15),
                                targetTable(item.t16),
                                targetTable(item.t17),
                                targetTable(item.t18),
                                targetTable(item.t19),
                                targetTable(item.t20),
                                targetTable(item.t21),
                                targetTable(item.t22),
                                targetTable(item.t23),
                                targetTable(item.t24),
                                targetTable(item.t25),
                                targetTable(item.t26),
                                targetTable(item.t27),
                                targetTable(item.t28),
                                targetTable(item.t29),
                                targetTable(item.t30),
                                targetTable(item.t31, last: lastRow),
                              ],
                            );
                          }),
                        ],
                      )
                    : const SizedBox(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 13),
              color: Colors.blue[300]!.withValues(alpha: 0.3),
              child: ButtonWidget('Upload', _uploadDataExcel, disable: !_proses),
            ),
          ],
        ),
      ),
    );
  }
}
