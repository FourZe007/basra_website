import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stsj/activity_point/models/activity.dart';
import 'package:stsj/activity_point/models/activity00.dart';
import 'package:stsj/activity_point/models/activity01.dart';
import 'package:stsj/activity_point/models/activity02.dart';
import 'package:stsj/activity_point/models/activity03.dart';
import 'package:stsj/activity_point/models/activity04.dart';
import 'package:stsj/activity_point/models/klasifikasi.dart';
import 'package:stsj/activity_point/models/model_manager_activities.dart';
import 'package:stsj/activity_point/models/point_sm_hd.dart';

class ApiPoint {
//todo
  //GLOBALAPI
  // static Future<List<PointSMHD>> fetchActivitiesPoint2(
  //   String userid,
  //   String province,
  //   String area,
  //   String beginDate,
  //   String endDate,
  // ) async {
  //   var url = Uri.https(
  //     'wsip.yamaha-jatim.co.id:2448',
  //     '/api/SIPSales/BrowseEmployeePointSM',
  //   );

  //   Map mapActivitiesPoint = {
  //     "UserID": userid,
  //     "BigArea": province,
  //     "SmallArea": area,
  //     "BeginDate": beginDate,
  //     "EndDate": endDate,
  //   };

  //   List<PointSMHD> activitiesPointList = [];

  //   try {
  //     final response =
  //         await http.post(url, body: jsonEncode(mapActivitiesPoint), headers: {
  //       'Content-Type': 'application/json',
  //     }).timeout(const Duration(seconds: 60));

  //     if (response.statusCode <= 200) {
  //       var jsonActivitiesPoint = jsonDecode(response.body);
  //       if (jsonActivitiesPoint['code'] == '100' &&
  //           jsonActivitiesPoint['msg'] == 'Sukses') {
  //         activitiesPointList = (jsonActivitiesPoint['data'] as List)
  //             .map<PointSMHD>(
  //                 (list) => PointSMHD.fromJson(list))
  //             .toList();
  //       } else {
  //         return activitiesPointList;
  //       }
  //     } else {}
  //     return activitiesPointList;
  //   } catch (e) {
  //     print(e.toString());
  //     return activitiesPointList;
  //   }
  // }

  //PROVIDER
  //<PointSMHD> activitiesPointList2 = [];

  //List<PointSMHD> get getActivitiesPointList2 => activitiesPointList2;

  // void fetchActivitiesPoint2(
  //   String province,
  //   String area,
  //   String beginDate,
  //   String endDate,
  // ) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   username = prefs.getString('UserID') ?? '';

  //   await GlobalAPI.fetchActivitiesPoint2(
  //     username,
  //     province,
  //     area,
  //     beginDate,
  //     endDate,
  //   ).then((list) {
  //     activitiesPointList2.clear();

  //     activitiesPointList2=list;
  //   });
  // }

  static Future<List<PointSMHD>> getSMPoint(String user, String cabang, String area, String tgl1, String tgl2) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/api/SIPSales/BrowseEmployeePointSM');
    http.Response respon;
    try {
      respon = await http.post(
        url,
        body: jsonEncode({
          'UserID': user,
          'BigArea': cabang,
          'SmallArea': area,
          'BeginDate': tgl1,
          'EndDate': tgl2,
        }),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 180));

      if (respon.statusCode == 200) {
        var jsonDecode = json.decode(respon.body);
        if (jsonDecode['code'] == '100') {
          List<PointSMHD> list = (jsonDecode['data'] as List).map<PointSMHD>((data) => PointSMHD.fromJson(data)).toList();

          return list;
        } else {
          throw (jsonDecode['msg'] ?? 'DATA NOT FOUND');
        }
      } else {
        throw ('${respon.statusCode.toString()} : ${respon.reasonPhrase.toString()}');
      }
    } on TimeoutException {
      throw ('TIME OUT');
    } catch (e) {
      throw (e.toString());
    }
  }
//!

  static Future<Map<String, dynamic>> prosesUploadTarget(String user, String thn, String bln, List<Klasifikasi> listData) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/api/SIPSales/ModifyTargetDealerActivity');
    http.Response respon;
    List<Map<String, dynamic>> tmp = [
      for (Klasifikasi data in listData)
        Map.of({
          "Branch": data.branch,
          "Shop": data.shop,
          "TargetDate": '$thn-$bln-01',
          "T01": data.t1,
          "T02": data.t2,
          "T03": data.t3,
          "T04": data.t4,
          "T05": data.t5,
          "T06": data.t6,
          "T07": data.t7,
          "T08": data.t8,
          "T09": data.t9,
          "T10": data.t10,
          "T11": data.t11,
          "T12": data.t12,
          "T13": data.t13,
          "T14": data.t14,
          "T15": data.t15,
          "T16": data.t16,
          "T17": data.t17,
          "T18": data.t18,
          "T19": data.t19,
          "T20": data.t20,
          "T21": data.t21,
          "T22": data.t22,
          "T23": data.t23,
          "T24": data.t24,
          "T25": data.t25,
          "T26": data.t26,
          "T27": data.t27,
          "T28": data.t28,
          "T29": data.t29,
          "T30": data.t30,
          "T31": data.t31,
          "UserID": user,
        })
    ];
    try {
      respon = await http.post(
        url,
        body: jsonEncode(tmp),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 180));
      if (respon.statusCode == 200) {
        var jsonDecode = json.decode(respon.body);
        if (jsonDecode['Code'] == '100' && jsonDecode['Data'][0]['ResultMessage'] == 'SUKSES') {
          return jsonDecode['Data'][0];
        } else {
          throw (jsonDecode['Msg'] ?? 'UPLOAD GAGAL');
        }
      } else {
        throw ('${respon.statusCode.toString()} : ${respon.reasonPhrase.toString()}');
      }
    } on TimeoutException {
      throw ('TIME OUT');
    } catch (e) {
      throw (e.toString());
    }
  }

//todo
  //GLOBALAPI
  // static Future<List<ModelManagerActivities>> fetchManagerActivities2(
  //   String userid,
  //   String province,
  //   String area,
  //   String date,
  // ) async {
  //   var url = Uri.https(
  //     'wsip.yamaha-jatim.co.id:2448',
  //     '/api/SIPSales/EmployeeActivitySMByArea',
  //   );

  //   Map mapManagerActivities = {
  //     "UserID": userid,
  //     "BigArea": province,
  //     "SmallArea": area,
  //     "CurrentDate": date,
  //   };

  //   List<ModelManagerActivities> manangerActivitiesList = [];

  //   try {
  //     final response = await http
  //         .post(url, body: jsonEncode(mapManagerActivities), headers: {
  //       'Content-Type': 'application/json',
  //     }).timeout(const Duration(seconds: 60));

  //     if (response.statusCode <= 200) {
  //       var jsonManagerActivities = jsonDecode(response.body);
  //       if (jsonManagerActivities['code'] == '100' &&
  //           jsonManagerActivities['msg'] == 'Sukses') {
  //         manangerActivitiesList = (jsonManagerActivities['data'] as List)
  //             .map<ModelManagerActivities>(
  //                 (list) => ModelManagerActivities.fromJson(list))
  //             .toList();

  //         return manangerActivitiesList;
  //       } else {
  //         return manangerActivitiesList;
  //       }
  //     } else {}
  //     return manangerActivitiesList;
  //   } catch (e) {
  //     print(e.toString());
  //     return manangerActivitiesList;
  //   }
  // }

  //PROVIDER
  // List<ModelManagerActivities> managerActivitiesList2 = [];

  // List<ModelManagerActivities> get getManagerActivitiesList2 => managerActivitiesList2;

  // void fetchManagerActivities2(
  //   String province,
  //   String area,
  //   String date,
  // ) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   username = prefs.getString('UserID') ?? '';

  //   managerActivitiesList2.clear();
  //   managerActivitiesList2 = await GlobalAPI.fetchManagerActivities2(
  //     username,
  //     province,
  //     area == '' ? province : area,
  //     date,
  //   ).then((list) {
  //     managerActivitiesList2.clear();

  //     managerActivitiesList2=list;
  //   });
  // }

  static Future<List<ModelManagerActivities>> getManagerAct(String user, String cabang, String area, String tgl) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/DealerActivity/DealerActivity/BrowseByArea');
    http.Response respon;
    try {
      respon = await http.post(
        url,
        body: jsonEncode({
          'UserID': user,
          'BigArea': cabang,
          'SmallArea': area,
          'CurrentDate': tgl,
        }),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 180));

      if (respon.statusCode == 200) {
        var jsonDecode = json.decode(respon.body);
        if (jsonDecode['code'] == '100') {
          return (jsonDecode['data'] as List).map<ModelManagerActivities>((data) => ModelManagerActivities.fromJson(data)).toList();
        } else {
          throw (jsonDecode['msg'] ?? 'DATA NOT FOUND');
        }
      } else {
        throw ('${respon.statusCode.toString()} : ${respon.reasonPhrase.toString()}');
      }
    } on TimeoutException {
      throw ('TIME OUT');
    } catch (e) {
      throw (e.toString());
    }
  }

  static Future<String> getFotoFS(String branch, String shop, String actId, String tgl) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/DealerActivity/DealerActivity/DealerActivityPic');
    http.Response respon;
    try {
      respon = await http.post(
        url,
        body: jsonEncode({
          'Branch': branch,
          'Shop': shop,
          'ActivityID': actId,
          'CurrentDate': tgl,
        }),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 180));

      if (respon.statusCode == 200) {
        var jsonDecode = json.decode(respon.body);
        if (jsonDecode['code'] == '100') {
          return jsonDecode['data'][0]['pic1'];
        } else {
          throw (jsonDecode['msg'] ?? 'DATA NOT FOUND');
        }
      } else {
        throw ('${respon.statusCode.toString()} : ${respon.reasonPhrase.toString()}');
      }
    } on TimeoutException {
      throw ('TIME OUT');
    } catch (e) {
      throw (e.toString());
    }
  }
//!

  static Future<Map<String, dynamic>> updateScore(int? p1, int? p2, int? p3, ModelManagerActivities model, String user) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/api/SIPSales/InsertEmployeePointSM');
    http.Response respon;
    List<Map<String, dynamic>> tmp = [
      Map.of({
        "EmployeeID": model.employeeId,
        "Branch": model.branch,
        "Shop": model.shop,
        "CurrentDate": model.currentDate,
        "ActivityID": model.actId,
        "Point1": p1 ?? model.point1Final,
        "Point2": p2 ?? model.point2Final,
        "Point3": p3 ?? model.point3Final,
        "UserID": user,
      })
    ];
    try {
      respon = await http.post(
        url,
        body: jsonEncode(tmp),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (respon.statusCode == 200) {
        var jsonDecode = json.decode(respon.body);
        if (jsonDecode['code'] == '100' && jsonDecode['data'][0]['resultMessage'] == 'SUKSES') {
          return jsonDecode['data'][0];
        } else {
          throw (jsonDecode['msg'] ?? 'DATA NOT FOUND');
        }
      } else {
        throw ('${respon.statusCode.toString()} : ${respon.reasonPhrase.toString()}');
      }
    } on TimeoutException {
      throw ('TIME OUT');
    } catch (e) {
      throw (e.toString());
    }
  }

  static Future<Activity> getActivityCaption(String actId, String branch, String shop, String tgl) async {
    var url = actId == '00'
        ? Uri.https('wsip.yamaha-jatim.co.id:2448', '/DealerActivity/DealerActivity01/Show')
        : actId == '01'
            ? Uri.https('wsip.yamaha-jatim.co.id:2448', '/DealerActivity/DealerActivity02/Show')
            : actId == '02'
                ? Uri.https('wsip.yamaha-jatim.co.id:2448', '/DealerActivity/DealerActivity03/Show_1')
                : actId == '03'
                    ? Uri.https('wsip.yamaha-jatim.co.id:2448', '/DealerActivity/DealerActivity04/Show')
                    : Uri.https('wsip.yamaha-jatim.co.id:2448', '/DealerActivity/DealerActivity03/Show_2');
    http.Response respon;
    try {
      respon = await http.post(
        url,
        body: jsonEncode({
          'Branch': branch,
          'Shop': shop,
          'CurrentDate': tgl,
        }),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 180));

      if (respon.statusCode == 200) {
        var jsonDecode = json.decode(respon.body);
        if (jsonDecode['code'] == '100' && (jsonDecode['data'] as List).isNotEmpty) {
          Activity list;
          if (actId == '00') {
            list = Activity00.fromJson(jsonDecode['data'][0]);
          } else if (actId == '01') {
            list = Activity01.fromJson(jsonDecode['data'][0]);
          } else if (actId == '02') {
            list = Activity02.fromJson(jsonDecode['data'][0]);
          } else if (actId == '03') {
            list = Activity03.fromJson(jsonDecode['data'][0]);
          } else {
            list = Activity04.fromJson(jsonDecode['data'][0]);
          }

          return list;
        } else {
          throw (jsonDecode['msg'] ?? 'DATA NOT FOUND');
        }
      } else {
        throw ('${respon.statusCode.toString()} : ${respon.reasonPhrase.toString()}');
      }
    } on TimeoutException {
      throw ('TIME OUT');
    } catch (e) {
      throw (e.toString());
    }
  }
}
