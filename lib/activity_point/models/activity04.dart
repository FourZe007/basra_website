import 'package:stsj/activity_point/models/activity.dart';
import 'package:stsj/activity_point/models/listmedia.dart';

class Activity04 extends Activity {
  String bsName;
  String area;
  String currentDate;
  String currentTime;
  double lat;
  double lng;
  String picTumb;
  String employeeId;
  String eName;
  int dipanggil;
  int datang;
  int diterima;
  List<Listmedia> listMedia;

  Activity04({
    required this.bsName,
    required this.area,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.picTumb,
    required this.employeeId,
    required this.eName,
    required this.dipanggil,
    required this.datang,
    required this.diterima,
    required this.listMedia,
  });

  factory Activity04.fromJson(Map<String, dynamic> json) {
    return Activity04(
      bsName: json['bsName'],
      area: json['area'],
      currentDate: json['currentDate'],
      currentTime: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      picTumb: json['pic1Thumb'],
      employeeId: json['employeeID'],
      eName: json['eName'],
      dipanggil: json['dipanggil'],
      datang: json['datang'],
      diterima: json['diterima'],
      listMedia: (json['listMedia'] as List).map<Listmedia>((x) => Listmedia.fromJson(x)).toList(),
    );
  }
}
