import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/Timer/countdown.dart';

class TimerInfo extends ChangeNotifier {
  String countTime = 'completed';
  String getRemainingTime() => countTime;

  updateRemainingTime() {
    countTime = CountDown().timeLeft(
        DateTime.parse(DateFormat("yyyy-MM-dd")
            .format(DateTime.now().add(Duration(days: 1)))
            .toString()),
        "Completed");
    notifyListeners();
  }
}
