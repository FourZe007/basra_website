import 'package:stsj/activity_point/models/activity.dart';
import 'package:stsj/activity_point/models/listemployee.dart';
import 'package:stsj/activity_point/models/listpayment.dart';
import 'package:stsj/activity_point/models/listspk.dart';
import 'package:stsj/activity_point/models/liststu.dart';

class Activity03 extends Activity {
  String bsName;
  String area;
  String currentDate;
  String currentTime;
  double lat;
  double lng;
  String picTumb;
  String employeeId;
  String eName;
  List<ListSTU> listStu;
  List<ListPayment> listPayment;
  List<ListSPK> listSpk;
  List<ListEmployee> listEmployee;

  Activity03({
    required this.bsName,
    required this.area,
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.picTumb,
    required this.employeeId,
    required this.eName,
    required this.listStu,
    required this.listPayment,
    required this.listSpk,
    required this.listEmployee,
  });

  factory Activity03.fromJson(Map<String, dynamic> json) {
    return Activity03(
      bsName: json['bsName'],
      area: json['area'],
      currentDate: json['currentDate'],
      currentTime: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      picTumb: json['pic1Thumb'],
      employeeId: json['employeeID'],
      eName: json['eName'],
      listStu: (json['stuCategory'] as List).map<ListSTU>((x) => ListSTU.fromJson(x)).toList(),
      listPayment: (json['payment'] as List).map<ListPayment>((x) => ListPayment.fromJson(x)).toList(),
      listSpk: (json['spkLeasing'] as List).map<ListSPK>((x) => ListSPK.fromJson(x)).toList(),
      listEmployee: (json['employee'] as List).map<ListEmployee>((x) => ListEmployee.fromJson(x)).toList(),
    );
  }
}
