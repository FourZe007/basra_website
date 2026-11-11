// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stsj/global/theme/app_theme.dart';

class CustomUserInput extends StatefulWidget {
  CustomUserInput(
    this.handle,
    this.input, {
    this.isDataAvailable = false,
    this.isCapital = false,
    this.isNumber = false,
    this.isPhone = false,
    this.mode = 1,
    this.hint = '',
    this.isPass = false,
    this.icon = Icons.question_mark_rounded,
    this.isIcon = false,
    this.prefixText = '',
    this.autoFocus = false,
    this.isWidth = false,
    this.width = 0,
    super.key,
  });

  bool isDataAvailable;
  bool isCapital;
  bool isNumber;
  bool isPhone;
  final int mode;
  final Function handle;
  final String input;
  bool isPass;
  String hint;
  IconData icon;
  bool isIcon;
  String prefixText;
  bool autoFocus;
  bool isWidth;
  double width;

  @override
  State<CustomUserInput> createState() => _CustomUserInputState();
}

class _CustomUserInputState extends State<CustomUserInput>
    with AutomaticKeepAliveClientMixin<CustomUserInput> {
  TextEditingController userInputController = TextEditingController();
  TextEditingController passInputController = TextEditingController();
  bool hidePassword = true;

  void showHidePasword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  void initState() {
    super.initState();
    userInputController.text = widget.input;
    passInputController.text = widget.input;
  }

  @override
  void didUpdateWidget(covariant CustomUserInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.input != oldWidget.input ||
        (widget.input.isEmpty && userInputController.text.isNotEmpty) ||
        (widget.input.isEmpty && passInputController.text.isNotEmpty)) {
      if (userInputController.text != widget.input) {
        userInputController.text = widget.input;
      }
      if (passInputController.text != widget.input) {
        passInputController.text = widget.input;
      }
    }
  }

  @override
  void dispose() {
    userInputController.dispose();
    passInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double effectiveWidth = (widget.isWidth == false)
        ? MediaQuery.of(context).size.width * 0.9
        : widget.width;

    if (widget.isPass == false) {
      return SizedBox(
        width: effectiveWidth,
        child: TextField(
          autofocus: widget.autoFocus,
          keyboardType:
              widget.isPhone ? TextInputType.phone : TextInputType.text,
          inputFormatters: widget.isPhone
              ? [
                  FilteringTextInputFormatter.deny(
                    RegExp(r'^0'),
                    replacementString: '',
                  ),
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : [
                  widget.isCapital == true
                      ? UpperCaseText()
                      : widget.isNumber == true
                          ? FilteringTextInputFormatter.allow(
                              RegExp(r'^-?[0-9.]*'),
                            )
                          : FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9.@ ]'),
                            ),
                ],
          controller: (widget.isDataAvailable == false)
              ? userInputController
              : TextEditingController(text: widget.input),
          enabled: widget.mode == 0 ? true : false,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.mode == 0
                ? AppColors.darkGrey
                : AppColors.darkerBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            hintText: 'Masukkan ${widget.hint}',
            prefixIcon: (widget.isIcon == false)
                ? (widget.prefixText.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          widthFactor: 1,
                          child: Text(
                            widget.prefixText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      )
                    : null)
                : Icon(
                    widget.icon,
                    size: 18,
                    color: AppColors.primaryRed,
                  ),
          ),
          onChanged: (newValues) => widget.handle(newValues),
        ),
      );
    } else {
      return SizedBox(
        width: effectiveWidth,
        child: TextField(
          autofocus: widget.autoFocus,
          controller: (widget.isDataAvailable == false)
              ? passInputController
              : TextEditingController(text: widget.input),
          obscureText: hidePassword,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.darkGrey,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            hintText: 'Masukkan ${widget.hint}',
            prefixIcon: Icon(
              widget.icon,
              size: 18,
              color: AppColors.primaryRed,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                hidePassword ? Icons.visibility_off : Icons.visibility,
                size: 18,
                color: AppColors.textSecondary,
              ),
              onPressed: () => showHidePasword(),
            ),
          ),
          onChanged: (newValues) => widget.handle(newValues),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
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

class LowerCaseText extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
