class PointSMDT {
  String currentDate;
  String activityId;
  String activityName;
  int targetHari;
  int point1;
  int point2;
  int point3;

  PointSMDT({
    required this.currentDate,
    required this.activityId,
    required this.activityName,
    required this.targetHari,
    required this.point1,
    required this.point2,
    required this.point3,
  });

  factory PointSMDT.fromJson(Map<String, dynamic> json) {
    return PointSMDT(
      currentDate: json['currentDate'],
      activityId: json['activityID'],
      activityName: json['activityName'],
      targetHari: json['targetQty'],
      point1: json['point1'],
      point2: json['point2'],
      point3: json['point3'],
    );
  }
}
