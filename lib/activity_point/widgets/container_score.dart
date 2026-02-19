import 'package:flutter/material.dart';

class ContainerScore extends StatelessWidget {
  const ContainerScore(this.sValue, this.kategori, this.handle, {super.key});
  final bool sValue;
  final String kategori;
  final Function handle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => handle(!sValue),
      child: Container(
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 5),
            Container(
              width: 22.0,
              height: 22.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: sValue ? Colors.indigo : Colors.red, width: 2.0),
                color: sValue ? Colors.indigo : Colors.red,
              ),
              child: Icon(
                sValue ? Icons.check : Icons.close,
                size: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3),
            Text(kategori, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
            SizedBox(height: 3),
          ],
        ),
      ),
    );
  }
}
