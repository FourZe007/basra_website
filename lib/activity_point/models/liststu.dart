class ListSTU {
  int line;
  String category;
  int target;
  int tm;
  double acv;
  int lm;
  double growth;

  ListSTU({
    required this.line,
    required this.category,
    required this.target,
    required this.tm,
    required this.acv,
    required this.lm,
    required this.growth,
  });

  factory ListSTU.fromJson(Map<String, dynamic> json) {
    return ListSTU(
      line: json['line'],
      category: json['category'],
      target: json['target'],
      tm: json['tm'],
      acv: json['acv'],
      lm: json['lm'],
      growth: json['growth'],
    );
  }
}
