import 'package:dotted_border/dotted_border.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/snackbar_info.dart';
import 'package:stsj/dashboard-fixup/models/parameter_model.dart';
import 'package:stsj/dashboard-fixup/services/api.dart';
import 'package:stsj/dashboard-fixup/utilities/basepage.dart';
import 'package:stsj/dashboard-fixup/widgets/button_widget.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class ImportExcel extends StatefulWidget {
  const ImportExcel({super.key});

  @override
  State<ImportExcel> createState() => _ImportExcelState();
}

class _ImportExcelState extends State<ImportExcel>
    with BasePage, AutomaticKeepAliveClientMixin<ImportExcel> {
  bool _waiting = false;
  late String namaFile;
  late dynamic uploadFile;
  late bool _proses;
  late List<String> header;
  late List<Parameter> detail;

  setReset() {
    namaFile = 'Upload File';
    uploadFile = null;
    _proses = false;
    header = [];
    detail = [];
  }

  @override
  void initState() {
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
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              info(true, 'GAGAL MEMILIH FILE'),
            );
          }
        }
      } on PlatformException catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            info(true, 'MEMBUTUHKAN AKSES MEDIA PENYIMPANAN'),
          );
        }
      } catch (ex) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            info(true, 'TERJADI KESALAHAN'),
          );
        }
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
              tempDetail.add(data!.value.toString());
            }).toList();
            detail.add(Parameter.fromJson(tempDetail));
          }
        }

        if (header[0] == 'Branch' &&
            header[1] == 'Shop' &&
            header[2] == 'Tanggal' &&
            header[3] == 'SA' &&
            header[4] == 'Mekanik' &&
            header[5] == 'Hari Kerja' &&
            header[6] == 'RUT') {
          _proses = true;
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(info(true, 'FILE DATA TIDAK SESUAI FORMAT'));
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(info(true, 'PILIH FILE TERLEBIH DAHULU'));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(info(true, 'FILE GAGAL DIPROSES'));
      }
    }

    setState(() => _waiting = false);
  }

  void _uploadDataExcel() async {
    setState(() => loading = true);

    try {
      await SampApi.prosesUploadExcel(detail).then((value) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(info(false, 'DATA BERHASIL DIUPLOAD'));
          setReset();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
      }
    }

    setState(() => loading = false);
  }

  @override
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.blue[50]!.withAlpha(200),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: startUpPage(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('File Excel',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(5),
                      strokeWidth: 1,
                      color: namaFile == 'Upload File'
                          ? Colors.blueGrey[300]!
                          : Colors.indigo,
                      dashPattern: namaFile == 'Upload File' ? [8, 4] : [8, 0],
                      child: ListTile(
                        horizontalTitleGap: 10,
                        minLeadingWidth: 25,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        leading: const Icon(Icons.upload_file),
                        iconColor: namaFile == 'Upload File'
                            ? Colors.blueGrey[300]!
                            : Colors.indigo,
                        textColor: namaFile == 'Upload File'
                            ? Colors.blueGrey[300]!
                            : Colors.indigo,
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
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.orange),
                              strokeWidth: 5.0,
                            ),
                          )
                        : ButtonWidget('Proses', _readExcelFile),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: _proses
                      ? Table(
                          border: TableBorder.all(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(0.5),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1.5),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(1),
                            7: FlexColumnWidth(1),
                          },
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(5)),
                              ),
                              children: [
                                Center(
                                    child: Text('No.',
                                        style: TextStyle(fontSize: 13),
                                        textAlign: TextAlign.center)),
                                Center(
                                    child: Text('Branch',
                                        style: TextStyle(fontSize: 13),
                                        textAlign: TextAlign.center)),
                                Center(
                                    child: Text('Shop',
                                        style: TextStyle(fontSize: 13),
                                        textAlign: TextAlign.center)),
                                Center(
                                    child: Text('Tanggal',
                                        style: TextStyle(fontSize: 13),
                                        textAlign: TextAlign.center)),
                                Center(
                                    child: Text('SA',
                                        style: TextStyle(fontSize: 13),
                                        textAlign: TextAlign.center)),
                                Center(
                                    child: Text('Mekanik',
                                        style: TextStyle(fontSize: 13),
                                        textAlign: TextAlign.center)),
                                Center(
                                    child: Text('Hari Kerja',
                                        style: TextStyle(fontSize: 13),
                                        textAlign: TextAlign.center)),
                                Center(
                                    child: Text('RUT',
                                        style: TextStyle(fontSize: 13),
                                        textAlign: TextAlign.center)),
                              ],
                            ),
                            ...detail.map((item) {
                              return TableRow(
                                children: [
                                  Center(
                                      child: Text(
                                          (detail.indexOf(item) + 1).toString(),
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center)),
                                  Center(
                                      child: Text(item.branch,
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center)),
                                  Center(
                                      child: Text(item.shop,
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center)),
                                  Center(
                                      child: Text(item.tanggal,
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center)),
                                  Center(
                                      child: Text(item.sa.toString(),
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center)),
                                  Center(
                                      child: Text(item.mekanik.toString(),
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center)),
                                  Center(
                                      child: Text(item.hariKerja.toString(),
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center)),
                                  Center(
                                      child: Text(item.rut.toString(),
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center)),
                                ],
                              );
                            }).toList(),
                          ],
                        )
                      : const SizedBox(),
                ),
              ),
              const SizedBox(height: 15),
              ButtonWidget('Upload', _uploadDataExcel, disable: !_proses)
            ],
          ),
        ),
      ),
    );
  }
}
