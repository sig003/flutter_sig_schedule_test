import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void _deletePreference() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<dynamic> jsonData = prefs.getStringList('data') ?? [];

  List<String> ListArray = [];

  if (jsonData.length > 0) {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonDecode(jsonData[i])['state'] != 'delete') {
        Map<String, dynamic> map = {
          'id': jsonDecode(jsonData[i])['id'],
          'job': jsonDecode(jsonData[i])['job'],
          'date': jsonDecode(jsonData[i])['date'],
          'time': jsonDecode(jsonData[i])['time'],
          'state': 'normal'
        };
        String rawJson = jsonEncode(map);
        ListArray.add(rawJson);
      }
    }
    prefs.setStringList('data', ListArray);

  }
}

Future<void> DeleteForever(BuildContext context, setBottomIndex) {
  return showDialog<void>(
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
              _deletePreference();
              setBottomIndex(1);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}