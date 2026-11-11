import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/models/AuthModel/DataAuth.dart';

class Auth {
  static Color primarycolor = Colors.blueAccent;
  static TextStyle fontdashboard = TextStyle(fontFamily: "fontdashboard");

  static final List<String> companyList = [
    "STSJ",
    "SS",
    "SP",
    "SPAA",
    "SAMP",
    "ST",
    "RSSM",
    "SPr",
    "RM",
  ];

  static Map<String, bool> accessGranted = {
    "STSJ": false,
    "SS": false,
    "SP": false,
    "SPAA": false,
    "SAMP": false,
    "ST": false,
    "RSSM": false,
    "SPr": false,
    "RM": false,
  };
  static bool rssmAuth = false; // Roda Sakti Surya Megah
  static bool stsjAuth = false; // SURYA TIMUR SAKTI JATIM
  static bool spaauth = false; // SURYA PERKASA ANUGRAH ABADI

  static bool ssAuth = false; // SAPTA AJI MANUNGGAL PRIMA
  static bool sampAuth = false; // SAPTA AJI MANUNGGAL PRIMA
  static bool stAuth = false; //Surya Terang
  static bool spAuth = false; // Surya Prima
  static bool sprauth = false; //Surya Pratama
  static bool rmAuth = false; // Roda Megah

  // static void updateValuesFromSharedPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   stsjAuth = prefs.getBool('STSJ') ?? false;
  //   ssAuth = prefs.getBool('SS') ?? false;
  //   spAuth = prefs.getBool('SP') ?? false;
  //   spaauth = prefs.getBool('SPAA') ?? false;
  //   sampAuth = prefs.getBool('SAMP') ?? false;
  //   stAuth = prefs.getBool('ST') ?? false;
  //   rssmAuth = prefs.getBool('RSSM') ?? false;
  // }

  static Future<void> resetAuth() async {
    accessGranted = {
      "STSJ": false,
      "SS": false,
      "SP": false,
      "SPAA": false,
      "SAMP": false,
      "ST": false,
      "RSSM": false,
      "SPr": false,
      "RM": false,
    };

    rssmAuth = false; // Roda Sakti Surya Megah
    stsjAuth = false; // SURYA TIMUR SAKTI JATIM
    spaauth = false; // SURYA PERKASA ANUGRAH ABADI
    ssAuth = false; // SAPTA AJI MANUNGGAL PRIMA
    sampAuth = false; // SAPTA AJI MANUNGGAL PRIMA
    stAuth = false; //Surya Terang
    spAuth = false; // Surya Prima
    sprauth = false; //Surya Pratama
    rmAuth = false; // Roda Megah
  }

  static void updateBasedOnDataDT(List<DataDT> dataDT) {
    // Create a map to associate values with boolean variables

    for (var itemDt in dataDT) {
      final value = itemDt.pt;
      if (companyList.contains(value)) {
        accessGranted[value] = true;
      } else {
        accessGranted[value] = false;
      }
    }

    print(accessGranted);
    rssmAuth = accessGranted["RSSM"] ?? false;

    stsjAuth = accessGranted["STSJ"] ?? false;

    spaauth = accessGranted["SPAA"] ?? false;
    sampAuth = accessGranted["SAMP"] ?? false;

    stAuth = accessGranted["ST"] ?? false;
    ssAuth = accessGranted["SS"] ?? false;
    spAuth = accessGranted["SP"] ?? false;
    sprauth = accessGranted["SPr"] ?? false;
    rmAuth = accessGranted["RM"] ?? false;
  }

  static Future<void> saveDataToSharedPreferences(List<DataDT> dataDT) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print('Data DT');
    for (var items in dataDT) {
      print(items.pt);
    }

    for (var itemDt in dataDT) {
      final value = itemDt.pt;
      print('Company name: $value');
      if (companyList.contains(value)) {
        accessGranted[value] = true;
      } else {
        accessGranted[value] = false;
      }
    }
    print('');

    accessGranted.forEach((key, value) {
      print('$key, $value');
    });

    stsjAuth = accessGranted["STSJ"] ?? false;
    ssAuth = accessGranted["SS"] ?? false;
    spAuth = accessGranted["SP"] ?? false;
    spaauth = accessGranted["SPAA"] ?? false;
    sampAuth = accessGranted["SAMP"] ?? false;
    stAuth = accessGranted["ST"] ?? false;
    rssmAuth = accessGranted["RSSM"] ?? false;
    sprauth = accessGranted["SPr"] ?? false;
    rmAuth = accessGranted["RM"] ?? false;

    // Simpan nilai baru ke SharedPreferences
    await prefs.setBool('STSJ', stsjAuth);
    await prefs.setBool('SPAA', spaauth);
    await prefs.setBool('SAMP', sampAuth);
    await prefs.setBool('ST', stAuth);
    await prefs.setBool('RSSM', rssmAuth);
    await prefs.setBool('SS', ssAuth);
    await prefs.setBool('SP', spAuth);
    await prefs.setBool('Spr', sprauth);
    await prefs.setBool('RM', rmAuth);

    print('Data disimpan dalam SharedPreferences.');
  }
}
