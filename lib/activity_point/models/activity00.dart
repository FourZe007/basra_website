import 'package:stsj/activity_point/models/activity.dart';

class Activity00 extends Activity {
  String bsName;
  String area;
  String currentDate;
  String currentTime;
  double lat;
  double lng;
  String lokasi;
  String topic;
  String picThumb;
  String employeeId;
  String eName;
  int peserta;
  int shopManager;
  int salesCounter;
  int salesman;
  int other;
  List<dynamic> detail;

  Activity00({
    required this.bsName,
    required this.area,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.lokasi,
    required this.topic,
    required this.picThumb,
    required this.employeeId,
    required this.eName,
    required this.peserta,
    required this.shopManager,
    required this.salesCounter,
    required this.salesman,
    required this.other,
    required this.detail,
  });

  factory Activity00.fromJson(Map<String, dynamic> json) {
    return Activity00(
      bsName: json['bsName'],
      area: json['area'],
      currentDate: json['currentDate'],
      currentTime: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      lokasi: json['lokasi'],
      topic: json['topic'],
      picThumb: json['pic1Thumb'],
      employeeId: json['employeeID'],
      eName: json['eName'],
      peserta: json['peserta'],
      shopManager: json['shopManager'],
      salesCounter: json['salesCounter'],
      salesman: json['salesman'],
      other: json['others'],
      detail: json['detail'] as List<dynamic>,
    );
  }
}
