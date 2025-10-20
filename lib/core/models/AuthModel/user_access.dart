// "category": "DASHBOARD",
// "menuNumber": "002",
// "menuName": "AFTER SALES",
// "allowView": 1
class ModelUserAccess {
  String category;
  String menuNumber;
  String menuName;
  int isAllowView;
  int isAllowEdit;

  ModelUserAccess(
      {required this.category,
      required this.menuNumber,
      required this.menuName,
      required this.isAllowView,
      required this.isAllowEdit});

  factory ModelUserAccess.fromJson(Map<String, dynamic> json) {
    return ModelUserAccess(
        category: json['category'],
        menuNumber: json['menuNumber'],
        menuName: json['menuName'],
        isAllowView: json['allowView'],
        isAllowEdit: json['allowEdit']);
  }
}
