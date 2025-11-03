class DeliveryMonthlyModel {
  String tanggal;
  String hari;
  int qty;
  int approve;

  DeliveryMonthlyModel(
      {required this.tanggal,
      required this.hari,
      required this.qty,
      required this.approve});

  factory DeliveryMonthlyModel.fromJson(Map<String, dynamic> json) {
    return DeliveryMonthlyModel(
        tanggal: json['tanggal'],
        hari: json['hari'],
        qty: json['qty'],
        approve: json['approved']);
  }
}
