import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';

class SipLocationDropdown extends StatefulWidget {
  const SipLocationDropdown({
    required this.listData,
    required this.inputan,
    required this.hint,
    required this.handle,
    this.disable = false,
    this.isMobile = false,
    super.key,
  });

  final List<dynamic> listData;
  final String inputan;
  final String hint;
  final Function handle;
  final bool disable;
  final bool isMobile;

  @override
  State<SipLocationDropdown> createState() => _SipLocationDropdownState();
}

class _SipLocationDropdownState extends State<SipLocationDropdown> {
  String value = '';

  @override
  void initState() {
    super.initState();
    value = widget.inputan;
  }

  @override
  void didUpdateWidget(covariant SipLocationDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.inputan != value) {
      setState(() {
        value = widget.inputan;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);
    final selectedValue =
        (value.isNotEmpty && widget.listData.contains(value)) ? value : null;

    if (!widget.isMobile) {
      return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          menuWidth: MediaQuery.of(context).size.width * 0.175,
          borderRadius: BorderRadius.circular(20),
          isExpanded: true,
          isDense: true,
          hint: Text(
            'Masukkan ${widget.hint}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Metropolis',
            ),
          ),
          value: selectedValue,
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            size: 25,
            color: Colors.black,
          ),
          items: widget.disable == true || widget.listData.isEmpty
              ? null
              : widget.listData.map((data) {
                  return DropdownMenuItem<String>(
                    value: data.toString(),
                    child: Text(
                      data.toString(),
                      textAlign: TextAlign.center,
                      style: GlobalFont.mediumfontR,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
          onChanged: widget.disable == true || widget.listData.isEmpty
              ? null
              : (newValues) async {
                  if (newValues != null && value != newValues.toString()) {
                    setState(() {
                      value = newValues.toString();
                    });
                    await widget.handle(newValues.toString());
                    try {
                      state.filterSipSalesman();
                    } catch (e) {
                      print('filterSipSalesman error: $e');
                    }
                  }
                },
        ),
      );
    } else {
      return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          menuWidth: MediaQuery.of(context).size.width * 0.175,
          borderRadius: BorderRadius.circular(20),
          isExpanded: true,
          isDense: true,
          hint: Text(
            'Masukkan ${widget.hint}',
            textAlign: TextAlign.center,
            style: GlobalFont.smallfontR,
          ),
          value: selectedValue,
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            size: 15,
            color: Colors.black,
          ),
          items: widget.disable == true || widget.listData.isEmpty
              ? null
              : widget.listData.map((data) {
                  return DropdownMenuItem<String>(
                    value: data.toString(),
                    child: Text(
                      data.toString(),
                      textAlign: TextAlign.center,
                      style: GlobalFont.smallfontRBold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
          onChanged: widget.disable == true || widget.listData.isEmpty
              ? null
              : (newValues) async {
                  if (newValues != null && value != newValues.toString()) {
                    setState(() {
                      value = newValues.toString();
                    });
                    await widget.handle(newValues.toString());
                    try {
                      state.filterSipSalesman();
                    } catch (e) {
                      print('filterSipSalesman error: $e');
                    }
                  }
                },
        ),
      );
    }
  }
}
