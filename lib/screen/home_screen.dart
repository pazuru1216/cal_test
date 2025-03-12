import 'package:calendar_test/component/calendar.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          child: Column(
        children: [
          Calendar(
            focusedDay: DateTime.utc(2025, 03, 01),
            onDaySelected: onDaySelected,

            /// The argument type 'dynamic Function(DateTime)' can't be assigned to the parameter type 'bool Function(DateTime)
            /// 인수 유형 '동적 함수(DateTime)'는 매개변수 유형 'bool 함수(DateTime)'에 할당할 수 없습니다.
            selectedDayPredicate: selectedDayPredicate,
          ),
        ],
      )),
    ));
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
    });
  }

  ///그래서 bool을 붙여줌
  bool selectedDayPredicate(DateTime date) {
    if (selectedDay == null) {
      return false;
    }
    return date.isAtSameMomentAs(selectedDay!);
  }
}
