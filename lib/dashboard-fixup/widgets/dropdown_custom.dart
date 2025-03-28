import 'package:flutter/material.dart';

class DropdownCustom extends StatefulWidget {
  const DropdownCustom(this.listData, this.inputan, this.hint, this.setData, {this.disable = false, super.key});
  final List<Map<String, String>> listData;
  final String inputan;
  final String hint;
  final Function setData;
  final bool disable;

  @override
  State<DropdownCustom> createState() => _DropdownCustomState();
}

class _DropdownCustomState extends State<DropdownCustom> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.disable ? true : false,
      child: InputDecorator(
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(top: 3),
          filled: widget.disable ? true : false,
          fillColor: widget.disable ? Colors.green : Colors.red,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(width: 1.2, color: Colors.black54),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            isDense: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            focusColor: Colors.transparent,
            hint: Text(widget.hint, style: const TextStyle(fontSize: 11, color: Colors.white60)),
            value: widget.inputan == '' ? null : widget.inputan,
            icon: const Icon(Icons.keyboard_arrow_down, size: 15),
            items: widget.listData.map((items) {
              return DropdownMenuItem(
                value: items['id'],
                child: Text(
                  items['text']!,
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
