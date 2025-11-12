class DeliveryMonthlyModel {
  String tanggal;
  String hari;
  int qty;
  int approve;
  int totaltruck;
  double appamount;
  List<DeliveryMonthlyDetailModel> detail;

  DeliveryMonthlyModel(
      {required this.tanggal,
      required this.hari,
      required this.qty,
      required this.approve,
      required this.appamount,
      required this.totaltruck,
      required this.detail});

  factory DeliveryMonthlyModel.fromJson(Map<String, dynamic> json) {
    return DeliveryMonthlyModel(
      tanggal: json['tanggal'],
      hari: json['hari'],
      qty: json['qty'],
      approve: json['approved'],
      appamount: json['appAmount'],
      totaltruck: json['totalTruck'],
      detail: List<DeliveryMonthlyDetailModel>.from(
          json['detail'].map((x) => DeliveryMonthlyDetailModel.fromJson(x))),
    );
  }
}

class DeliveryMonthlyDetailModel {
  String expensename;
  int line;
  double appamountdt;

  DeliveryMonthlyDetailModel(
      {required this.line,
      required this.expensename,
      required this.appamountdt});

  factory DeliveryMonthlyDetailModel.fromJson(Map<String, dynamic> json) {
    return DeliveryMonthlyDetailModel(
        line: json['line'],
        expensename: json['expenseName'],
        appamountdt: json['appAmountDT']);
  }
}
