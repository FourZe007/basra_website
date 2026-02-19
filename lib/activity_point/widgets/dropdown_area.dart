import 'package:flutter/material.dart';
import 'package:stsj/core/models/Activities/area.dart';

class DropdownArea extends StatefulWidget {
  const DropdownArea(this.listData, this.inputan, this.hint, this.setData, {this.disable = false, super.key});
  final List<ModelAreas> listData;
  final String inputan;
  final String hint;
  final Function setData;
  final bool disable;

  @override
  State<DropdownArea> createState() => _DropdownAreaState();
}

class _DropdownAreaState extends State<DropdownArea> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.disable ? true : false,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1.3, color: Colors.black54),
          color: widget.disable ? Colors.grey[400] : Colors.white70,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            isDense: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            focusColor: Colors.transparent,
            hint: Text(widget.disable ? '' : widget.hint, style: TextStyle(fontSize: 11, color: Colors.black26, fontWeight: FontWeight.bold)),
            value: widget.inputan == '' ? null : widget.inputan,
            icon: const Icon(Icons.keyboard_arrow_down, size: 15),
            items: widget.listData.map((items) {
              return DropdownMenuItem(
                value: items.areaName,
                child: Text(
                  items.areaName,
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
      ),
    );
  }
}
