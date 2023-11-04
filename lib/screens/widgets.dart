import 'package:flutter/material.dart';

class JobName extends StatelessWidget {
  const JobName({Key? key, required this.jobName}) : super(key: key);

  final String jobName;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets
            .fromLTRB(8, 5, 0, 5),
    child: Text(
        jobName ??
    'None',
    style: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight
        .bold)),
    );
  }
}

class DateAndTimeString extends StatelessWidget {
  const DateAndTimeString({Key? key, required this.dateString, required this.timeString}) : super(key: key);

  final String dateString;
  final String timeString;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets
              .all(8.0),
          child: Text(
              dateString ??
                  'None'),
        ),
        Padding(
          padding: const EdgeInsets
              .all(8.0),
          child: Text(
              timeString ??
                  'None'),
        ),
      ],
    );
  }
}

