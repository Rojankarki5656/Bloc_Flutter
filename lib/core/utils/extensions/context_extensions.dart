// lib/core/extensions/context_extensions.dart
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Navigation
  void push(Widget page) => Navigator.push(
    this,
    MaterialPageRoute(builder: (_) => page),
  );

  void pushReplacement(Widget page) => Navigator.pushReplacement(
    this,
    MaterialPageRoute(builder: (_) => page),
  );

  void pop<T extends Object?>([T? result]) => Navigator.pop(this, result);

  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Size
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // Snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}