// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/models/AuthModel/DataAuth.dart';

class DataLoginController {
  static Future<List<DataLogin>> login(String User, String Password) async {
    try {
      String userid = User;
      String userpass = Password;

      Map<String, String> loginData = {
        'UserID': userid,
        'DecryptedPassword': userpass,
      };

      // Convert the map to a JSON string
      final String jsonBody = json.encode(loginData);

      // Set the 'Content-Type' header to 'application/json'
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      final response = await http
          .post(
            Uri.parse(
              'https://wsip.yamaha-jatim.co.id:2448/api/Login/Login',
            ),
            headers: headers,
            body: jsonBody,
          )
          .timeout(const Duration(seconds: 20));

      print('Login Response: ${response.body}');

      if (response.statusCode == 200) {
        var jsonLogin = jsonDecode(response.body);

        List<DataLogin> listlogin = (jsonLogin['Data'] as List)
            .map<DataLogin>((data) => DataLogin.fromJson(data))
            .toList();

        return listlogin;
      } else {
        throw Exception("Terjadi kesalahan");
      }
    } catch (error) {
      print('Error: $error');
      throw Exception("Terjadi kesalahan saat memuat data.");
    }
  }

  static Future<void> setIntoSharedPreferences(
    String userID,
    String levelID,
    String levelName,
    String companyName,
    String employeeID,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Status', true);
    print('Status: ${prefs.getBool('Status')}');
    await prefs.setString('UserID', userID);
    print('User ID: ${prefs.getString('UserID')}');
    await prefs.setString('EntryLevelID', levelID);
    print('Level ID: ${prefs.getString('EntryLevelID')}');
    await prefs.setString('EntryLevelName', levelName);
    print('Level Name: ${prefs.getString('EntryLevelName')}');
    await prefs.setString('CompanyName', companyName);
    print('Company Name: ${prefs.getString('CompanyName')}');
    await prefs.setString('EmployeeID', employeeID);
    print('Employee ID: ${prefs.getString('EmployeeID')}');
  }

  static void removeDataUser() async {
    try {
      SharedPreferences NamaLoginPref = await SharedPreferences.getInstance();
      await NamaLoginPref.clear();
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
