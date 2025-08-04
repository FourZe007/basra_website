import 'package:flutter/material.dart';
import 'package:stsj/aktivitas-subdealer/helper/model_aktivitas_subdealer.dart';
import 'package:stsj/global/font.dart';

class WDDWilayah extends StatefulWidget {
  const WDDWilayah(this.inputan, this.list, this.setData,
      {this.mode = 1, super.key});

  final String inputan;
  final int mode;
  final List<ModelWilayah> list;
  final Function setData;

  @override
  State<WDDWilayah> createState() => _MyPageState();
}

class _MyPageState extends State<WDDWilayah> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.grey[400]),
      child: IgnorePointer(
        ignoring: widget.mode == 0 ? true : false,
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            borderRadius: BorderRadius.circular(15),
            icon: const Icon(Icons.arrow_drop_down_sharp, size: 25),
            items: widget.list.map((items) {
              return DropdownMenuItem(
                value: items.smallarea,
                child: Text(items.smallarea, style: GlobalFont.mediumfontR),
              );
            }).toList(),
            onChanged: (newvalues) {
              if (widget.inputan != newvalues) widget.setData(newvalues);
            },
            isDense: true,
            isExpanded: true,
            hint: Text('Masukkan Wilayah', style: GlobalFont.mediumfontR),
            value: widget.inputan.isEmpty ? null : widget.inputan,
          ),
        ),
      ),
    );
  }
}
