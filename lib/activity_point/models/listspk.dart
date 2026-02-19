class ListSPK {
  int line;
  String leasingId;
  int total;
  int terbuka;
  int disetujui;
  int ditolak;
  double persentase;

  ListSPK({
    required this.line,
    required this.leasingId,
    required this.total,
    required this.terbuka,
    required this.disetujui,
    required this.ditolak,
    required this.persentase,
  });

  factory ListSPK.fromJson(Map<String, dynamic> json) {
    return ListSPK(
      line: json['line'],
      leasingId: json['leasingID'],
      total: json['total'],
      terbuka: json['terbuka'],
      disetujui: json['disetujui'],
      ditolak: json['ditolak'],
      persentase: json['persentase'],
    );
  }
}
