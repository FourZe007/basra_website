import 'package:flutter/widgets.dart';

class ModelBrowseAlokasi {
  String branch, shop, bname, bsname, unitid, itemname, color, colorname;
  int fsn1,
      po,
      totalstok,
      nota110,
      other,
      sisastok,
      freestok1,
      freestok2,
      freestok3,
      freestokall,
      freestokbagi1,
      freestokbagi2,
      freestokbagi3,
      freestokbagi,
      freestokbisabagi;
  bool isvalid;
  TextEditingController freestokADJ1;
  TextEditingController freestokADJ2;
  TextEditingController freestokADJ3;

  ModelBrowseAlokasi(
      {required this.branch,
      required this.shop,
      required this.bname,
      required this.bsname,
      required this.unitid,
      required this.itemname,
      required this.color,
      required this.colorname,
      required this.fsn1,
      required this.po,
      required this.totalstok,
      required this.nota110,
      required this.other,
      required this.sisastok,
      required this.freestok1,
      required this.freestok2,
      required this.freestok3,
      required this.freestokall,
      required this.freestokbagi1,
      required this.freestokbagi2,
      required this.freestokbagi3,
      required this.freestokbagi,
      required this.freestokbisabagi,
      required this.freestokADJ1,
      required this.freestokADJ2,
      required this.freestokADJ3,
      required this.isvalid});

  factory ModelBrowseAlokasi.fromJson(Map<String, dynamic> json) {
    return ModelBrowseAlokasi(
        branch: json['branch'],
        shop: json['shop'],
        bname: json['bName'],
        bsname: json['bsName'],
        unitid: json['unitID'],
        itemname: json['itemName'],
        color: json['color'],
        colorname: json['colorName'],
        fsn1: json['fsN1'],
        po: json['po'],
        totalstok: json['totalStok'],
        nota110: json['nota110'],
        other: json['other'],
        sisastok: json['sisaStok'],
        freestok1: json['freeStok1'],
        freestok2: json['freeStok2'],
        freestok3: json['freeStok3'],
        freestokall: json['freeStokAll'],
        freestokbagi1: json['freeStokBagi1'],
        freestokbagi2: json['freeStokBagi2'],
        freestokbagi3: json['freeStokBagi3'],
        freestokbagi: json['freeStokBagi'],
        freestokbisabagi: json['freeStokBisaBagi'],
        freestokADJ1: TextEditingController(text: '0'),
        freestokADJ2: TextEditingController(text: '0'),
        freestokADJ3: TextEditingController(text: '0'),
        isvalid: true);
  }
}

class ModelModify {
  String resultmessage;

  ModelModify({required this.resultmessage});

  factory ModelModify.fromJson(Map<String, dynamic> json) {
    return ModelModify(resultmessage: json['resultMessage']);
  }
}
