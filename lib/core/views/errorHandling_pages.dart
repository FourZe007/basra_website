import 'package:flutter/material.dart';

class ErrorWidgetComponent extends StatefulWidget {
  final String message;
  final Function onRetry;

  ErrorWidgetComponent({
    required this.message,
    required this.onRetry,
  });

  @override
  State<ErrorWidgetComponent> createState() => _ErrorWidgetComponentState();
}

class _ErrorWidgetComponentState extends State<ErrorWidgetComponent> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.message,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Panggil fungsi onRetry
                  widget.onRetry();

                  // Setelah selesai, set isLoading kembali menjadi false
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
