import 'package:stsj/activity_point/models/point_sm_dt.dart';

class PointSMHD {
  String bigArea;
  String smallArea;
  String branch;
  String shop;
  String bsName;
  String employeeId;
  String eName;
  int targetQty;
  int targetBln;
  int totalPoint;
  double persentase;
  List<PointSMDT> detail;

  PointSMHD({
    required this.bigArea,
    required this.smallArea,
    required this.branch,
    required this.shop,
    required this.bsName,
    required this.employeeId,
    required this.eName,
    required this.targetQty,
    required this.targetBln,
    required this.totalPoint,
    required this.persentase,
    required this.detail,
  });

  factory PointSMHD.fromJson(Map<String, dynamic> json) {
    return PointSMHD(
      bigArea: json['bigArea'],
      smallArea: json['smallArea'],
      branch: json['branch'],
      shop: json['shop'],
      bsName: json['bsName'],
      employeeId: json['employeeID'],
      eName: json['eName'],
      targetQty: json['targetQty'],
      targetBln: json['targetQty1Bulan'],
      totalPoint: json['totaPoint'],
      persentase: json['persentase'],
      detail: (json['detail'] as List).map<PointSMDT>((x) => PointSMDT.fromJson(x)).toList(),
    );
  }
}
