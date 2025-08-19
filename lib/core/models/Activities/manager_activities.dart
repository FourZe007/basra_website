class ModelManagerActivities {
  String province;
  String area;
  String branch;
  String shopId;
  String shopName;
  String actId;
  String actName;
  String employeeId;
  String employeeName;
  String actDesc;
  String currentTime;
  double lat;
  double lng;
  String image;
  String imageThumb;
  int isLate;

  ModelManagerActivities({
    required this.province,
    required this.area,
    required this.branch,
    required this.shopId,
    required this.shopName,
    required this.actId,
    required this.actName,
    required this.employeeId,
    required this.employeeName,
    required this.actDesc,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.image,
    required this.imageThumb,
    required this.isLate,
  });

  factory ModelManagerActivities.fromJson(Map<String, dynamic> json) {
    return ModelManagerActivities(
      province: json['bigArea'],
      area: json['smallArea'],
      branch: json['branch'],
      shopId: json['shop'],
      shopName: json['bsName'],
      actId: json['activityID'],
      actName: json['activityName'],
      employeeId: json['employeeID'],
      employeeName: json['eName'],
      actDesc: json['activityDescription'],
      currentTime: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      image: json['pic1'],
      imageThumb: json['pic1Thumb'],
      isLate: json['flag'],
    );
  }
}
