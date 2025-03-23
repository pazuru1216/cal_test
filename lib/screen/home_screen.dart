///리팩한 코드
import 'package:calendar_test/component/calendar.dart';
import 'package:calendar_test/component/custom_text_fromfeild.dart';
import 'package:calendar_test/component/schedule_buttom_sheet.dart';
import 'package:calendar_test/component/schedule_card.dart';
import 'package:calendar_test/component/today_banner.dart';
import 'package:calendar_test/const/color.dart';
import 'package:calendar_test/database/drift.dart';
import 'package:calendar_test/model/schedule.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
          onPressed: () async {
            ///rsep = response라는 뜻
            final routeSchedule = await showModalBottomSheet<ScheduleTable>(
              context: context,
              builder: (_) {
                return ScheduleButtomSheet(
                  selectedDay: selectedDay,
                );
              },
            );

            setState(() {});
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
                  child: FutureBuilder<List<ScheduleTableData>>(
                      future: GetIt.I<AppDatabase>().getSchedules(
                        selectedDay,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                            ),
                          );
                        }

                        if (!snapshot.hasData &&
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final schedules = snapshot.data!;

                        return ListView.separated(
                          ///화면에 몇개를 보여줄거냐 -> 길이를 넣어주면 됨
                          ///선택한 날짜에 키 값이 존재하니?
                          itemCount: schedules.length,

                          ///화면이 위젯에 보일때마다 실행되는 itemBuilder
                          itemBuilder: (BuildContext context, int index) {
                            ///선택된 날짜에 해당되는 일정 리스트로 저장
                            ///List<Schedule>
                            // final selectedSchedules = schedules[selectedDay]!;
                            // final sheduleModel = selectedSchedules[index];

                            final schedule = schedules[index];

                            return Dismissible(
                              key:ObjectKey(schedule.id),
                              ///오른쪽에서 왼쪽으로 스와이프
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (DismissDirection direction) async{
                                await GetIt.I<AppDatabase>().removeSchedule(schedule.id);
                                setState(() {});

                                // 삭제하겠다.
                                return true;
                              },
                              child: ScheduleCard(
                                startTime: schedule.startTime,
                                endTime: schedule.endTime,
                                content: schedule.content,
                                color: Color(
                                  int.parse(
                                    'FF${schedule.color}',
                                    radix: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 8,
                            );
                          },
                        );
                      }),
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