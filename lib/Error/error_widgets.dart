// Custom error handling widget
import 'package:flutter/material.dart';

class ErrorHandler extends StatelessWidget {
  final Widget child;

  const ErrorHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Scaffold(
            body: Center(
              child: Text(
                'An error occurred: ${details.exception}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        };
        return child;
      },
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'App initialization failed. Please restart.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
