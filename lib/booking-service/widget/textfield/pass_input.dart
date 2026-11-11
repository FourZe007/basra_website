// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stsj/booking-service/global/global.dart';

class PassInput extends StatefulWidget {
  const PassInput(this.label, this.handle, {this.isLogin = true, super.key});

  final String label;
  final Function handle;
  final bool isLogin;

  @override
  State<PassInput> createState() => _PassInputState();
}

class _PassInputState extends State<PassInput>
    with AutomaticKeepAliveClientMixin<PassInput> {
  bool hidePassword = true;
  TextEditingController inputcontroller = TextEditingController();

  void showHidePasword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  void dispose() {
    super.dispose();
    inputcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 10.0),
      alignment: Alignment.centerLeft,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: TextField(
        inputFormatters: [UpperCaseText()],
        controller: inputcontroller,
        obscureText: hidePassword,
        style: GlobalFont.mediumbigfontM,
        decoration: InputDecoration(
          hintText: 'Masukkan ${widget.label}',
          hintStyle: GlobalFont.mediumbigfontM,
          border: InputBorder.none,
          contentPadding:
              widget.isLogin == true ? null : const EdgeInsets.all(10),
          prefixIcon: widget.isLogin == true
              ? Container(
                  margin: const EdgeInsets.only(right: 7),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: Colors.black,
                  ),
                  width: 50,
                  child: const Icon(Icons.lock, size: 20, color: Colors.white))
              : null,
          suffixIcon: IconButton(
            icon: Icon(
              hidePassword ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: Colors.black,
            ),
            color: Theme.of(context).primaryColorDark,
            onPressed: () => showHidePasword(),
          ),
        ),
        onChanged: (newValues) => widget.handle(newValues),
      ),
    );
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
