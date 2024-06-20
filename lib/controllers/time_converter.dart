import 'package:intl/intl.dart';

String formatDate(String dateTime) {
  DateTime parsedDateTime = DateTime.parse(dateTime);
  String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDateTime);
  return formattedDate;
}

String formatTime(String dateTime) {
  DateTime parsedDateTime = DateTime.parse(dateTime);
  String formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
  return formattedTime;
}
