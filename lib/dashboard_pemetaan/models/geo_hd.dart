import 'package:stsj/dashboard_pemetaan/models/geo_dt.dart';

class GeoHD {
  int urutan;
  String bigArea;
  String smallArea;
  String branch;
  String shop;
  String bsName;
  double latDealer;
  double lngDealer;
  List<GeoDT> detail;

  GeoHD({
    required this.urutan,
    required this.bigArea,
    required this.smallArea,
    required this.branch,
    required this.shop,
    required this.bsName,
    required this.latDealer,
    required this.lngDealer,
    required this.detail,
  });

  factory GeoHD.fromJson(Map<String, dynamic> json) {
    return GeoHD(
      urutan: json['urutan'],
      bigArea: json['bigArea'],
      smallArea: json['smallArea'],
      branch: json['branch'],
      shop: json['shop'],
      bsName: json['bsName'],
      latDealer: json['latDealer'],
      lngDealer: json['lngDealer'],
      detail: (json['detail'] as List).map<GeoDT>((x) => GeoDT.fromJson(x)).toList(),
    );
  }
}
