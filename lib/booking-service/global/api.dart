import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/global/model.dart';

class GlobalAPI {
  static Future<List<ModelUserLogin>> getUserLogin(
      String customerphone, String password) async {
    var url = Uri.https(
        'wsip.yamaha-jatim.co.id:2448', '/apiSAMP/Master/LoginMembership');

    Map mapGetLogin = {
      'PhoneNo': customerphone,
      'DecryptedPassword': password,
    };

    print('MapGetLogin');
    print(mapGetLogin);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapGetLogin), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);
      List<ModelUserLogin> list = [];

      if (response.statusCode <= 200) {
        var jsonGetLogin = jsonDecode(response.body);
        if (jsonGetLogin['Code'] == '100' || jsonGetLogin['Msg'] == 'Sukses') {
          List<ModelUserLogin> list = (jsonGetLogin['Data'] as List)
              .map<ModelUserLogin>((data) => ModelUserLogin.fromJson(data))
              .toList();

          return list;
        } else {}
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<List<ModelLogin>> getLogin(
      String customercode, String password) async {
    var url =
        Uri.https('wsip.yamaha-jatim.co.id:2448', '/apiSAMP/Master/Login');

    Map mapGetLogin = {
      'UserID': customercode,
      'DecryptedPassword': password,
    };

    print('MapGetLogin');
    print(mapGetLogin);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapGetLogin), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);
      List<ModelLogin> list = [];

      if (response.statusCode <= 200) {
        var jsonGetLogin = jsonDecode(response.body);
        if (jsonGetLogin['Code'] == '100' || jsonGetLogin['Msg'] == 'Sukses') {
          List<ModelLogin> list = (jsonGetLogin['Data'] as List)
              .map<ModelLogin>((data) => ModelLogin.fromJson(data))
              .toList();

          return list;
        } else {}
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<List<ModelBrowseUser>> getUserData(
    String type,
    String memberID,
    String memberName,
    String plateNo,
    String phoneNo,
    String status,
  ) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/apiSAMP/BrowseTrans');

    Map mapUserData = {
      "Jenis": type,
      "MemberID": memberID,
      "MemberName": memberName,
      "PlateNo": plateNo,
      "PhoneNo": phoneNo,
      "Status": status,
    };

    print('mapUserData');
    print(mapUserData);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapUserData), headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'PostmanRuntime/7.35.0',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
      }).timeout(const Duration(seconds: 60));

      print(response.body);
      List<ModelBrowseUser> list = [];

      if (response.statusCode <= 200) {
        var jsonGetLogin = jsonDecode(response.body);
        if (jsonGetLogin['Code'] == '100' && jsonGetLogin['Msg'] == 'Sukses') {
          List<ModelBrowseUser> list = (jsonGetLogin['Data'] as List)
              .map<ModelBrowseUser>((data) => ModelBrowseUser.fromJson(data))
              .toList();

          return list;
        } else {
          List<ModelBrowseUser> list = [];

          return list;
        }
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<List<ModelResultMessage>> fetchInsertBookReq(
    String mode,
    String bookingID,
    String bookDate,
    String bookTime,
    String branch,
    String shop,
    String uName,
    String uPhoneNo,
    String uPlateNo,
    String unitID,
    String notes,
    String status,
    String adminID,
  ) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/apiSAMP/Modify');

    Map mapInsertBookReq = {
      "Mode": mode,
      "TransID": "RSV",
      'Data': {
        // BookingID -> MODE 1 BIARKAN KOSONG, MODE 2 : ISIKAN BOOKINGID YANG DIJAWAB
        "BookingID": bookingID,
        "BookDate": bookDate,
        "BookTime": bookTime,
        "Branch": "31",
        "Shop": shop,
        "UName": uName,
        "UPhoneNo": uPhoneNo,
        "UPlateNo": uPlateNo,
        "UnitID": unitID,
        "Notes": notes,
        // Status -> MODE 1 BIARKAN KOSONG, MODE 2 : 0 -- SETUJU, 1 -- DITOLAK
        "Status": status,
        // UserID -> MODE 1 BIARKAN KOSONG, MODE 2: ISI USERID YANG JAWAB
        "UserID": adminID,
      }
    };

    print('mapInsertBookReq');
    print(mapInsertBookReq);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapInsertBookReq), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      List<ModelResultMessage> list = [];
      print(response.body);

      if (response.statusCode <= 200) {
        var jsonInsertAsset = jsonDecode(response.body);
        if (jsonInsertAsset['Code'] == '100' &&
            jsonInsertAsset['Msg'] == 'Sukses') {
          List<ModelResultMessage> list = (jsonInsertAsset['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList();

          print(list[0].resultMessage);
          return list;
        } else {
          List<ModelResultMessage> list = (jsonInsertAsset['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList();

          print(list[0].resultMessage);
          return list;
        }
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<List<ModelBooking>> fetchBrowseBookReq(
    String shop,
    String userID,
    String beginDate,
    String endDate,
    String bookTime,
    String bookingID,
    String status,
  ) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/apiSAMP/BrowseTrans');

    Map mapInsertBookReq = {
      "Jenis": "SERVICE",
      "UserID": userID,
      "Branch": "31",
      "Shop": shop,
      "BeginDate": beginDate,
      "EndDate": endDate,
      "BookTime": bookTime,
      "BookingID": bookingID,
      "Status": status,
    };

    print('mapInsertBookReq');
    print(mapInsertBookReq);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapInsertBookReq), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      List<ModelBooking> list = [];
      print(response.body);

      if (response.statusCode <= 200) {
        var jsonInsertAsset = jsonDecode(response.body);
        if (jsonInsertAsset['Code'] == '100' &&
            jsonInsertAsset['Msg'] == 'Sukses') {
          List<ModelBooking> list = (jsonInsertAsset['Data'] as List)
              .map<ModelBooking>((data) => ModelBooking.fromJson(data))
              .toList();

          return list;
        } else {
          List<ModelBooking> list = (jsonInsertAsset['Data'] as List)
              .map<ModelBooking>((data) => ModelBooking.fromJson(data))
              .toList();

          return list;
        }
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<ModelSendMessage> fetchSendMessage(
    String phoneNumber,
    String message,
    String deviceId,
    String messageType,
  ) async {
    var url = Uri.https('haryanto-agus-api.kirimwa.id', '/v1/messages');

    Map mapMessage = {
      "phone_number": phoneNumber,
      "message": message,
      "device_id": deviceId,
      "message_type": messageType,
    };

    print('mapMessage');
    print(mapMessage);

    ModelSendMessage mapSendMessage = ModelSendMessage(resultMessage: '');

    try {
      final response =
          await http.post(url, body: jsonEncode(mapMessage), headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer Tb_3yl}VYq78qB^/NVWy0OXqgwPj0rTMhrU50qfG^@58~Hbt-enterprise',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      if (response.statusCode <= 201) {
        var jsonSendMessage = jsonDecode(response.body);
        if (jsonSendMessage['status'] == 'pending' ||
            jsonSendMessage['message'] ==
                'Message is pending and waiting to be processed.') {
          mapSendMessage =
              ModelSendMessage(resultMessage: jsonSendMessage['status']);

          print(mapSendMessage.resultMessage);
          return mapSendMessage;
        } else {
          mapSendMessage =
              ModelSendMessage(resultMessage: jsonSendMessage['status']);

          print(mapSendMessage.resultMessage);
          return mapSendMessage;
        }
      }

      return mapSendMessage;
    } catch (e) {
      return throw e;
    }
  }

  static Future<List<ModelResultMessage>> fetchModifyNotification(
    String mode,
    String memberID,
    String notificationID,
    String notificationType,
    String notification,
    String isSent,
    String isRead,
  ) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/apiSAMP/Modify');

    Map mapCreateNotification = {
      "Mode": mode,
      "TransID": "NOTIFICATION",
      'Data': {
        "MemberID": memberID,
        "NotificationID": notificationID,
        "NotificationType": notificationType,
        "Notification": notification,
        "IsSent": isSent,
        "IsRead": isRead,
      }
    };

    print('mapCreateNotification');
    print(mapCreateNotification);

    try {
      final response = await http
          .post(url, body: jsonEncode(mapCreateNotification), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      List<ModelResultMessage> list = [];
      print(response.body);

      if (response.statusCode <= 200) {
        var jsonSendNotification = jsonDecode(response.body);
        if (jsonSendNotification['Code'] == '100' &&
            jsonSendNotification['Msg'] == 'Sukses') {
          List<ModelResultMessage> list = (jsonSendNotification['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList();

          print(list[0].resultMessage);
          return list;
        } else {
          List<ModelResultMessage> list = (jsonSendNotification['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList();

          print(list[0].resultMessage);
          return list;
        }
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<List<ModelNotificationDetail>> fetchGetNotification(
    String userID,
    String isSent,
  ) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/apiSAMP/BrowseTrans');

    Map mapGetMessages = {
      "Jenis": "NOTIFICATION",
      "MemberID": userID == '' ? GlobalUser.userID : userID,
      "IsSent": isSent == '' ? '1' : '0',
      "IsRead": '',
    };

    print('mapGetMessages');
    print(mapGetMessages);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapGetMessages), headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'PostmanRuntime/7.35.0',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
      }).timeout(const Duration(seconds: 60));

      List<ModelNotificationDetail> list = [];
      print(response.body);

      if (response.statusCode <= 200) {
        var jsonGetMessage = jsonDecode(response.body);
        if (jsonGetMessage['Code'] == '100' &&
            jsonGetMessage['Msg'] == 'Sukses') {
          List<ModelNotificationDetail> list = (jsonGetMessage['Data'] as List)
              .map<ModelNotificationDetail>(
                  (data) => ModelNotificationDetail.fromJson(data))
              .toList();

          return list;
        } else {
          List<ModelNotificationDetail> list = (jsonGetMessage['Data'] as List)
              .map<ModelNotificationDetail>(
                  (data) => ModelNotificationDetail.fromJson(data))
              .toList();

          return list;
        }
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<String> fetchSendNotification(
    String token,
    String body,
    String title,
  ) async {
    var url = Uri.https('api-v2.neojt.com', '/fixupmoto/modify');

    Map mapSendNotification = {
      "jenis": "sendingNotifbyDeviceToken",
      "to": token,
      "notif": {
        "title": title,
        "body": body,
        "image": "",
      },
    };

    print('mapSendNotification');
    print(mapSendNotification);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapSendNotification), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      String str = '';
      print(response.body);

      if (response.statusCode <= 200) {
        var jsonGetMessage = jsonDecode(response.body);
        str = (jsonGetMessage['name']);
      } else {
        str = 'fail';
      }

      return str;
    } catch (e) {
      return throw e;
    }
  }

  static Future<List<ModelGetDeviceToken>> fetchGetDeviceToken() async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/apiSAMP/BrowseTrans');

    Map mapGetDeviceToken = {
      "Jenis": "FBTOKEN",
      "MemberID": GlobalUser.userID,
    };

    print('mapGetDeviceToken');
    print(mapGetDeviceToken);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapGetDeviceToken), headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'PostmanRuntime/7.35.0',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
      }).timeout(const Duration(seconds: 60));

      List<ModelGetDeviceToken> list = [];
      print(response.body);

      if (response.statusCode <= 200) {
        var jsonGetMessage = jsonDecode(response.body);
        if (jsonGetMessage['Code'] == '100' &&
            jsonGetMessage['Msg'] == 'Sukses') {
          List<ModelGetDeviceToken> list = (jsonGetMessage['Data'] as List)
              .map<ModelGetDeviceToken>(
                  (data) => ModelGetDeviceToken.fromJson(data))
              .toList();

          return list;
        } else {
          List<ModelGetDeviceToken> list = (jsonGetMessage['Data'] as List)
              .map<ModelGetDeviceToken>(
                  (data) => ModelGetDeviceToken.fromJson(data))
              .toList();

          return list;
        }
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  Future<void> refreshSession() async {
    var url = Uri.https('securetoken.googleapis.com',
        '/v1/token?key=BEg3QC7-JPDFywcTIkv-SgcDkATpTNWbXVFR--QOQFERczCR2F3mjJ822obYuHts6erOL6XkWU2wQFizA6NP');

    var token = '';
    var refreshToken = '';

    final response =
        await http.post(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 401) {
      final response = await http.post(url, headers: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      });
      token = jsonDecode(response.body)['token'];
      refreshToken = jsonDecode(response.body)['refresh_token'];
      return refreshSession();
    }
  }

  static Future<List<BranchDetail>> fetchBranches(
    String jenis,
  ) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/apiSAMP/Master');

    Map mapGetBranch = {
      "Jenis": jenis,
    };

    print('mapGetBranch');
    print(mapGetBranch);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapGetBranch), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      List<BranchDetail> list = [];
      print(response.body);

      if (response.statusCode <= 200) {
        var jsonInsertAsset = jsonDecode(response.body);
        if (jsonInsertAsset['Code'] == '100' &&
            jsonInsertAsset['Msg'] == 'Sukses') {
          List<BranchDetail> list = (jsonInsertAsset['Data'] as List)
              .map<BranchDetail>((data) => BranchDetail.fromJson(data))
              .toList();

          return list;
        } else {
          List<BranchDetail> list = (jsonInsertAsset['Data'] as List)
              .map<BranchDetail>((data) => BranchDetail.fromJson(data))
              .toList();

          return list;
        }
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<List<ModelResultMessage>> modifyAccount(
    String mode,
    String memberID,
    String memberName,
    String memberPass,
    String phoneNo,
    String emailAddress,
    String oldPass,
  ) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448', '/apiSAMP/Modify');

    Map mapRegister = {
      "Mode": mode,
      "TransID": "REGISTRATION",
      'Data': {
        "MemberID": memberID,
        "MemberName": memberName,
        "MemberPass": memberPass,
        "PhoneNo": phoneNo,
        "EmailAddress": emailAddress,
        "OldPass": oldPass,
      }
    };

    print('mapRegister');
    print(mapRegister);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapRegister), headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'PostmanRuntime/7.35.0',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
      }).timeout(const Duration(seconds: 60));

      print(response.body);
      List<ModelResultMessage> list = [];

      if (response.statusCode <= 200) {
        var jsonGetLogin = jsonDecode(response.body);
        if (jsonGetLogin['Code'] == '100' || jsonGetLogin['Msg'] == 'Sukses') {
          List<ModelResultMessage> list = (jsonGetLogin['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList();

          return list;
        } else {
          List<ModelResultMessage> list = (jsonGetLogin['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList();

          return list;
        }
      } else {
        list.add(ModelResultMessage(resultMessage: 'failed'));
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<ModelWhatsappStatus> getWhatsappStatus(
    String deviceName,
  ) async {
    var url =
        Uri.https('haryanto-agus-api.kirimwa.id', '/v1/devices/$deviceName');

    print('URL: $url');

    ModelWhatsappStatus mapWhatsappStatus = ModelWhatsappStatus(
      id: '',
      createdAt: '',
      status: '',
      phoneNumber: '',
      connectedAt: '',
      disconnectedAt: '',
      disconnectedReason: '',
    );

    print('Whatsapp Status Map: $mapWhatsappStatus');

    try {
      final response = await http.get(url, headers: {
        'Authorization':
            'Bearer Tb_3yl}VYq78qB^/NVWy0OXqgwPj0rTMhrU50qfG^@58~Hbt-enterprise',
      }).timeout(const Duration(seconds: 60));

      print('Whatsapp Status response');
      print(response.body);

      if (response.statusCode == 200) {
        var jsonWhatsappStatus = jsonDecode(response.body);
        if (jsonWhatsappStatus['Data'] != []) {
          mapWhatsappStatus = ModelWhatsappStatus(
            id: jsonWhatsappStatus['id'],
            createdAt: jsonWhatsappStatus['created_at'],
            status: jsonWhatsappStatus['status'],
            phoneNumber: jsonWhatsappStatus['phone_number'],
            connectedAt: jsonWhatsappStatus['connected_at'],
            disconnectedAt: jsonWhatsappStatus['disconnected_at'],
            disconnectedReason: jsonWhatsappStatus['disconnected_reason'],
          );

          print(mapWhatsappStatus);
          return mapWhatsappStatus;
        } else {
          return mapWhatsappStatus;
        }
      }

      return mapWhatsappStatus;
    } catch (e) {
      print(e.toString());
    }
    return mapWhatsappStatus;
  }

  static Future<ModelWhatsappQR> getWhatsappQR(
    String deviceName,
  ) async {
    var url = Uri.https(
        'haryanto-agus-api.kirimwa.id', '/v1/qr', {'device_id': deviceName});

    print('URL: $url');

    ModelWhatsappQR mapWhatsappQR = ModelWhatsappQR(
      qrCode: '',
      imageUrl: '',
    );

    print('Whatsapp QR Code Map: $mapWhatsappQR');

    try {
      final response = await http.get(url, headers: {
        'Authorization':
            'Bearer Tb_3yl}VYq78qB^/NVWy0OXqgwPj0rTMhrU50qfG^@58~Hbt-enterprise',
      }).timeout(const Duration(seconds: 60));

      print('Whatsapp Status response');
      print(response.body);

      if (response.statusCode == 200) {
        var jsonWhatsappQR = jsonDecode(response.body);
        if (jsonWhatsappQR['Data'] != []) {
          mapWhatsappQR = ModelWhatsappQR(
            qrCode: jsonWhatsappQR['qr_code'],
            imageUrl: jsonWhatsappQR['image_url'],
          );

          print(mapWhatsappQR);
          return mapWhatsappQR;
        } else {
          return mapWhatsappQR;
        }
      }

      return mapWhatsappQR;
    } catch (e) {
      print(e.toString());
    }
    return mapWhatsappQR;
  }
}
