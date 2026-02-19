import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stsj/dashboard_pemetaan/models/geo_hd.dart';
import 'package:stsj/dashboard_pemetaan/models/geo_visit.dart';

class ApiPemetaan {
  static Future<List<GeoHD>> getPemetaanAktivitas(String user, String cabang, String area, String tgl1, String tgl2, String act) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/DealerActivity/DealerActivity/BrowseByCoordinate');
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
          'ActivityGroupID': act,
        }),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 180));

      if (respon.statusCode == 200) {
        var jsonDecode = json.decode(respon.body);
        if (jsonDecode['code'] == '100') {
          List<GeoHD> list = (jsonDecode['data'] as List).map<GeoHD>((data) => GeoHD.fromJson(data)).toList();

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

  static Future<List<GeoVisit>> getDetailVisit(String branch, String shop, String tgl1, String tgl2, String act, double lat, double lng) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/DealerActivity/DealerActivity/BrowseByCoordinateDetail');
    http.Response respon;
    try {
      respon = await http.post(
        url,
        body: jsonEncode({
          'Branch': branch,
          'Shop': shop,
          'BeginDate': tgl1,
          'EndDate': tgl2,
          'ActivityGroupID': act,
          'Lat': lat,
          'Lng': lng,
        }),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 180));

      if (respon.statusCode == 200) {
        var jsonDecode = json.decode(respon.body);
        if (jsonDecode['code'] == '100') {
          List<GeoVisit> list = (jsonDecode['data'] as List).map<GeoVisit>((data) => GeoVisit.fromJson(data)).toList();

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
