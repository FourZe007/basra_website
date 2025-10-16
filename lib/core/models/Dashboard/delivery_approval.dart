class DeliveryApprovalModel {
  String transno, employeeid, ename, chasisno, plateno, starttime, enddtime;
  int totalkoli, totalterkirim, totaltoko, totaltokoterkirim, flagapproval;
  double amount, appamount, persenterkirim, persentasetokoterkirim;
  bool waitApprove;
  List<DeliveryBiayaModel> detail;

  DeliveryApprovalModel(
      {required this.transno,
      required this.employeeid,
      required this.ename,
      required this.chasisno,
      required this.plateno,
      required this.starttime,
      required this.enddtime,
      required this.amount,
      required this.appamount,
      required this.flagapproval,
      required this.totalkoli,
      required this.totalterkirim,
      required this.persenterkirim,
      required this.totaltoko,
      required this.totaltokoterkirim,
      required this.persentasetokoterkirim,
      required this.waitApprove,
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
      amount: json['amount'],
      appamount: json['appAmount'],
      flagapproval: json['flagApproval'],
      totalkoli: json['totalKoli'],
      totalterkirim: json['totalTerkirim'],
      persenterkirim: json['persenTerkirim'],
      totaltoko: json['totalToko'],
      totaltokoterkirim: json['totalTokoTerkirim'],
      persentasetokoterkirim: json['persenTokoTerkirim'],
      waitApprove: false,
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
