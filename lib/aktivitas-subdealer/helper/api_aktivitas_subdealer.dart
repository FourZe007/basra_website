import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stsj/aktivitas-subdealer/helper/model_aktivitas_subdealer.dart';

String code = '', msg = '';

class APIAktivitasSubDealer {
  static Future<List<ModelProvinsi>> getMProvinsi(String userID) async {
    var url = Uri.https(
        'wsip.yamaha-jatim.co.id:2448', '/api/SIPSales/BrowseMBigArea');

    Map bodyAPI = {'UserID': userID};

    try {
      final response = await http.post(url,
          body: jsonEncode(bodyAPI),
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 60));

      List<ModelProvinsi> list = [];

      if (response.statusCode <= 200) {
        var json = jsonDecode(response.body);

        code = json['code'];
        msg = json['msg'];

        if (code == '100' || msg == 'Sukses') {
          list = (json['data'] as List)
              .map<ModelProvinsi>((data) => ModelProvinsi.fromJson(data))
              .toList();

          return list;
        }
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<List<ModelWilayah>> getMWilayah(String userID, bigArea) async {
    var url = Uri.https(
        'wsip.yamaha-jatim.co.id:2448', '/api/SIPSales/BrowseMSmallArea');

    Map bodyAPI = {'UserID': userID, 'BigArea': bigArea};

    try {
      final response = await http.post(url,
          body: jsonEncode(bodyAPI),
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 60));

      List<ModelWilayah> list = [];

      if (response.statusCode <= 200) {
        var json = jsonDecode(response.body);

        code = json['code'];
        msg = json['msg'];

        if (code == '100' || msg == 'Sukses') {
          list = (json['data'] as List)
              .map<ModelWilayah>((data) => ModelWilayah.fromJson(data))
              .toList();

          return list;
        }
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<List<ModelSDActivityReport>> getSDActivityReport(
      String userID, bigArea, smallArea, customerID, currentDate) async {
    var url = Uri.https(
        'wsip.yamaha-jatim.co.id:2448', '/api/SubDealerReport/DailyActivity');

    Map bodyAPI = {
      'UserID': userID,
      'BigArea': bigArea,
      'SmallArea': smallArea,
      'CustomerID': customerID,
      'CurrentDate': currentDate
    };

    try {
      final response = await http.post(url,
          body: jsonEncode(bodyAPI),
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 60));

      List<ModelSDActivityReport> list = [];

      if (response.statusCode <= 200) {
        var json = jsonDecode(response.body);

        code = json['Code'];
        msg = json['Msg'];

        if (code == '100' || msg == 'Sukses') {
          list = (json['Data'] as List)
              .map<ModelSDActivityReport>(
                  (data) => ModelSDActivityReport.fromJson(data))
              .toList();

          return list;
        }
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }
}
