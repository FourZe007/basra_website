import 'package:flutter/material.dart';
import 'package:stsj/global/font.dart';

class WHeaderTombolTeks extends StatelessWidget {
  const WHeaderTombolTeks(this.value, this.handle, {super.key});
  final String value;
  final Function handle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => handle(),
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.grey[400]),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))))),
      child: Text(value, style: GlobalFont.mediumbigfontMBold),
    );
  }
}
