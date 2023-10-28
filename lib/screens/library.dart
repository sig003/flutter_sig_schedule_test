import 'package:alarm/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

int generateRandomNumberWithDigits(int numDigits) {
  int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
  int slicedTime = 0;
  String currentTimeString = currentTimeMillis.toString();

  if (currentTimeString.length >= numDigits) {
    slicedTime = int.parse(currentTimeString.substring(0, numDigits));
  } else {
    slicedTime = int.parse(currentTimeString);
  }
  return slicedTime;
}

DateTime combinedDateTime(selectedDate, selectedTime) {
  DateTime combinedDateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );
  return combinedDateTime;
}

void SetAlarm(randomNumber, combinedTime, showNotification) {
  final alarmSettings = AlarmSettings(
    id: randomNumber,
    dateTime: combinedTime,
    assetAudioPath: 'assets/marimba.mp3',
    volumeMax: false,
    notificationTitle: showNotification ? 'Alarm example' : null,
    notificationBody: showNotification ? 'Your alarm is ringing' : null,
    stopOnNotificationOpen: true,
  );
  Alarm.set(alarmSettings: alarmSettings);
}

void saveJob(jobInput, dateInput, timeInput, combinedTime, showNotification) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  int randomNumber = generateRandomNumberWithDigits(10);

  Map<String, dynamic> map = {
    'id': randomNumber,
    'job': jobInput.text,
    'date': dateInput.text,
    'time': timeInput.text,
    'state': 'normal'
  };
  String rawJson = jsonEncode(map);

  List<String> beforeArray = prefs.getStringList('data') ?? [];

  List<String> ListArray = [];
  if (beforeArray.length > 0) {
    for (int i = 0; i < beforeArray.length; i += 1) {
      ListArray.add(beforeArray[i]);
    }
  }

  ListArray.add(rawJson);
  prefs.setStringList('data', ListArray);

  SetAlarm(randomNumber, combinedTime, showNotification);
}

Future<List<dynamic>> getData(bottomIndex) async {
  String state = 'normal';
  if (bottomIndex == 1) {
    state = 'delete';
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<dynamic> jsonData = prefs.getStringList('data') ?? [];

  var ListArray = [];

  for (int i = 0; i < jsonData.length; i++) {
    if (jsonDecode(jsonData[i])['state'] == state) {
      ListArray.add(jsonDecode(jsonData[i]));
    }
  }

  List<dynamic> reverserdListArray = List.from(ListArray.reversed);

  return reverserdListArray;
}

void delData(id, widget) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<dynamic> jsonData = prefs.getStringList('data') ?? [];

  List<String> ListArray = [];

  if (jsonData.length > 0) {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonDecode(jsonData[i])['id'] == id) {
        Map<String, dynamic> map = {
          'id': jsonDecode(jsonData[i])['id'],
          'job': jsonDecode(jsonData[i])['job'],
          'date': jsonDecode(jsonData[i])['date'],
          'time': jsonDecode(jsonData[i])['time'],
          'state': 'delete'
        };
        String rawJson = jsonEncode(map);
        ListArray.add(rawJson);
        Alarm.stop(jsonDecode(jsonData[i])['id']);
      } else {
        ListArray.add(jsonData[i]);
      }
    }
    prefs.setStringList('data', ListArray);
    widget.setBottomIndex(0);
  }
}

void deletePreference() async {
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