import 'package:flutter/material.dart';

Future wOpenDialog(BuildContext context, bool canBack, Widget widget) {
  return showDialog(
      context: context,
      barrierDismissible: canBack,
      builder: (context) => Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: Colors.white,
          child: widget));
}
