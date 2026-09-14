import 'package:flutter/material.dart';
import 'package:stsj/global/font.dart';

class WTombolLinkPowerBI extends StatelessWidget {
  const WTombolLinkPowerBI(
      this.label, this.pathImage, this.url, this.warna, this.handle,
      {super.key});

  final String label, pathImage, url;
  final Color warna;
  final Function handle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => handle(url),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(warna),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10))),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(pathImage, height: 25),
          Text(label, style: GlobalFont.smallfontRBold)
        ]),
      ),
    );
  }
}
