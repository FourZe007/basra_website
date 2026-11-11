class Format {
  static String tanggalFormat(String tanggal) {
    String thn = tanggal.substring(0, 4);
    String bln = tanggal.substring(5, 7);
    String tgl = tanggal.substring(8, 10);
    return tanggal.replaceRange(0, 10, '$tgl-$bln-$thn');
  }
}
