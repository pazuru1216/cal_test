import 'package:calendar_test/const/color.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;
  final Color color;

  const ScheduleCard(
      {required this.startTime,
      required this.endTime,
      required this.content,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Row(
            ///IntrinsicHeight 없이 stretch를 쓰면 에러가 난다.
            ///원래 주어진 영역이 있는데 억지로 늘리려고하면 어디까지 늘어나야할지 몰라서 에러가 남.
            ///ListView는 사이즈가 무한이란걸 기억하자.
            ///제일 큰 위젯 안에 있는 위젯들 각각이 가장 큰 위젯에 맞춰서 늘어남.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: Column(
                  ///늘어난 공간에서 좌측상단을 차지함
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${startTime.toString().padLeft(2, '0')}:00',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${endTime.toString().padLeft(2, '0')}:00',
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    content,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                width: 16,
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
