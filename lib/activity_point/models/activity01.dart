import 'package:stsj/activity_point/models/activity.dart';

class Activity01 extends Activity {
  String bsName;
  String area;
  String currentDate;
  String currentTime;
  double lat;
  double lng;
  String jenisAktivitas;
  String lokasi;
  int salesman;
  String unitDisplay;
  int database;
  int hotprospek;
  int deal;
  String unitTestRide;
  int pesertaTestRide;
  String picThumb;
  String employeeId;
  String eName;

  Activity01({
    required this.bsName,
    required this.area,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.jenisAktivitas,
    required this.lokasi,
    required this.salesman,
    required this.unitDisplay,
    required this.database,
    required this.hotprospek,
    required this.deal,
    required this.unitTestRide,
    required this.pesertaTestRide,
    required this.picThumb,
    required this.employeeId,
    required this.eName,
  });

  factory Activity01.fromJson(Map<String, dynamic> json) {
    return Activity01(
      bsName: json['bsName'],
      area: json['area'],
      currentDate: json['currentDate'],
      currentTime: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      jenisAktivitas: json['jenisAktivitas'],
      lokasi: json['lokasi'],
      salesman: json['salesman'],
      unitDisplay: json['unitDisplay'],
      database: json['database'],
      hotprospek: json['hotProspek'],
      deal: json['deal'],
      unitTestRide: json['unitTestRide'],
      pesertaTestRide: json['pesertaTestRide'],
      picThumb: json['pic1Thumb'],
      employeeId: json['employeeID'],
      eName: json['eName'],
    );
  }
}
