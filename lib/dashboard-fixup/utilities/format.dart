import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stsj/dashboard-fixup/utilities/utils.dart';

class UpperCaseText extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class Format {
  static String rupiahFormat(String price) {
    if (price != '') {
      List<String> subValue = price.split('.');
      String value = subValue[0];
      if (value.length > 2) {
        value = value.replaceAll(RegExp(r'\D'), '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
      }
      if (subValue.length > 1) {
        if (subValue[1].length > 1) {
          return 'Rp. $value,${subValue[1].substring(0, 2)}';
        } else {
          return 'Rp. $value,${subValue[1].padRight(2, '0')}';
        }
      } else {
        return 'Rp. $value,00';
      }
    }
    return '';
  }

  static String thousandFormat(String digit) {
    if (digit != '') {
      List<String> subValue = digit.split('.');
      String value = subValue[0];
      if (value.isNotEmpty) {
        //GAK PERLU DICEK KARENA KONDISI MINUS
        value = value.replaceAll(RegExp(r'\D'), '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
      }
      if (subValue.length > 1) {
        if (subValue[1].length > 1) {
          return '${subValue[0].substring(0, 1) == '-' ? '-$value' : value},${subValue[1].substring(0, 1)}';
        } else {
          return '${subValue[0].substring(0, 1) == '-' ? '-$value' : value},${subValue[1].padRight(1, '0')}';
        }
      } else {
        return subValue[0].substring(0, 1) == '-' ? '-$value' : value;
      }
    }
    return '';
  }

  static String tanggalFormat(String tanggal) {
    if (tanggal != '') {
      String thn = tanggal.substring(0, 4);
      String bln = tanggal.substring(5, 7);
      String tgl = tanggal.substring(8, 10);
      return tanggal.replaceRange(0, 10, '$tgl-$bln-$thn');
    }
    return '';
  }

  static String kalenderFormat(String tanggal) {
    if (tanggal != '') {
      String thn = tanggal.substring(0, 4);
      String bln = tanggal.substring(5, 7);
      String tgl = tanggal.substring(8, 10);
      return '${DateFormat('EEEE', "id_ID").format(DateTime.parse(tanggal))}, $tgl ${listBulan[int.parse(bln) - 1]} $thn';
    }
    return '';
  }

  static String phoneFormat(String phone) {
    if (phone != '') return '+62$phone';
    return '';
  }
}
