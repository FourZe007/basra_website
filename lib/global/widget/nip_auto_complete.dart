import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/models/Activities/salesman.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';

class NIPAutoComplete extends StatefulWidget {
  const NIPAutoComplete(this.inputan, this.setFilter, {super.key});
  final String inputan;
  final Function setFilter;

  @override
  State<NIPAutoComplete> createState() => _NIPAutoCompleteState();
}

class _NIPAutoCompleteState extends State<NIPAutoComplete> {
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
    final autoCompleteState = Provider.of<MenuState>(context);

    if (widget.inputan != '') {
      nameInputan = (autoCompleteState.salesmanList.firstWhere((element) {
        return element.id == widget.inputan;
      })).name;
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
      child: Autocomplete<ModelSalesman>(
        initialValue: TextEditingValue(text: nameInputan),
        optionsViewBuilder: (context, onSelected, salesman) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20.0),
              child: SizedBox(
                width: 330,
                height: salesman.length > 2 ? 250 : salesman.length * 135,
                child: ListView.separated(
                  shrinkWrap: false,
                  itemCount: salesman.length,
                  separatorBuilder: (context, _) => const Divider(height: 5),
                  itemBuilder: (BuildContext context, int index) {
                    final ModelSalesman item = salesman.elementAt(index);
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        '${item.id}\n${item.location}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () => onSelected(item),
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
          final state = Provider.of<MenuState>(context);

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
        displayStringForOption: (ModelSalesman salesman) {
          return salesman.id;
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return [];
          }
          return autoCompleteState.salesmanList.where((ModelSalesman salesman) {
            return salesman.name.startsWith(textEditingValue.text) || salesman.id.contains(textEditingValue.text);
          }).toList();
        },
        onSelected: (ModelSalesman selection) {
          widget.setFilter(selection.id);
        },
      ),
    );
  }
}
