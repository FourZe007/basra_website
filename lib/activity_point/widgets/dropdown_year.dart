import 'package:flutter/material.dart';

class DropdownYear extends StatefulWidget {
  const DropdownYear(this.awal, this.akhir, this.inputan, this.hint, this.setData, {super.key});
  final int awal;
  final int akhir;
  final String inputan;
  final String hint;
  final Function setData;

  @override
  State<DropdownYear> createState() => _DropdownYearState();
}

class _DropdownYearState extends State<DropdownYear> {
  List<String> listData = [];

  @override
  void initState() {
    for (var i = widget.awal; i <= widget.akhir; i++) {
      listData.add(i.toString());
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1.3, color: Colors.black54),
        color: Colors.white70,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          isDense: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          focusColor: Colors.transparent,
          hint: Text(widget.hint, style: TextStyle(fontSize: 11, color: Colors.black26, fontWeight: FontWeight.bold)),
          value: widget.inputan == '' ? null : widget.inputan,
          icon: const Icon(Icons.keyboard_arrow_down, size: 15),
          items: listData.map((items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (newValues) {
            if (widget.inputan != newValues) widget.setData(newValues);
          },
        ),
      ),
    );
  }
}
