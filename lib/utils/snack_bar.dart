import 'package:flutter/material.dart';

void showSnackBar(context, String msg, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}
