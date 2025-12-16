import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stsj/global/font.dart';

class WTanggal extends StatefulWidget {
  const WTanggal(this.value, this.handle, {this.mode = 1, super.key});

  final int mode;
  final DateTime value;
  final Function handle;

  @override
  State<WTanggal> createState() => _MyPageState();
}

class _MyPageState extends State<WTanggal> {
  void refreshTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.value,
      firstDate: DateTime(1900),
      lastDate: DateTime(2999),
      builder: (context, child) => Theme(
          data: ThemeData.light().copyWith(
              dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          )),
          child: child!),
    );

    if (picked != null) widget.handle(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.grey[400]),
        child: TextField(
          onTap: () => widget.mode == 0 ? null : refreshTanggal(),
          controller: TextEditingController(
              text: DateFormat('dd-MM-yyyy').format(widget.value)),
          readOnly: widget.mode == 0 ? true : false,
          style: GlobalFont.mediumfontM,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.date_range, color: Colors.black, size: 25),
            contentPadding: EdgeInsets.symmetric(vertical: 5),
          ),
        ));
  }
}
