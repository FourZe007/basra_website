import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/alokasi-bm/helper/api_alokasi_bm.dart';
import 'package:stsj/alokasi-bm/helper/model_alokasi_bm.dart';
import 'package:stsj/alokasi-bm/pages/p_koreksi_alokasi_bm.dart';
import 'package:stsj/alokasi-bm/widget/w_alertdialog_info.dart';
import 'package:stsj/alokasi-bm/widget/w_input_number.dart';
import 'package:stsj/alokasi-bm/widget/w_input_search.dart';
import 'package:stsj/alokasi-bm/widget/w_tombol_panjang_ikon.dart';
import 'package:stsj/global/font.dart';

class PKoreksiAlokasiBMDetail extends StatefulWidget {
  const PKoreksiAlokasiBMDetail(this.tanggal, this.loadData, {super.key});
  final DateTime tanggal;
  final Function loadData;

  @override
  State<PKoreksiAlokasiBMDetail> createState() => _MyPageState();
}

class _MyPageState extends State<PKoreksiAlokasiBMDetail> {
  int idxAwal = 0,
      idxAkhir = 0,
      totalFSN1 = 0,
      totalNota110 = 0,
      totalOther = 0,
      totalSisaStok = 0,
      totalFSBCity = 0,
      totalFSBOut = 0,
      totalFSBNTT = 0,
      totalFSCity = 0,
      totalFSOut = 0,
      totalFSNTT = 0,
      totalBisaBagi = 0,
      page = 1;
  bool waitAPI = false;
  List<ModelBrowseAlokasi> filter = [];
  List<ModelBrowseAlokasi> filterSearch = [];
  TextEditingController searchController = TextEditingController();

  Widget wContentTabel(String value, int jenis, Alignment posisi) {
    return Container(
      alignment: posisi,
      padding: const EdgeInsets.all(10),
      child: Text(value,
          style: jenis == 0
              ? GlobalFont.mediumbigfontMWhiteBold
              : jenis == 1
                  ? GlobalFont.smallfontR
                  : GlobalFont.mediumbigfontMBold),
    );
  }

  TableRow detailRow(ModelBrowseAlokasi e) {
    var index = daftarAlokasi
        .indexWhere((x) => x.unitid == e.unitid && x.color == e.color);

    void setADJCity(dynamic value) {
      e.freestokADJ1 = TextEditingController(text: value);
    }

    void setADJOut(dynamic value) {
      e.freestokADJ2 = TextEditingController(text: value);
    }

    void setADJNTT(dynamic value) {
      e.freestokADJ3 = TextEditingController(text: value);
    }

    return TableRow(
        decoration: BoxDecoration(
            color: (e.freestok1 < 0 || e.freestok2 < 0 || e.freestok3 < 0)
                ? Colors.red[100]
                : index % 2 == 0
                    ? Colors.blueGrey[100]
                    : Colors.blueGrey[50]),
        children: [
          wContentTabel(e.unitid, 1, Alignment.centerLeft),
          wContentTabel(e.colorname, 1, Alignment.centerLeft),
          wContentTabel(e.fsn1.toString(), 1, Alignment.centerRight),
          wContentTabel(e.nota110.toString(), 1, Alignment.centerRight),
          wContentTabel(e.other.toString(), 1, Alignment.centerRight),
          wContentTabel(e.sisastok.toString(), 1, Alignment.centerRight),
          wContentTabel(e.freestokbagi1.toString(), 1, Alignment.centerRight),
          wContentTabel(e.freestokbagi2.toString(), 1, Alignment.centerRight),
          wContentTabel(e.freestokbagi3.toString(), 1, Alignment.centerRight),
          wContentTabel(e.freestok1.toString(), 1, Alignment.centerRight),
          wContentTabel(e.freestok2.toString(), 1, Alignment.centerRight),
          wContentTabel(e.freestok3.toString(), 1, Alignment.centerRight),
          wContentTabel(
              e.freestokbisabagi.toString(), 1, Alignment.centerRight),
          WInputNumber('', e.freestokADJ1, setADJCity),
          WInputNumber('', e.freestokADJ2, setADJOut),
          WInputNumber('', e.freestokADJ3, setADJNTT),
        ]);
  }

  void generatedPage(int mode, halaman, List<ModelBrowseAlokasi> list) {
    filter = [];
    page = halaman;
    idxAwal = mode == 0 ? 0 : (page * 10) - 10;
    idxAkhir = (page * 10) > list.length ? list.length : (page * 10);
    filter.addAll(list.sublist(idxAwal, idxAkhir));
  }

  void prevPage(List<ModelBrowseAlokasi> list) {
    if (page != 1) generatedPage(1, page -= 1, list);
  }

  void nextPage(List<ModelBrowseAlokasi> list) {
    if ((page * 10) <= list.length) generatedPage(1, page += 1, list);
  }

  void calculateGrandTotal() {
    totalFSN1 = daftarAlokasi.fold(0, (before, after) => before + after.fsn1);
    totalNota110 = daftarAlokasi.fold(0, (x, y) => x + y.nota110);
    totalOther = daftarAlokasi.fold(0, (x, y) => x + y.other);
    totalSisaStok = daftarAlokasi.fold(0, (x, y) => x + y.sisastok);
    totalFSBCity = daftarAlokasi.fold(0, (x, y) => x + y.freestokbagi1);
    totalFSBOut = daftarAlokasi.fold(0, (x, y) => x + y.freestokbagi2);
    totalFSBNTT = daftarAlokasi.fold(0, (x, y) => x + y.freestokbagi3);
    totalFSCity = daftarAlokasi.fold(0, (x, y) => x + y.freestok1);
    totalFSOut = daftarAlokasi.fold(0, (x, y) => x + y.freestok2);
    totalFSNTT = daftarAlokasi.fold(0, (x, y) => x + y.freestok3);
    totalBisaBagi = daftarAlokasi.fold(0, (x, y) => x + y.freestokbisabagi);
  }

  void setSearch(dynamic value) {
    var list = daftarAlokasi.where((x) => x.itemname.contains(value)).toList();
    if (list.isEmpty) {
      wAlertDialogInfo(context, 'INFORMASI', 'Data Tidak Di Temukan');
    } else {
      filterSearch = [];
      filterSearch.addAll(list);
      setState(() => generatedPage(0, 1, filterSearch));
    }
  }

  void simpan() async {
    setState(() => waitAPI = true);

    List<Map> detail = [];
    for (var x in daftarAlokasi) {
      if (x.freestokADJ1.text != '0' ||
          x.freestokADJ2.text != '0' ||
          x.freestokADJ3.text != '0') {
        var fsBagi = x.freestokbagi1 + x.freestokbagi2 + x.freestokbagi3;

        var fsADJ = int.parse(x.freestokADJ1.text) +
            int.parse(x.freestokADJ2.text) +
            int.parse(x.freestokADJ3.text);

        var sisaBagi =
            (x.freestokbisabagi - fsADJ) < 0 ? 0 : (x.freestokbisabagi - fsADJ);

        ((fsBagi + fsADJ) + sisaBagi) > (x.sisastok + x.nota110)
            ? x.isvalid = false
            : x.isvalid = true;
      }

      if (x.isvalid) {
        detail.add({
          'UnitID': x.unitid,
          'Color': x.color,
          'Qty1': x.freestokADJ1.text,
          'Qty2': x.freestokADJ2.text,
          'Qty3': x.freestokADJ3.text
        });
      }
    }

    var list = daftarAlokasi.where((x) => x.isvalid == false).toList();

    if (list.isNotEmpty) {
      setState(() => waitAPI = false);
      wAlertDialogInfo(context, 'INFORMASI', 'Inputan Melebihi Sisa Stok');
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userid = prefs.getString('UserID') ?? '';

      var list = await ApiAlokasiBM.revisiAlokasiBM(
          '51', widget.tanggal.toString().substring(0, 10), userid, detail);

      if (msg == 'Sukses') {
        widget.loadData();
        calculateGrandTotal();
        if (!mounted) return;
        wAlertDialogInfo(context, 'INFORMASI', list[0].resultmessage);
      } else {
        if (!mounted) return;
        wAlertDialogInfo(context, 'INFORMASI', 'Data Gagal Di Simpan');
      }

      setState(() => waitAPI = false);
    }
  }

  void reset() => setState(() {
        for (var data in daftarAlokasi) {
          data.freestokADJ1.text = '0';
          data.freestokADJ2.text = '0';
          data.freestokADJ3.text = '0';
          data.isvalid = true;
        }
      });

  @override
  void initState() {
    super.initState();
    if (daftarAlokasi.isNotEmpty) {
      calculateGrandTotal();
      generatedPage(0, 1, daftarAlokasi);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (waitAPI) {
      return Center(child: SpinKitDualRing(color: Colors.blue[900]!));
    } else {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
            onPressed: () => setState(() => prevPage(
                searchController.text == '' ? daftarAlokasi : filterSearch)),
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_circle_left,
                color: Colors.blue[900]!, size: 30),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                  '${idxAwal + 1} - $idxAkhir Of ${searchController.text == '' ? daftarAlokasi.length : filterSearch.length}',
                  textAlign: TextAlign.center,
                  style: GlobalFont.bigfontMBold),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => nextPage(
                searchController.text == '' ? daftarAlokasi : filterSearch)),
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_circle_right,
                color: Colors.blue[900], size: 30),
          )
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Row(children: [
            Expanded(flex: 8, child: WInputSearch(searchController, setSearch)),
            Expanded(
                flex: 1,
                child: WTombolPanjangIkon('SIMPAN', Icons.save, Colors.white,
                    Colors.green[900]!, simpan)),
            SizedBox(width: 5),
            Expanded(
                flex: 1,
                child: WTombolPanjangIkon('RESET', Icons.refresh, Colors.white,
                    Colors.red[900]!, reset)),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Table(
                border: TableBorder.all(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(0.7),
                  2: FlexColumnWidth(0.6),
                  3: FlexColumnWidth(0.6),
                  4: FlexColumnWidth(0.6),
                  5: FlexColumnWidth(0.6),
                  6: FlexColumnWidth(0.6),
                  7: FlexColumnWidth(0.6),
                  8: FlexColumnWidth(0.6),
                  9: FlexColumnWidth(0.6),
                  10: FlexColumnWidth(0.6),
                  11: FlexColumnWidth(0.6),
                  12: FlexColumnWidth(0.6),
                  13: FlexColumnWidth(0.4),
                  14: FlexColumnWidth(0.4),
                  15: FlexColumnWidth(0.4),
                },
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      children: [
                        wContentTabel('KODE BARANG', 0, Alignment.centerLeft),
                        wContentTabel('WARNA', 0, Alignment.centerLeft),
                        wContentTabel('FS N-1', 0, Alignment.centerRight),
                        wContentTabel('NOTA 1-10', 0, Alignment.centerRight),
                        wContentTabel('OTHER', 0, Alignment.centerRight),
                        wContentTabel('SISA STOK', 0, Alignment.centerRight),
                        wContentTabel('FS B CITY', 0, Alignment.centerRight),
                        wContentTabel('FS B OUT', 0, Alignment.centerRight),
                        wContentTabel('FS B NTT', 0, Alignment.centerRight),
                        wContentTabel('FS CITY', 0, Alignment.centerRight),
                        wContentTabel('FS OUT', 0, Alignment.centerRight),
                        wContentTabel('FS NTT', 0, Alignment.centerRight),
                        wContentTabel('BISA BAGI', 0, Alignment.centerRight),
                        wContentTabel('', 0, Alignment.centerRight),
                        wContentTabel('', 0, Alignment.centerRight),
                        wContentTabel('', 0, Alignment.centerRight)
                      ]),
                  TableRow(
                      decoration: BoxDecoration(color: Colors.blue[100]),
                      children: [
                        wContentTabel('GRAND TOTAL', 2, Alignment.centerLeft),
                        wContentTabel('', 2, Alignment.centerLeft),
                        wContentTabel(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'id', symbol: '')
                                .format(totalFSN1),
                            2,
                            Alignment.centerRight),
                        wContentTabel(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'id', symbol: '')
                                .format(totalNota110),
                            2,
                            Alignment.centerRight),
                        wContentTabel(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'id', symbol: '')
                                .format(totalOther),
                            2,
                            Alignment.centerRight),
                        wContentTabel(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'id', symbol: '')
                                .format(totalSisaStok),
                            2,
                            Alignment.centerRight),
                        wContentTabel(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'id', symbol: '')
                                .format(totalFSBCity),
                            2,
                            Alignment.centerRight),
                        wContentTabel(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'id', symbol: '')
                                .format(totalFSBOut),
                            2,
                            Alignment.centerRight),
                        wContentTabel(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'id', symbol: '')
                                .format(totalFSBNTT),
                            2,
                            Alignment.centerRight),
                        wContentTabel(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'id', symbol: '')
                                .format(totalFSCity),
                            2,
                            Alignment.centerRight),
                        wContentTabel(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'id', symbol: '')
                                .format(totalFSOut),
                            2,
                            Alignment.centerRight),
                        wContentTabel(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'id', symbol: '')
                                .format(totalFSNTT),
                            2,
                            Alignment.centerRight),
                        wContentTabel(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'id', symbol: '')
                                .format(totalBisaBagi),
                            2,
                            Alignment.centerRight),
                        wContentTabel('', 2, Alignment.centerRight),
                        wContentTabel('', 2, Alignment.centerRight),
                        wContentTabel('', 2, Alignment.centerRight)
                      ]),
                  ...filter.map((e) => detailRow(e)),
                ]),
          )),
        )
      ]);
    }
  }
}
