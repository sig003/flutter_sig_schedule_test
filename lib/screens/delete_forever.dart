import 'package:flutter/material.dart';

class DeleteForever extends StatefulWidget {
  const DeleteForever({Key? key}) : super(key: key);

  @override
  State<DeleteForever> createState() => _DeleteForeverState();
}

class _DeleteForeverState extends State<DeleteForever> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: IconButton(
        icon: const Icon(Icons.delete),
        color: Colors.red,
        onPressed: () => showDialog(
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
                    Navigator.pop(context);
                  },
                  child: const Text('Delete')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
