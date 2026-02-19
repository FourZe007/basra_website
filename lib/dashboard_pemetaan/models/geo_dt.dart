import 'package:stsj/dashboard_pemetaan/models/geo_date.dart';

class GeoDT {
  double lat;
  double lng;
  int qty;
  int warna;
  String gMaps;
  List<GeoDate> detailDate;

  GeoDT({
    required this.lat,
    required this.lng,
    required this.qty,
    required this.warna,
    required this.gMaps,
    required this.detailDate,
  });

  factory GeoDT.fromJson(Map<String, dynamic> json) {
    return GeoDT(
      lat: json['lat'],
      lng: json['lng'],
      qty: json['qty'],
      warna: json['kategoriWarna'],
      gMaps: json['gMapsUrl'],
      detailDate: (json['detailDate'] as List).map<GeoDate>((x) => GeoDate.fromJson(x)).toList(),
    );
  }
}
