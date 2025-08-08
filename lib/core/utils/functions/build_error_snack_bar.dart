import 'package:flutter/material.dart';

buildErrorWidget(String errMessage, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errMessage),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
}
