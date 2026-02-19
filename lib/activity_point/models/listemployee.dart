class ListEmployee {
  int line;
  String employeeId;
  String eName;
  String eType;
  String position;
  int spk;
  int stu;
  int stulm;

  ListEmployee({
    required this.line,
    required this.employeeId,
    required this.eName,
    required this.eType,
    required this.position,
    required this.spk,
    required this.stu,
    required this.stulm,
  });

  factory ListEmployee.fromJson(Map<String, dynamic> json) {
    return ListEmployee(
      line: json['line'],
      employeeId: json['employeeID'],
      eName: json['eName'],
      eType: json['eTypeID'],
      position: json['position'],
      spk: json['spk'],
      stu: json['stu'],
      stulm: json['stulm'],
    );
  }
}
