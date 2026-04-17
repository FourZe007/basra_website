import 'package:flutter/material.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/style.dart';

class HeaderTable extends StatelessWidget {
  const HeaderTable(this.judul, this.align, {super.key});
  final String judul;
  final Alignment align;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: InkWell(
        onTap: () {},
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Align(
                  alignment: align,
                  child: Text(
                    judul,
                    textAlign: TextAlign.center,
                    style: text11SB,
                    maxLines: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
