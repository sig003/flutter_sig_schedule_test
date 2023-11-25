import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/library.dart';

Future<void> ModifyJobDialog(BuildContext context, id) async {
  var result = await getSharedPreference(id);

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Modify Job'),
      content: Text(result[0]['job']),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel')
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Modify')
        ),
      ],
    ),
  );
}