// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stsj/booking-service/global/global.dart';

class UserInput extends StatelessWidget {
  UserInput(this.handle, this.userid, {super.key});

  final Function handle;
  final String userid;
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 10.0,
        bottom: 10.0,
      ),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width / 3,
      height: 50,
      child: TextField(
        inputFormatters: [UpperCaseText()],
        controller: TextEditingController(text: userid),
        style: GlobalFont.mediumbigfontM,
        decoration: InputDecoration(
          hintStyle: GlobalFont.mediumbigfontM,
          hintText: 'Masukkan User Anda',
          contentPadding: const EdgeInsets.all(15),
        ),
        onChanged: (newValues) => handle(newValues),
      ),
    );
  }
}

class UpperCaseText extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
