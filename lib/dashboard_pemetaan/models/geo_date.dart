class GeoDate {
  String currentDate;
  String currentTime;

  GeoDate({
    required this.currentDate,
    required this.currentTime,
  });

  factory GeoDate.fromJson(Map<String, dynamic> json) {
    return GeoDate(
      currentDate: json['currentDate'],
      currentTime: json['currentTime'],
    );
  }
}
