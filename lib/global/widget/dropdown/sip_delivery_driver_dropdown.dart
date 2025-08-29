import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/models/Dashboard/driver.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';

class SipDeliveryDriverDropdown extends StatefulWidget {
  const SipDeliveryDriverDropdown({
    required this.listData,
    required this.inputan,
    required this.hint,
    required this.handle,
    this.disable = false,
    this.isMobile = false,
    this.isDriver = false,
    this.isPicking = false,
    super.key,
  });

  final List<ModelDriver> listData;
  final String inputan;
  final String hint;
  final Function handle;
  final bool disable;
  final bool isMobile;
  final bool isDriver;
  final bool isPicking;

  @override
  State<SipDeliveryDriverDropdown> createState() => _SipDriverDropdownState();
}

class _SipDriverDropdownState extends State<SipDeliveryDriverDropdown> {
  String teksDisable = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);
    print(
        'SIP driver Dropdown provider: ${state.getFilteredDriverList.length}');
    print('SIP driver Dropdown data: ${widget.listData.length}');

    if (!widget.isMobile) {
      return DropdownButtonHideUnderline(
        child: DropdownButton(
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
          value: widget.inputan == '' ? null : widget.inputan,
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            size: 25,
            color: Colors.black,
          ),
          items: widget.disable == true
              ? null
              : widget.listData.map((items) {
                  return DropdownMenuItem(
                    value: items.employeeName,
                    child: Text(
                      items.employeeName,
                      textAlign: TextAlign.center,
                      style: GlobalFont.mediumfontR,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
          onChanged: (newValues) async {
            if (widget.inputan != newValues) {
              //setState(() =>  widget.inputan = newValues.toString());
              // print('Province Dropdown value: $value');
              // state.setBranchNameNotifier(value);

              widget.handle(newValues);
            }
          },
        ),
      );
    } else {
      return DropdownButtonHideUnderline(
        child: DropdownButton(
          menuWidth: MediaQuery.of(context).size.width * 0.175,
          borderRadius: BorderRadius.circular(20),
          isExpanded: true,
          isDense: true,
          hint: Text(
            'Masukkan ${widget.hint}',
            textAlign: TextAlign.center,
            style: GlobalFont.smallfontR,
          ),
          value: widget.inputan == '' ? null : widget.inputan,
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            size: 15,
            color: Colors.black,
          ),
          items: widget.disable == true
              ? null
              : widget.listData.map((items) {
                  return DropdownMenuItem(
                    value: items.employeeName,
                    child: Text(
                      items.employeeName,
                      textAlign: TextAlign.center,
                      style: GlobalFont.mediumfontR,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
          onChanged: (newValues) async {
            if (widget.inputan != newValues) {
              // setState(() => value = newValues.toString());
              // print('Province Dropdown value: $value');
              //state.setBranchNameNotifier(value);

              widget.handle(newValues);
            }
          },
        ),
      );
    }
  }
}
