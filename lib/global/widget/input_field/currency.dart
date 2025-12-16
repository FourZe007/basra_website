import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stsj/global/font.dart';

class CurrencyInputField extends StatelessWidget {
  const CurrencyInputField(this.input, this.handle, {this.mode = 1, super.key});

  final String input;
  final int mode;
  final Function handle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: TextField(
          textAlign: TextAlign.right,
          controller: TextEditingController(text: input),
          inputFormatters: [
            ThousandsSeparatorInputFormatter(),
            FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9.]*'))
          ],
          readOnly: mode == 0 ? true : false,
          style: GlobalFont.mediumfontM,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(5)),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.only(left: 15, top: 0, right: 10)),
          onChanged: (value) {
            if (value != '') handle(value);
          }),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = '.'; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) return newValue.copyWith(text: '');

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      if (RegExp(r'^[0-9]+$').hasMatch(newValueText)) {
        String newString = '';
        for (int i = chars.length - 1; i >= 0; i--) {
          if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
            newString = separator + newString;
          }
          newString = chars[i] + newString;
        }

        return TextEditingValue(
          text: newString.toString(),
          selection: TextSelection.collapsed(
              offset: newString.length - selectionIndex),
        );
      }
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
