import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stsj/core/models/Report/ListReport.dart';
import 'package:stsj/core/models/Report/ReportModel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:universal_io/io.dart';

class ListReportController {
  static Future<List<ListReport>> fetchListReport(
      String pt, String Userid) async {
    Map<String, String> bodyPost = {
      "PT": pt,
      "UserID": Userid,
      "Category": "",
      "ReportName": ""
    };

    // print(bodyPost);

    // Convert the map to a JSON string
    final String jsonBody = json.encode(bodyPost);

    print(jsonBody);

    // Set the 'Content-Type' header to 'application/json'
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http
          .post(
              Uri.parse(
                  'https://wsip.yamaha-jatim.co.id:2448/api/Report/ReportList'),
              body: jsonBody,
              headers: headers)
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        // print(response.body);

        var jsonDecode = json.decode(response.body);

        List<ListReport> listReport =
            (jsonDecode as Map<String, dynamic>)['Data']
                .map<ListReport>((data) => ListReport.fromJson(data))
                .toList();

        // print(category);

        return listReport;
      } else {
        throw Exception('Error fetching list report: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('Connection error: ${e.message}');
      throw Exception('Connection error');
    } on TimeoutException catch (e) {
      print('Connection timeout: ${e.message}');
      throw Exception('Connection timeout');
    } catch (e) {
      print('Unknown error: ${e.toString()}');
      throw Exception('Unknown error');
    }
  }

  static Future<List<ListBranch>> fetchBranch(String pt, String userId) async {
    Map<String, String> bodyPost = {
      "PT": pt,
      "UserID": userId,
    };

    final String jsonBody = json.encode(bodyPost);

    print(jsonBody);

    // Set the 'Content-Type' header to 'application/json'
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http
          .post(
              Uri.parse(
                  'https://wsip.yamaha-jatim.co.id:2448/api/Report/BranchList'),
              body: jsonBody,
              headers: headers)
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        // print(response.body);

        var jsonDecode = json.decode(response.body);

        List<ListBranch> listBranch =
            (jsonDecode as Map<String, dynamic>)['Data']
                .map<ListBranch>((data) => ListBranch.fromJson(data))
                .toList();

        return listBranch;
      } else {
        throw Exception('Error fetching list report: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('Connection error: ${e.message}');
      throw Exception('Connection error');
    } on TimeoutException catch (e) {
      print('Connection timeout: ${e.message}');
      throw Exception('Connection timeout');
    } catch (e) {
      print('Unknown error: ${e.toString()}');
      throw Exception('Unknown error');
    }
  }

  static Future<List<ListShop>> fetchShop(
      String pt, String userId, String branch) async {
    Map<String, String> bodyPost = {
      "PT": pt,
      "UserID": userId,
      "Branch": branch
    };

    final String jsonBody = json.encode(bodyPost);

    print(jsonBody);

    // Set the 'Content-Type' header to 'application/json'
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http
          .post(
              Uri.parse(
                  'https://wsip.yamaha-jatim.co.id:2448/api/Report/ShopList'),
              body: jsonBody,
              headers: headers)
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        // print(response.body);

        var jsonDecode = json.decode(response.body);

        List<ListShop> listShop = (jsonDecode as Map<String, dynamic>)['Data']
            .map<ListShop>((data) => ListShop.fromJson(data))
            .toList();

        return listShop;
      } else {
        throw Exception('Error fetching list report: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('Connection error: ${e.message}');
      throw Exception('Connection error');
    } on TimeoutException catch (e) {
      print('Connection timeout: ${e.message}');
      throw Exception('Connection timeout');
    } catch (e) {
      print('Unknown error: ${e.toString()}');
      throw Exception('Unknown error');
    }
  }

  static void PostLaporan(Map listReport, String format) async {
    String url = "";

    // print(listReport);

    if (listReport['PT'] == 'RSSM' ||
        listReport['PT'] == 'STSJ' ||
        listReport['PT'] == 'SAMP' ||
        listReport['PT'] == 'RM') {
      url =
          "http://203.201.175.80:82/crapi/Report/${format}?PT=${listReport['PT']}";
    } else if (listReport['PT'] == 'SS' ||
        listReport['PT'] == 'ST' ||
        listReport['PT'] == 'SP' ||
        listReport['PT'] == 'SPR' ||
        listReport['PT'] == 'SPAA') {
      url = "http://203.201.175.80:82/Report/${format}?PT=${listReport['PT']}";
    }

    String encodedParam = jsonEncode(listReport);

    String urlbaru = url + "&Param=${encodedParam}";

    // String urlbaru = url +
    //     '&PT=${listReport['PT']}&ReportName=${listReport['ReportName']}&UserID=${listReport['UserID']}&Branch=${listReport['Branch']}&Shop=${listReport['Shop']}&BeginDate=${listReport['BeginDate']}&EndDate=${listReport['EndDate']}&BeginDate2=${listReport['BeginDate2']}&EndDate2=${listReport['EndDate2']}&BeginDate3=${listReport['BeginDate3']}&EndDate3=${listReport['EndDate3']}&BeginDate4=${listReport['BeginDate4']}&EndDate4=${listReport['EndDate4']}&BeginDate5=${listReport['BeginDate5']}&EndDate=${listReport['EndDate5']}&BeginDate6=${listReport['BeginDate6']}&EndDate6=${listReport['EndDat6']}&BeginAcc=${listReport['BeginAcc']}&EndAcc=${listReport['EndAcc']}&DeptID=${listReport['DeptID']}&CashBank=${listReport['CashBank']}&Filter1=${listReport['Filter1']}&Filter2=${listReport['Filter2']}&Filter3=${listReport['Filter3']}&Filter4=${listReport['Filter4']}&Filter5=${listReport['Filter5']}&Filter6=${listReport['Filter6']}';

    print(urlbaru);

    // Map<String, String> userHeader = {"Accept": "application/pdf"};

    try {
      // var dio = Dio();
      // final Directory? downloadsDir = await getDownloadsDirectory();

      // final response = await dio.download(urlbaru, downloadsDir);

      await launchUrl(
        Uri.parse(urlbaru),
        //mode: LaunchMode.inAppBrowserView,
      );

      // print(response);
    } on SocketException catch (e) {
      print('Connection error: ${e.message}');
      throw Exception('Connection error');
    } on TimeoutException catch (e) {
      print('Connection timeout: ${e.message}');
      throw Exception('Connection timeout');
    } catch (e) {
      print('Unknown error: ${e.toString()}');
      throw Exception('Unknown error');
    }
  }
}
