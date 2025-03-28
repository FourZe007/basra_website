import 'package:flutter/material.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';

class TextfieldPhone extends StatefulWidget {
  const TextfieldPhone(
      {required this.inputan,
      required this.hint,
      required this.handle,
      this.disable = false,
      super.key});
  final String inputan;
  final String hint;
  final Function handle;
  final bool disable;
  //hint, no label
  //no preffix suffix
  //no background, outline border

  @override
  State<TextfieldPhone> createState() => _TextfieldPhoneState();
}

class _TextfieldPhoneState extends State<TextfieldPhone> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.inputan;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.disable,
      child: TextField(
        inputFormatters: [UpperCaseText()],
        controller: _controller,
        textInputAction: TextInputAction.done,
        style: const TextStyle(fontSize: 13),
        cursorColor: Colors.black.withOpacity(0.5),
        textAlignVertical: TextAlignVertical.center,
        readOnly: widget.disable,
        decoration: InputDecoration(
          filled: widget.disable,
          fillColor: Colors.grey[350],
          isDense: true,
          isCollapsed: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          hintText: widget.hint,
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 10, top: 7, bottom: 6, right: 5),
            child: Text('+62', style: TextStyle(fontSize: 13)),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          focusedBorder: widget.disable
              ? const OutlineInputBorder()
              : OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo, width: 2),
                  borderRadius: BorderRadius.circular(5.0),
                ),
        ),
        onChanged: (newValues) => widget.handle(newValues.toUpperCase()),
      ),
    );
  }
}
