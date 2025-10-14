class DeliveryApprovalModel {
  String transno, employeeid, ename, chasisno, plateno, starttime, enddtime;
  int toko, koli, terkirim, flagapproval;
  double amount, appamount;
  List<DeliveryBiayaModel> detail;

  DeliveryApprovalModel(
      {required this.transno,
      required this.employeeid,
      required this.ename,
      required this.chasisno,
      required this.plateno,
      required this.starttime,
      required this.enddtime,
      required this.toko,
      required this.koli,
      required this.terkirim,
      required this.amount,
      required this.appamount,
      required this.flagapproval,
      required this.detail});

  factory DeliveryApprovalModel.fromJson(Map<String, dynamic> json) {
    return DeliveryApprovalModel(
      transno: json['transNo'],
      employeeid: json['employeeID'],
      ename: json['eName'],
      chasisno: json['chasisNo'],
      plateno: json['plateNo'],
      starttime: json['startTime'],
      enddtime: json['endTime'],
      toko: json['toko'],
      koli: json['koli'],
      terkirim: json['terkirim'],
      amount: json['amount'],
      appamount: json['appAmount'],
      flagapproval: json['flagApproval'],
      detail: List<DeliveryBiayaModel>.from(
          json['detail'].map((x) => DeliveryBiayaModel.fromJson(x))),
    );
  }
}

class DeliveryBiayaModel {
  String expensename, amount, appamount, appby, appbyname;
  int line;

  DeliveryBiayaModel(
      {required this.line,
      required this.expensename,
      required this.amount,
      required this.appamount,
      required this.appby,
      required this.appbyname});

  factory DeliveryBiayaModel.fromJson(Map<String, dynamic> json) {
    return DeliveryBiayaModel(
        line: json['line'],
        expensename: json['expenseName'],
        amount: json['amount'].toString(),
        appamount: json['appAmount'].toString(),
        appby: json['appBy'],
        appbyname: json['appByName']);
  }
}
