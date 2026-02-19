class ModelManagerActivities {
  int urutan;
  String province;
  String area;
  String branch;
  String shop;
  String bsName;
  String actGroupId;
  String actId;
  String actName;
  String employeeId;
  String eName;
  String actDesc;
  String currentDate;
  String currentTime;
  double lat;
  double lng;
  String picThumb;
  String startTime;
  String endTime;
  int flag;
  int point1Hitung;
  int point2Hitung;
  int point3Hitung;
  int point1Final;
  int point2Final;
  int point3Final;

  ModelManagerActivities({
    required this.urutan,
    required this.province,
    required this.area,
    required this.branch,
    required this.shop,
    required this.bsName,
    required this.actGroupId,
    required this.actId,
    required this.actName,
    required this.employeeId,
    required this.eName,
    required this.actDesc,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.picThumb,
    required this.startTime,
    required this.endTime,
    required this.flag,
    required this.point1Hitung,
    required this.point2Hitung,
    required this.point3Hitung,
    required this.point1Final,
    required this.point2Final,
    required this.point3Final,
  });

  factory ModelManagerActivities.fromJson(Map<String, dynamic> json) {
    return ModelManagerActivities(
      urutan: json['urutan'],
      province: json['bigArea'],
      area: json['smallArea'],
      branch: json['branch'],
      shop: json['shop'],
      bsName: json['bsName'],
      actGroupId: json['activityGroupID'],
      actId: json['activityID'],
      actName: json['activityName'],
      employeeId: json['employeeID'],
      eName: json['eName'],
      actDesc: json['activityDescription'],
      currentDate: json['currentDate'],
      currentTime: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      picThumb: json['pic1Thumb'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      flag: json['flag'],
      point1Hitung: json['point1Hitung'],
      point2Hitung: json['point2Hitung'],
      point3Hitung: json['point3Hitung'],
      point1Final: json['point1Final'],
      point2Final: json['point2Final'],
      point3Final: json['point3Final'],
    );
  }
}
