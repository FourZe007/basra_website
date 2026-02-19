import 'package:flutter/material.dart';
import 'package:stsj/activity_point/models/point_sm_hd.dart';

class DropdownDealer extends StatefulWidget {
  const DropdownDealer(this.listData, this.inputan, this.hint, this.setData, {super.key});
  final List<PointSMHD> listData;
  final int inputan;
  final String hint;
  final Function setData;

  @override
  State<DropdownDealer> createState() => _DropdownDealerState();
}

class _DropdownDealerState extends State<DropdownDealer> {
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
          value: widget.inputan.isNaN ? null : widget.inputan,
          icon: const Icon(Icons.keyboard_arrow_down, size: 15),
          items: widget.listData.map((items) {
            return DropdownMenuItem(
              value: widget.listData.indexOf(items),
              child: Text(
                items.bsName,
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
