import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormatter {
  static final shared = DateFormatter();

  String format({@required String dateString}) {
    final dateGet = DateFormat("yyyy-MM-ddTHH:mm:ss").parseUTC(dateString).toLocal();
    final datePrint = DateFormat("dd-MM-yyyy HH:mm").format(dateGet);

    return datePrint;
  }

  String formatString({@required String oldDateFormat, @required String newDateFormat, @required String dateString}) {
    initializeDateFormatting();

    final dateGet = DateFormat(oldDateFormat).parseUTC(dateString).toLocal();
    final datePrint = DateFormat(newDateFormat, 'id_ID').format(dateGet);

    return datePrint;
  }

  // ignore: invalid_required_positional_param
  String formatDateTime(@required DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // ignore: invalid_required_positional_param
  String formatMonth(@required DateTime dateTime) {
    return DateFormat.MMMM('en_US').format(dateTime);
  }

  // ignore: invalid_required_positional_param
  String formatTimeOfDay(@required TimeOfDay timeOfDay) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }
}
