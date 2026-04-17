import 'package:flutter/material.dart';

class TextfieldCustom extends StatefulWidget {
  const TextfieldCustom({required this.inputan, required this.hint, required this.handle, this.disable = false, super.key});
  final String inputan;
  final String hint;
  final Function handle;
  final bool disable;

  @override
  State<TextfieldCustom> createState() => _TextfieldCustomState();
}

class _TextfieldCustomState extends State<TextfieldCustom> {
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          hintText: widget.hint,
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
