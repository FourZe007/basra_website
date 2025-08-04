import 'package:flutter/material.dart';

class WHeaderTombolIkon extends StatelessWidget {
  const WHeaderTombolIkon(this.ikon, this.handle, {super.key});
  final IconData ikon;
  final Function handle;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => handle(),
      icon: Icon(ikon, color: Colors.black),
      padding: EdgeInsets.symmetric(horizontal: 10),
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.grey[400]),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))))),
    );
  }
}
