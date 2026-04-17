import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';

class PicAutoComplete extends StatefulWidget {
  const PicAutoComplete(
    this.inputan,
    this.setFilter, {
    this.isPicking = false,
    super.key,
  });

  final String inputan;
  final Function setFilter;
  final bool isPicking;

  @override
  State<PicAutoComplete> createState() => _PicAutoCompleteState();
}

class _PicAutoCompleteState extends State<PicAutoComplete> {
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
      if (widget.isPicking) {
        nameInputan = (state.pickingPicList.firstWhere((element) {
          return element == widget.inputan;
        }));
      } else {
        nameInputan = (state.packingPicList.firstWhere((element) {
          return element == widget.inputan;
        }));
      }
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
      child: Autocomplete<String>(
        initialValue: TextEditingValue(text: nameInputan),
        optionsViewBuilder: (context, onSelected, pics) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20.0),
              child: SizedBox(
                width: 330,
                height: pics.length > 2 ? 150 : pics.length * 135,
                child: ListView.separated(
                  shrinkWrap: false,
                  itemCount: pics.length,
                  separatorBuilder: (context, _) => const Divider(height: 5),
                  itemBuilder: (BuildContext context, int index) {
                    final String pic = pics.elementAt(index);

                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        pic,
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () => onSelected(pic),
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
        displayStringForOption: (String pic) {
          return pic;
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return [];
          }

          if (widget.isPicking) {
            return state.pickingPicList.where((String pic) {
              return pic.startsWith(textEditingValue.text) || pic.contains(textEditingValue.text);
            }).toList();
          } else {
            return state.packingPicList.where((String pic) {
              return pic.startsWith(textEditingValue.text) || pic.contains(textEditingValue.text);
            }).toList();
          }
        },
        onSelected: (String selection) => widget.setFilter(selection),
      ),
    );
  }
}
