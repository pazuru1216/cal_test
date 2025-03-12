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
    final defaultBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      border: Border.all(
        color: Colors.grey[200]!,
        width: 1.0,
      ),
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600]
    );

    return Scaffold(
        body: SafeArea(
      child: Container(
        child: TableCalendar(
          locale: 'ko_KR',
          focusedDay: DateTime.utc(2025, 03, 05),
          firstDay: DateTime(1800),
          lastDay: DateTime(3000),

          onDaySelected: (DateTime selectedDay, DateTime focusedDay){
            setState((){
              this.selectedDay = selectedDay;
            });
          },
          selectedDayPredicate: (DateTime date){
            if(selectedDay == null){return false;}
            return date.isAtSameMomentAs(selectedDay!);
          },
        ),
      ),
    ));
  }
}
