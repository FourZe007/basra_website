import 'package:flutter/material.dart';

class ErrorView extends StatefulWidget {
  const ErrorView(this.textError, this.onRefresh, {super.key});
  final String textError;
  final Function onRefresh;

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Image.asset('assets/images/error.png', fit: BoxFit.contain),
          ),
          const SizedBox(height: 15),
          Text(widget.textError,
              style: const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[300],
              foregroundColor: Colors.white,
            ),
            onPressed: () => widget.onRefresh(),
            child: const Text('Refresh', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
