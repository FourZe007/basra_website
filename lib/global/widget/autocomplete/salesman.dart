import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/models/Report/absent_history.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';

class SalesmanAutoComplete extends StatefulWidget {
  const SalesmanAutoComplete(
    this.inputan,
    this.setFilter, {
    super.key,
  });

  final String inputan;
  final Function setFilter;

  @override
  State<SalesmanAutoComplete> createState() => _SalesmanAutoCompleteState();
}

class _SalesmanAutoCompleteState extends State<SalesmanAutoComplete> {
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

    if (widget.inputan != '' && state.getSipSalesmanList.isNotEmpty) {
      nameInputan = (state.getSipSalesmanList.firstWhere((element) {
        return element.employeeID == widget.inputan;
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
      child: Autocomplete<SipSalesmanModel>(
        initialValue: TextEditingValue(text: nameInputan),
        optionsViewBuilder: (context, onSelected, people) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20.0),
              child: SizedBox(
                width: 330,
                height: people.length > 2 ? 150 : people.length * 135,
                child: ListView.separated(
                  shrinkWrap: false,
                  itemCount: people.length,
                  separatorBuilder: (context, _) => const Divider(height: 5),
                  itemBuilder: (BuildContext context, int index) {
                    final SipSalesmanModel salesman = people.elementAt(index);

                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        salesman.employeeName,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        '${salesman.employeeID}\n${salesman.locationName}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () => onSelected(salesman),
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
        displayStringForOption: (SipSalesmanModel salesman) {
          return salesman.employeeName;
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '' || state.getSipSalesmanList.isEmpty) {
            return [];
          }

          return state.getSipSalesmanList.where((SipSalesmanModel salesman) {
            return salesman.employeeName.startsWith(textEditingValue.text) || salesman.employeeID.contains(textEditingValue.text);
          }).toList();
        },
        onSelected: (SipSalesmanModel selection) => widget.setFilter(selection.employeeID),
      ),
    );
  }
}
