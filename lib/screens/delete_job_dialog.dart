import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/library.dart';

Future<void> DeleteJobDialog(BuildContext context, id, widget) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Delete Item'),
      content: const Text('Do you want a delete?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel')
        ),
        TextButton(
            onPressed: () {
              dataAction('delete', id ?? 'None', widget);
              Navigator.pop(context);
            },
            child: const Text('Delete')
        ),
      ],
    ),
  );
}