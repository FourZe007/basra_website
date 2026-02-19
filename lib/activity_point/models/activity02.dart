import 'package:stsj/activity_point/models/activity.dart';

class Activity02 extends Activity {
  String bsName;
  String area;
  String currentDate;
  String currentTime;
  double lat;
  double lng;
  String picTumb;
  String employeeId;
  String eName;
  String media;
  String posisi;

  Activity02({
    required this.bsName,
    required this.area,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.picTumb,
    required this.employeeId,
    required this.eName,
    required this.media,
    required this.posisi,
  });

  factory Activity02.fromJson(Map<String, dynamic> json) {
    return Activity02(
      bsName: json['bsName'],
      area: json['area'],
      currentDate: json['currentDate'],
      currentTime: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      picTumb: json['pic1Thumb'],
      employeeId: json['employeeID'],
      eName: json['eName'],
      media: json['media'],
      posisi: json['posisi'],
    );
  }
}
