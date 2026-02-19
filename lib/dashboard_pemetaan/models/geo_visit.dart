class GeoVisit {
  String currentDate;
  String currentTime;
  double lat;
  double lng;
  String jenisAktivitas;
  String lokasi;
  int salesman;
  String unitDisplay;
  int database;
  int hotprospek;
  int deal;
  String unitTestRide;
  int pesertaTestRide;
  String pic;

  GeoVisit({
    required this.currentDate,
    required this.currentTime,
    required this.lat,
    required this.lng,
    required this.jenisAktivitas,
    required this.lokasi,
    required this.salesman,
    required this.unitDisplay,
    required this.database,
    required this.hotprospek,
    required this.deal,
    required this.unitTestRide,
    required this.pesertaTestRide,
    required this.pic,
  });

  factory GeoVisit.fromJson(Map<String, dynamic> json) {
    return GeoVisit(
      currentDate: json['currentDate'],
      currentTime: json['currentTime'],
      lat: json['lat'],
      lng: json['lng'],
      jenisAktivitas: json['jenisAktivitas'],
      lokasi: json['lokasi'],
      salesman: json['salesman'],
      unitDisplay: json['unitDisplay'],
      database: json['database'],
      hotprospek: json['hotProspek'],
      deal: json['deal'],
      unitTestRide: json['unitTestRide'],
      pesertaTestRide: json['pesertaTestRide'],
      pic: json['pic1'],
    );
  }
}
