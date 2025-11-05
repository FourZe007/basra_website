class DeliveryHistoryModel {
  String time;
  String lat;
  String lng;

  DeliveryHistoryModel(
      {required this.time, required this.lat, required this.lng});

  factory DeliveryHistoryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryHistoryModel(
      time: json['dateTime_'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
