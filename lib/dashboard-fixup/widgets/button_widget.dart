import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(this.txt, this.handle, {this.disable = false, super.key});
  final String txt;
  final Function handle;
  final bool disable;
  //ujung sedikit curve
  //panjang mengikuti layar, bisa disable

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disable ? null : () => handle(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Text(txt, style: TextStyle(fontSize: 15, color: disable ? Colors.blueGrey[300] : Colors.white)),
    );
  }
}
