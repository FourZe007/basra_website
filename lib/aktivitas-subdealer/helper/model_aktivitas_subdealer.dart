class ModelWilayah {
  String smallarea;

  ModelWilayah({required this.smallarea});

  factory ModelWilayah.fromJson(Map<String, dynamic> json) {
    return ModelWilayah(smallarea: json['smallArea']);
  }
}

class ModelProvinsi {
  String bigarea;

  ModelProvinsi({required this.bigarea});

  factory ModelProvinsi.fromJson(Map<String, dynamic> json) {
    return ModelProvinsi(bigarea: json['bigArea']);
  }
}

class ModelSDActivityReport {
  String bigArea, smallArea, customerID, cName;
  int urutan;
  List<ModelSDMorningBriefing> morningBriefing;
  List<ModelSDDailyReport> dailyReport;

  ModelSDActivityReport(
      {required this.urutan,
      required this.bigArea,
      required this.smallArea,
      required this.customerID,
      required this.cName,
      required this.morningBriefing,
      required this.dailyReport});

  factory ModelSDActivityReport.fromJson(Map<String, dynamic> json) {
    return ModelSDActivityReport(
      urutan: json['Urutan'],
      bigArea: json['BigArea'],
      smallArea: json['SmallArea'],
      customerID: json['CustomerID'],
      cName: json['CName'],
      morningBriefing: (json['MorningBriefing'] as List)
          .map((data) => ModelSDMorningBriefing.fromJson(data))
          .toList(),
      dailyReport: (json['DailyReport'] as List)
          .map((data) => ModelSDDailyReport.fromJson(data))
          .toList(),
    );
  }
}

class ModelSDMorningBriefing {
  String lokasi, topic;
  int peserta, sm, sc, salesman, other;

  ModelSDMorningBriefing(
      {required this.lokasi,
      required this.peserta,
      required this.sm,
      required this.sc,
      required this.salesman,
      required this.other,
      required this.topic});

  factory ModelSDMorningBriefing.fromJson(Map<String, dynamic> json) {
    return ModelSDMorningBriefing(
        lokasi: json['Lokasi'],
        peserta: json['Peserta'],
        sm: json['SM'],
        sc: json['SC'],
        salesman: json['Salesman'],
        other: json['Other'],
        topic: json['Topic']);
  }
}

class ModelSDDailyReport {
  String pic;
  List<ModelSDDataPayment> dataPayment;
  List<ModelSDDataSalesman> dataSalesman;
  List<ModelSDDataSTU> dataSTU;
  List<ModelSDDataLeasing> dataLeasing;

  ModelSDDailyReport(
      {required this.pic,
      required this.dataPayment,
      required this.dataSalesman,
      required this.dataSTU,
      required this.dataLeasing});

  factory ModelSDDailyReport.fromJson(Map<String, dynamic> json) {
    return ModelSDDailyReport(
      pic: json['PIC'],
      dataPayment: (json['DataPayment'] as List)
          .map((data) => ModelSDDataPayment.fromJson(data))
          .toList(),
      dataSalesman: (json['DataSalesman'] as List)
          .map((data) => ModelSDDataSalesman.fromJson(data))
          .toList(),
      dataSTU: (json['DataSTU'] as List)
          .map((data) => ModelSDDataSTU.fromJson(data))
          .toList(),
      dataLeasing: (json['DataLeasing'] as List)
          .map((data) => ModelSDDataLeasing.fromJson(data))
          .toList(),
    );
  }
}

class ModelSDDataPayment {
  String payment;
  int resultPayment, lmPayment, linePayment;
  double growthPayment;

  ModelSDDataPayment(
      {required this.payment,
      required this.resultPayment,
      required this.lmPayment,
      required this.growthPayment,
      required this.linePayment});

  factory ModelSDDataPayment.fromJson(Map<String, dynamic> json) {
    return ModelSDDataPayment(
      payment: json['Payment'],
      resultPayment: json['ResultPayment'],
      lmPayment: json['LMPayment'],
      growthPayment: json['GrowthPayment'],
      linePayment: json['LinePayment'],
    );
  }
}

class ModelSDDataSalesman {
  String ktp, sname, statusSM;
  int spk, stu, stuLM, lineSalesman;

  ModelSDDataSalesman(
      {required this.ktp,
      required this.sname,
      required this.statusSM,
      required this.spk,
      required this.stu,
      required this.stuLM,
      required this.lineSalesman});

  factory ModelSDDataSalesman.fromJson(Map<String, dynamic> json) {
    return ModelSDDataSalesman(
        ktp: json['KTP'],
        sname: json['SName'],
        statusSM: json['StatusSM'],
        spk: json['SPK'],
        stu: json['STU'],
        stuLM: json['STULM'],
        lineSalesman: json['LineSalesman']);
  }
}

class ModelSDDataSTU {
  String motorGroup;
  int resultSTU, targetSTU, lmSTU, lineSTU;
  double achSTU, growthSTU;

  ModelSDDataSTU(
      {required this.motorGroup,
      required this.resultSTU,
      required this.targetSTU,
      required this.achSTU,
      required this.lmSTU,
      required this.lineSTU,
      required this.growthSTU});

  factory ModelSDDataSTU.fromJson(Map<String, dynamic> json) {
    return ModelSDDataSTU(
        motorGroup: json['MotorGroup'],
        resultSTU: json['ResultSTU'],
        targetSTU: json['TargetSTU'],
        achSTU: json['AchSTU'],
        lmSTU: json['LMSTU'],
        lineSTU: json['LineSTU'],
        growthSTU: json['GrowthSTU']);
  }
}

class ModelSDDataLeasing {
  String leasing;
  int totalSPK, openSPK, approvedSPK, rejectedSPK, lineLeasing;
  double approval;

  ModelSDDataLeasing(
      {required this.leasing,
      required this.totalSPK,
      required this.openSPK,
      required this.approvedSPK,
      required this.rejectedSPK,
      required this.approval,
      required this.lineLeasing});

  factory ModelSDDataLeasing.fromJson(Map<String, dynamic> json) {
    return ModelSDDataLeasing(
        leasing: json['Leasing'],
        totalSPK: json['TotalSPK'],
        openSPK: json['OpenSPK'],
        approvedSPK: json['ApprovedSPK'],
        rejectedSPK: json['RejectedSPK'],
        approval: json['Approval'],
        lineLeasing: json['LineLeasing']);
  }
}
