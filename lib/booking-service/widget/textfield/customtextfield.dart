// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stsj/global/theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
    this.handle,
    this.value,
    this.width, {
    this.mode = 1,
    this.hint = '',
    this.isPass = false,
    this.icon = Icons.search_rounded,
    this.isAutoFocus = false,
    super.key,
  });

  final int mode;
  String value;
  double width;
  final Function handle;
  bool isPass;
  String hint;
  IconData icon;
  bool isAutoFocus;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with AutomaticKeepAliveClientMixin<CustomTextField> {
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
    userInputController.text = widget.value;
    passInputController.text = widget.value;
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value ||
        (widget.value.isEmpty && userInputController.text.isNotEmpty) ||
        (widget.value.isEmpty && passInputController.text.isNotEmpty)) {
      if (userInputController.text != widget.value) {
        userInputController.text = widget.value;
      }
      if (passInputController.text != widget.value) {
        passInputController.text = widget.value;
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
    if (widget.isPass == false) {
      return SizedBox(
        width: widget.width,
        child: TextField(
          textInputAction: TextInputAction.go,
          inputFormatters: [UpperCaseText()],
          controller: userInputController,
          readOnly: widget.mode == 0 ? true : false,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
          autofocus: widget.isAutoFocus,
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              size: 18,
              color: AppColors.primaryRed,
            ),
            hintText: 'Masukkan ${widget.hint}',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          onChanged: (newValues) {
            widget.value = userInputController.text;
            widget.handle(userInputController.text);
          },
        ),
      );
    } else {
      return SizedBox(
        width: widget.width,
        child: TextField(
          textInputAction: TextInputAction.go,
          inputFormatters: [UpperCaseText()],
          obscureText: hidePassword,
          controller: passInputController,
          readOnly: widget.mode == 0 ? true : false,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
          autofocus: widget.isAutoFocus,
          decoration: InputDecoration(
            hintText: 'Masukkan ${widget.hint}',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
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
