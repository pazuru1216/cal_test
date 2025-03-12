///리팩한 코드
import 'package:calendar_test/component/calendar.dart';
import 'package:calendar_test/component/custom_text_fromfeild.dart';
import 'package:calendar_test/component/schedule_card.dart';
import 'package:calendar_test/component/today_banner.dart';
import 'package:calendar_test/const/color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        ///+ 버튼을 눌렀을때 올라오는 바텀시트
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (_) {
                return Container(
                  color: Colors.white,
                  height: 600,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8,right: 8,top: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFromfeild(label: '시작시간',),
                              ),
                            SizedBox(width: 16,),
                            Expanded(
                              child: CustomTextFromfeild(label: '마감시간',),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: PRIMARY_COLOR,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
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
              TodayBanner(
                selectedDay: selectedDay,
                taskCount: 0,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 16, top: 8),
                  child: ListView(
                    children: [
                      ScheduleCard(
                        startTime: DateTime(2025, 3, 20, 08),
                        endTime: DateTime(2025, 3, 20, 12),
                        content: '플러터 공부하기',
                        color: PRIMARY_COLOR,
                      )
                    ],
                  ),
                ),
              )
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
