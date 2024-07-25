import 'package:flutter/material.dart';

class Utility {
  static toastMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  static Future<DateTime?> datePicker(
      BuildContext context, DateTime? selectedDate) async {
    return await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        initialDate: selectedDate);
  }
}
