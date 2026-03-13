import 'package:intl/intl.dart';

String formatTime(DateTime dateTime) => DateFormat('HH:mm').format(dateTime);
String formatDate(DateTime dateTime) => DateFormat('d MMM').format(dateTime);
