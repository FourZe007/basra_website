import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/models/Dashboard/driver.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';

class DriverAutoComplete extends StatefulWidget {
  const DriverAutoComplete(
    this.inputan,
    this.setFilter, {
    super.key,
  });

  final String inputan;
  final Function setFilter;

  @override
  State<DriverAutoComplete> createState() => _DriverAutoCompleteState();
}

class _DriverAutoCompleteState extends State<DriverAutoComplete> {
  late String nameInputan;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);
    // print('Autocomplete widget rebuilt');
    // print('Autocomplete: ${state.filteredDriverList.length}');

    // for (var driver in state.filteredDriverList) {
    //   print('Driver Name: ${driver.employeeName}');
    // }

    if (widget.inputan != '') {
      nameInputan = (state.filteredDriverList.firstWhere((element) {
        return element.employeeId == widget.inputan;
      })).employeeName;
    } else {
      nameInputan = '';
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.17,
      height: MediaQuery.of(context).size.height * 0.05,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Autocomplete<ModelDriver>(
        initialValue: TextEditingValue(text: nameInputan),
        optionsViewBuilder: (context, onSelected, drivers) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20.0),
              child: SizedBox(
                width: 330,
                height: drivers.length > 2 ? 150 : drivers.length * 135,
                child: ListView.separated(
                  shrinkWrap: false,
                  itemCount: drivers.length,
                  separatorBuilder: (context, _) => const Divider(height: 5),
                  itemBuilder: (BuildContext context, int index) {
                    final ModelDriver driver = drivers.elementAt(index);

                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        driver.employeeName,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        '${driver.employeeId}\n${driver.shopName}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () => onSelected(driver),
                    );
                  },
                ),
              ),
            ),
          );
        },
        fieldViewBuilder: (
          context,
          textEditingController,
          focusNode,
          onFieldSubmitted,
        ) {
          if (state.isReset) {
            textEditingController.text = '';
            state.setIsReset();
          }

          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            textCapitalization: TextCapitalization.characters,
            textAlignVertical: TextAlignVertical.center,
            style: GlobalFont.bigfontR,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Masukkan Employee ID',
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  if (textEditingController.text != '') {
                    textEditingController.text = '';
                  }
                  widget.setFilter('');
                },
                iconSize: 15,
                icon: const Icon(Icons.clear),
                hoverColor: Colors.transparent,
              ),
            ),
          );
        },
        displayStringForOption: (ModelDriver driver) {
          return driver.employeeName;
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return [];
          }

          return state.filteredDriverList.where((ModelDriver driver) {
            return driver.employeeName.startsWith(textEditingValue.text) || driver.employeeId.contains(textEditingValue.text);
          }).toList();
        },
        onSelected: (ModelDriver selection) => widget.setFilter(selection.employeeId),
      ),
    );
  }
}
