class Listmedia {
  int line;
  int mediaCode;
  String mediaName;
  int qty;

  Listmedia({
    required this.line,
    required this.mediaCode,
    required this.mediaName,
    required this.qty,
  });

  factory Listmedia.fromJson(Map<String, dynamic> json) {
    return Listmedia(
      line: json['line'],
      mediaCode: json['mediaCode'],
      mediaName: json['mediaName'],
      qty: json['qty'],
    );
  }
}
