/*
   Model Data Login

   */

class DataLogin {
  String userID;
  String entryLevelID;
  String entryLevelName;
  String memo;
  String employeeid;
  List<DataDT> dataDT;

  DataLogin({
    required this.userID,
    required this.entryLevelID,
    required this.entryLevelName,
    required this.memo,
    required this.employeeid,
    required this.dataDT,
  });

  factory DataLogin.fromJson(Map<String, dynamic> json) {
    final dataDTList = (json['DataDT'] as List)
        .map((dataDTJson) => DataDT.fromJson(dataDTJson))
        .toList();

    return DataLogin(
      userID: json['UserID'],
      entryLevelID: json['EntryLevelID'],
      entryLevelName: json['EntryLevelName'],
      memo: json['Memo'],
      employeeid: json['EmployeeID'],
      dataDT: dataDTList,
    );
  }
}

class DataDT {
  final String pt;
  String accessId;
  String accessName;

  DataDT({
    required this.pt,
    required this.accessId,
    required this.accessName,
  });

  factory DataDT.fromJson(Map<String, dynamic> json) {
    return DataDT(
      pt: json['PT'],
      accessId: json['EntryLevelID'],
      accessName: json['EntryLevelName'],
    );
  }
}

class DataPrivilege {
  String Menu = "";

  DataPrivilege({
    required this.Menu,
  });

  factory DataPrivilege.fromJson(Map<String, dynamic> json) {
    return DataPrivilege(Menu: json['Menu']);
  }
}
