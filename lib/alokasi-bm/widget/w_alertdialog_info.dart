import 'package:flutter/material.dart';
import 'package:stsj/global/font.dart';

wAlertDialogInfo(BuildContext context, String header, detail) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(header, style: GlobalFont.giantfontMBold),
            content: Text(detail, style: GlobalFont.mediumfontR),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blue.shade900),
                ),
                child: Text('OK', style: GlobalFont.mediumbigfontMWhite),
              )
            ]);
      });
}
