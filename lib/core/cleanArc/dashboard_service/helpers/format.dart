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

  static String moneyFormat(String price) {
    if (price != '') {
      List<String> subValue = price.split('.');
      String value = subValue[0];
      if (value.length > 2) {
        value = value.replaceAll(RegExp(r'\D'), '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
      }
      if (subValue.length > 1) {
        if (subValue[1].length > 1) {
          return '$value,${subValue[1].substring(0, 2)}';
        } else {
          return '$value,${subValue[1].padRight(2, '0')}';
        }
      } else {
        return '$value,00';
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

  static String dateFormat(String tanggal) {
    if (tanggal != '') {
      String tgl = tanggal.substring(0, 2);
      String bln = tanggal.substring(3, 5);
      String thn = tanggal.substring(6, 10);
      return tanggal.replaceRange(0, 10, '$thn-$bln-$tgl');
    }
    return '';
  }

  static String phoneFormat(String phone) {
    if (phone != '') return '+62$phone';
    return '';
  }

  static String thousandFormat(String digit) {
    if (digit != '') {
      List<String> subValue = digit.split('.');
      String value = subValue[0];
      if (value.length > 2) {
        value = value.replaceAll(RegExp(r'\D'), '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
      }
      if (subValue.length > 1) {
        if (subValue[1].length > 1) {
          return '$value,${subValue[1].substring(0, 2)}';
        } else {
          return '$value,${subValue[1].padRight(2, '0')}';
        }
      } else {
        return value;
      }
    }
    return '';
  }
}
