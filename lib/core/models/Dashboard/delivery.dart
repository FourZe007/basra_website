class DeliveryModel {
  String employeeId;
  String employeeName;
  String chasisNumber;
  String plateNumber;
  String imeiNumber;
  String drivingLicense;
  String activityNumber;
  String startTime;
  String startImageThumb;
  String startKm;
  String endTime;
  String endImageThumb;
  String endKm;
  int flagApproval;
  int totalkoli;
  int totaltekirim;
  int persenterkirim;
  List<CheckListDetailsModel> deliveryDetail;
  List<RincianBiayaModel> rincianBiayaDetail;

  DeliveryModel(
      {required this.employeeId,
      required this.employeeName,
      required this.chasisNumber,
      required this.plateNumber,
      required this.imeiNumber,
      required this.drivingLicense,
      required this.activityNumber,
      required this.startTime,
      required this.startImageThumb,
      required this.startKm,
      required this.endTime,
      required this.endImageThumb,
      required this.deliveryDetail,
      required this.endKm,
      required this.flagApproval,
      required this.totalkoli,
      required this.totaltekirim,
      required this.persenterkirim,
      required this.rincianBiayaDetail});

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
        employeeId: json['employeeID'],
        employeeName: json['eName'],
        chasisNumber: json['chasisNo'],
        plateNumber: json['plateNo'],
        imeiNumber: json['imei'],
        drivingLicense: json['simCard'],
        activityNumber: json['activityNo'],
        startTime: json['startTime'],
        startImageThumb: json['startImageThumb'],
        startKm: json['startKm'],
        endTime: json['endTime'],
        endImageThumb: json['endImageThumb'],
        endKm: json['endKm'],
        flagApproval: json['flagApproval'],
        totalkoli: json['totalKoli'],
        totaltekirim: json['totalTerkirim'],
        persenterkirim: json['persenTerkirim'],
        deliveryDetail: List<CheckListDetailsModel>.from(
            json['detail'].map((x) => CheckListDetailsModel.fromJson(x))),
        rincianBiayaDetail: List<RincianBiayaModel>.from(
            json['detailE'].map((x) => RincianBiayaModel.fromJson(x))));
  }
}

class CheckListDetailsModel {
  String transNumber;
  String customerId;
  String customerName;
  String shippingAddress;
  String shippingCity;
  double lat;
  double lng;
  int qtyNota;
  int koli;
  int deliveryStatus;
  String deliveryTime;
  String deliveryImageThumb;
  String deliveryNote;
  double deliveryLat;
  double deliveryLng;
  double line;
  double deliveryOrder;

  CheckListDetailsModel({
    required this.transNumber,
    required this.customerId,
    required this.customerName,
    required this.shippingAddress,
    required this.shippingCity,
    required this.lat,
    required this.lng,
    required this.qtyNota,
    required this.koli,
    required this.deliveryStatus,
    required this.deliveryTime,
    required this.deliveryImageThumb,
    required this.deliveryNote,
    required this.deliveryLat,
    required this.deliveryLng,
    required this.line,
    required this.deliveryOrder,
  });

  factory CheckListDetailsModel.fromJson(Map<String, dynamic> json) {
    return CheckListDetailsModel(
      transNumber: json['transNo'],
      customerId: json['customerID'],
      customerName: json['cName'],
      shippingAddress: json['cShippingAddress'],
      shippingCity: json['cShippingCity'],
      lat: json['lat'],
      lng: json['lng'],
      qtyNota: json['qtyNota'],
      koli: json['koli'],
      deliveryStatus: json['deliveryStatus'],
      deliveryTime: json['deliveryTime'],
      deliveryImageThumb: json['deliveryImageThumb'],
      deliveryNote: json['deliveryNote'],
      deliveryLat: json['deliveryLat'],
      deliveryLng: json['deliveryLng'],
      line: json['line'],
      deliveryOrder: json['urutanDelivery'],
    );
  }
}

class RincianBiayaModel {
  String expensename, appby, appbyname, amount, appamount;
  int line;

  RincianBiayaModel(
      {required this.line,
      required this.expensename,
      required this.amount,
      required this.appamount,
      required this.appby,
      required this.appbyname});

  factory RincianBiayaModel.fromJson(Map<String, dynamic> json) {
    return RincianBiayaModel(
        line: json['line'],
        expensename: json['expenseName'],
        amount: json['amount'].toString(),
        appamount: json['appAmount'].toString(),
        appby: json['appBy'] ?? '',
        appbyname: json['appByName'] ?? '');
  }
}
