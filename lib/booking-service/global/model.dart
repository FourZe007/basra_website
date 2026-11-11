class ModelUserLogin {
  int flag;
  String memo;
  String memberID;
  String memberName;

  ModelUserLogin({
    required this.flag,
    required this.memo,
    required this.memberID,
    required this.memberName,
  });

  factory ModelUserLogin.fromJson(Map<String, dynamic> json) {
    return ModelUserLogin(
      flag: json['Flag'],
      memo: json['Memo'],
      memberID: json['MemberID'],
      memberName: json['MemberName'],
    );
  }
}

class ModelLogin {
  String adminid;
  String memo;
  int flag;
  List<dynamic> detail;

  ModelLogin({
    required this.adminid,
    required this.memo,
    required this.flag,
    required this.detail,
  });

  factory ModelLogin.fromJson(Map<String, dynamic> json) {
    return ModelLogin(
      adminid: json['UserID'],
      flag: json['Flag'],
      memo: json['Memo'],
      detail: json['Detail']
          .map((dynamic data) => LoginDetail.fromJson(data))
          .toList(),
    );
  }
}

class LoginDetail {
  String branch;
  String shop;
  String name;

  LoginDetail({
    required this.branch,
    required this.shop,
    required this.name,
  });

  factory LoginDetail.fromJson(Map<String, dynamic> json) {
    return LoginDetail(
      branch: json['Branch'],
      shop: json['Shop'],
      name: json['BSName'],
    );
  }
}

class ModelBrowseUser {
  String status;
  String memberID;
  String memberName;
  String email;
  String phoneNumber;
  bool isActive;
  int qty;
  int points;
  List<dynamic> detail;
  List<dynamic> detail2;

  ModelBrowseUser({
    required this.status,
    required this.memberID,
    required this.memberName,
    required this.email,
    required this.phoneNumber,
    required this.isActive,
    required this.qty,
    required this.points,
    required this.detail,
    required this.detail2,
  });

  // sini
  factory ModelBrowseUser.fromJson(Map<String, dynamic> json) {
    return ModelBrowseUser(
      status: json['Status'],
      memberID: json['MemberID'],
      memberName: json['MemberName'],
      email: json['EmailAddress'],
      phoneNumber: json['PhoneNo'],
      isActive: json['Active'],
      qty: json['Qty'],
      points: json['Point'],
      detail: json['Detail']
          .map((dynamic data) => ModelBrowseUserDetail1.fromJson(data))
          .toList(),
      detail2: json['Detail2']
          .map((dynamic data) => ModelBrowseUserDetail2.fromJson(data))
          .toList(),
    );
  }
}

class ModelBrowseUserDetail1 {
  String transDate;
  String pointID;
  String pointName;
  int pointQty;

  ModelBrowseUserDetail1({
    required this.transDate,
    required this.pointID,
    required this.pointName,
    required this.pointQty,
  });

  factory ModelBrowseUserDetail1.fromJson(Map<String, dynamic> json) {
    return ModelBrowseUserDetail1(
      transDate: json['TransDate'],
      pointID: json['PointID'],
      pointName: json['PointName'],
      pointQty: json['PointQty'],
    );
  }
}

class ModelBrowseUserDetail2 {
  String redeemDate;
  String expiredDate;
  String voucherNumber;
  int voucherState;
  String voucherID;
  String voucherName;
  String voucherMemoState;

  ModelBrowseUserDetail2({
    required this.redeemDate,
    required this.expiredDate,
    required this.voucherNumber,
    required this.voucherState,
    required this.voucherID,
    required this.voucherName,
    required this.voucherMemoState,
  });

  factory ModelBrowseUserDetail2.fromJson(Map<String, dynamic> json) {
    return ModelBrowseUserDetail2(
      redeemDate: json['RedeemDate'],
      expiredDate: json['ExpirationDate'],
      voucherNumber: json['VoucherNo'],
      voucherState: json['StatusVoucher'],
      voucherID: json['VoucherID'],
      voucherName: json['VoucherName'],
      voucherMemoState: json['StatusVoucherMemo'],
    );
  }
}

class BranchDetail {
  String branch;
  String shop;
  String name;
  String address;
  String operation;
  String phone;
  bool isOpen;
  double lat;
  double lng;

  BranchDetail({
    required this.branch,
    required this.shop,
    required this.name,
    required this.address,
    required this.operation,
    required this.phone,
    required this.isOpen,
    required this.lat,
    required this.lng,
  });

  factory BranchDetail.fromJson(Map<String, dynamic> json) {
    return BranchDetail(
      branch: json['Branch'],
      shop: json['Shop'],
      name: json['BSName'],
      address: json['BSAddress'],
      operation: json['OperasionalHours'],
      phone: json['PhoneNo'],
      isOpen: json['Active'],
      lat: json['Lat'],
      lng: json['Lng'],
    );
  }
}

class ModelResultMessage {
  String resultMessage;

  ModelResultMessage({required this.resultMessage});

  factory ModelResultMessage.fromJson(Map<String, dynamic> json) {
    return ModelResultMessage(resultMessage: json['ResultMessage']);
  }
}

class ModelSendMessage {
  String resultMessage;

  ModelSendMessage({required this.resultMessage});

  factory ModelSendMessage.fromJson(Map<String, dynamic> json) {
    // final metaObject = json['meta'] as Map<String, dynamic>;
    // final location = metaObject['location'] as String;
    return ModelSendMessage(resultMessage: json['status']);
    // return ModelSendMessage(resultMessage: json['meta']);
  }
}

class ModelBooking {
  String bookingID;
  String bookDate;
  String bookTime;
  String branch;
  String shop;
  String uName;
  String uPhoneNo;
  String uPlateNo;
  String unitID;
  String notes;
  String status;
  // String userID;

  ModelBooking({
    required this.bookingID,
    required this.bookDate,
    required this.bookTime,
    required this.branch,
    required this.shop,
    required this.uName,
    required this.uPhoneNo,
    required this.uPlateNo,
    required this.unitID,
    required this.notes,
    required this.status,
    // required this.userID,
  });

  factory ModelBooking.fromJson(Map<String, dynamic> json) {
    return ModelBooking(
      bookingID: json['BookingID'],
      bookDate: json['BookDate'],
      bookTime: json['BookTime'],
      branch: json['Branch'],
      shop: json['Shop'],
      uName: json['UName'],
      uPhoneNo: json['UPhoneNo'],
      uPlateNo: json['UPlateNo'],
      unitID: json['UnitID'],
      notes: json['Notes'],
      status: json['Status'],
      // userID: json['LeasingName'],
    );
  }
}

class ModelNotificationDetail {
  String memberID;
  String notifID;
  String notifType;
  String notif;
  String date;
  String isSent;
  String isRead;

  ModelNotificationDetail({
    required this.memberID,
    required this.notifID,
    required this.notifType,
    required this.notif,
    required this.date,
    required this.isSent,
    required this.isRead,
  });

  factory ModelNotificationDetail.fromJson(Map<String, dynamic> json) {
    return ModelNotificationDetail(
      memberID: json['MemberID'],
      notifID: json['NotificationID'],
      notifType: json['NotificationType'],
      notif: json['Notification'],
      date: json['SysDate'],
      isSent: json['IsSent'],
      isRead: json['IsRead'],
    );
  }
}

// "MemberID": "0101202300000003",
// "FBToken": "cTtrais7RO2lb9ktaa9CBM:APA91bFP9bRCFcvql-IqXnKwXR8niiG9E7GCB5Ku5-_s0pIoEhFug8sgU1mZ89TRfl3djbYJ2bctlaGPRLZ4dKSvQ43z2T_b5puwxqO9-nf8aqvEQVtSGeUX7YYVyYFy0VERSN9QilNr",
// "SerialNumber": ""
class ModelGetDeviceToken {
  String memberID;
  String token;
  String serialNumber;

  ModelGetDeviceToken({
    required this.memberID,
    required this.token,
    required this.serialNumber,
  });

  factory ModelGetDeviceToken.fromJson(Map<String, dynamic> json) {
    return ModelGetDeviceToken(
      memberID: json['MemberID'],
      token: json['FBToken'],
      serialNumber: json['SerialNumber'],
    );
  }
}

class ModelWhatsapp {
  ModelWhatsappStatus status;
  ModelWhatsappQR qr;

  ModelWhatsapp({
    required this.status,
    required this.qr,
  });
}

class ModelWhatsappStatus {
  String id;
  String createdAt;
  String status;
  String phoneNumber;
  String? connectedAt;
  String? disconnectedAt;
  String? disconnectedReason;

  ModelWhatsappStatus({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.phoneNumber,
    required this.connectedAt,
    required this.disconnectedAt,
    required this.disconnectedReason,
  });

  factory ModelWhatsappStatus.fromJson(Map<String, dynamic> json) {
    return ModelWhatsappStatus(
      id: json['id'],
      createdAt: json['created_at'],
      status: json['status'],
      phoneNumber: json['phone_number'],
      connectedAt: json['connected_at'],
      disconnectedAt: json['disconnected_at'],
      disconnectedReason: json['disconnected_reason'],
    );
  }
}

class ModelWhatsappQR {
  String qrCode;
  String imageUrl;

  ModelWhatsappQR({
    required this.qrCode,
    required this.imageUrl,
  });

  factory ModelWhatsappQR.fromJson(Map<String, dynamic> json) {
    return ModelWhatsappQR(
      qrCode: json['qr_code'],
      imageUrl: json['image_url'],
    );
  }
}
