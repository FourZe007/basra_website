class ModelPointCalculation {
  String province;
  String area;
  String branch;
  String shopId;
  String shopName;
  String date;
  String actId;
  String actName;
  String employeeId;
  String employeeName;
  int point1;
  int point2;
  int point3;

  ModelPointCalculation({
    required this.province,
    required this.area,
    required this.branch,
    required this.shopId,
    required this.shopName,
    required this.date,
    required this.actId,
    required this.actName,
    required this.employeeId,
    required this.employeeName,
    required this.point1,
    required this.point2,
    required this.point3,
  });

  factory ModelPointCalculation.fromJson(Map<String, dynamic> json) {
    return ModelPointCalculation(
      province: json['bigArea'],
      area: json['smallArea'],
      branch: json['branch'],
      shopId: json['shop'],
      shopName: json['bsName'],
      date: json['currentDate'],
      actId: json['activityID'],
      actName: json['activityName'],
      employeeId: json['employeeID'],
      employeeName: json['eName'],
      point1: json['point1'],
      point2: json['point2'],
      point3: json['point3'],
    );
  }
}
