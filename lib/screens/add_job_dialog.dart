import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class AddJobDialog extends StatefulWidget {
  const AddJobDialog({Key? key}) : super(key: key);

  @override
  State<AddJobDialog> createState() => _AddJobDialogState();
}

class _AddJobDialogState extends State<AddJobDialog> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = '';
    timeInput.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Job'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Job',
            ),
          ),
          TextFormField(
            controller: dateInput,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Date',
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101)
              );

              if (pickedDate != null ) {
                print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  dateInput.text = formattedDate; //set output date to TextField value.
                });
              } else {
                print("Date is not selected");
              }
            }
          ),
          TextFormField(
            controller: timeInput,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Time',
            ),
            readOnly: true,
            onTap: () async {

            }
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );;
  }
}
