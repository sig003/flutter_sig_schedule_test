import 'package:alarm/alarm.dart';

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