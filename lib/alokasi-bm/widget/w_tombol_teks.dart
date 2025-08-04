import 'package:flutter/material.dart';
import 'package:stsj/global/font.dart';

class WTombolTeks extends StatelessWidget {
  const WTombolTeks(this.label, this.warnaTombol, this.handle, {super.key});

  final String label;
  final Color warnaTombol;
  final Function handle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => handle(),
      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(warnaTombol)),
      child: Text(label, style: GlobalFont.mediumbigfontMWhite),
    );
  }
}
