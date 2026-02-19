class ListPayment {
  int line;
  String payment;
  int tm;
  int lm;
  double growth;

  ListPayment({
    required this.line,
    required this.payment,
    required this.tm,
    required this.lm,
    required this.growth,
  });

  factory ListPayment.fromJson(Map<String, dynamic> json) {
    return ListPayment(
      line: json['line'],
      payment: json['payment'],
      tm: json['tm'],
      lm: json['lm'],
      growth: json['growth'],
    );
  }
}
