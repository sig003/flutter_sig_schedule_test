import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/library.dart';

class ModifyJobDialog extends StatefulWidget {
  const ModifyJobDialog({Key? key, required this.id}) : super(key: key);

  final String id;
  @override
  State<ModifyJobDialog> createState() => _ModifyJobDialogState();
}

class _ModifyJobDialogState extends State<ModifyJobDialog> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSharedPreference(),
      builder: (context, snapshot) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Delete Permanent Items'),
                content: const Text(
                  'Do you want a permanent delete?',
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      primary: Colors.red,
                    ),
                    child: const Text('Permanent Delete'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
    );
  }
}
