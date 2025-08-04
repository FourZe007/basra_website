import 'package:flutter/material.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/global/font.dart';

class WInputTeks extends StatefulWidget {
  const WInputTeks(this.controller, this.handle, {this.hint = '', super.key});
  final String hint;
  final TextEditingController controller;
  final Function handle;

  @override
  State<WInputTeks> createState() => _MyPageState();
}

class _MyPageState extends State<WInputTeks> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.grey[400]),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hint,
            contentPadding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 15)),
        inputFormatters: [UpperCaseText()],
        controller: widget.controller,
        style: GlobalFont.smallfontR,
        onChanged: (value) => widget.handle(value),
      ),
    );
  }
}
