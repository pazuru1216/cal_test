import 'package:calendar_test/component/custom_text_fromfeild.dart';
import 'package:calendar_test/const/color.dart';
import 'package:calendar_test/database/drift.dart';
import 'package:calendar_test/model/schedule.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScheduleButtomSheet extends StatefulWidget {
  final int? id;
  final DateTime selectedDay;

  const ScheduleButtomSheet({this.id, required this.selectedDay, super.key});

  @override
  State<ScheduleButtomSheet> createState() => _ScheduleButtomSheetState();
}

class _ScheduleButtomSheetState extends State<ScheduleButtomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  String selectedColor = categoryColors.first;

  ///build되었을때 한번만 실행되는 initState
  @override
  void initState() {
    super.initState();
    initCategory();
  }

  initCategory() async {
    if (widget.id != null) {
      final resp = await GetIt.I<AppDatabase>().getScheduleById(widget.id!);
      setState(() {
        selectedColor = resp.color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.id == null
            ? null
            : GetIt.I<AppDatabase>().getScheduleById(widget.id!),
        builder: (context, snapshot) {
          if (widget.id != null &&
              snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;

          return Container(
            color: Colors.white,
            height: 600,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 8, right: 8, top: 16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      _Time(
                        onStartSaved: onStartTimeSaved,
                        onEndSaved: onEndTimeSaved,
                        onStartValidate: onStartTimeValidate,
                        onEndValidate: onEndTimeValidate,
                        startTimeInitValue: data?.startTime.toString(),
                        endTimeInitValue: data?.endTime.toString(),
                      ),
                      SizedBox(height: 8),
                      _Contents(
                        onSaved: onContentSaved,
                        onValidated: onContentValidate,
                        initialValue: data?.content.toString(),
                      ),
                      SizedBox(height: 8),
                      _Category(
                        selctedColor: selectedColor,
                        onTap: (String color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                      SizedBox(height: 8),
                      _SaveButton(
                        onPressed: onSavedPressed,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void onStartTimeSaved(String? val) {
    if (val == null) {
      return;
    }
    ;
    startTime = int.parse(val);
  }

  String? onStartTimeValidate(String? val) {
    if (val == null) {
      return '값을 입력해주세요!';
    }
    if (int.tryParse(val) == null) {
      return '숫자를 입력해주세요';
    }
    if (int.tryParse(val)! > 24 || int.tryParse(val)! < 0) {
      return ('24시간 내의 시간을 작성해주세요');
    }
  }

  void onEndTimeSaved(String? val) {
    if (val == null) {
      return;
    }
    ;
    endTime = int.parse(val);
  }

  String? onEndTimeValidate(String? val) {
    if (val == null) {
      return '값을 입력해주세요!';
    }
    if (int.tryParse(val) == null) {
      return '숫자를 입력해주세요';
    }

    if (int.tryParse(val)! > 24 || int.tryParse(val)! < 0) {
      return ('24시간 내의 시간을 작성해주세요');
    }
  }

  void onContentSaved(String? val) {
    if (val == null) {
      return;
    }
    ;
    content = val;
  }

  String? onContentValidate(String? val) {
    if (val == null) {
      return '값을 입력해주세요!';
    }
    if (val.length < 5) {
      return '5자 이상을 입력해주세요';
    }

    return null;
  }

  void onSavedPressed() async {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();

      final database = GetIt.I<AppDatabase>();

      if (widget.id == null) {
        await database.createSchedule(
          ScheduleTableCompanion(
              startTime: Value(startTime!),
              endTime: Value(endTime!),
              content: Value(content!),
              color: Value(selectedColor!),
              date: Value(widget.selectedDay!)),
        );
      } else {
        await database.updateScheduleById(
          widget.id!,
          ScheduleTableCompanion(
              startTime: Value(startTime!),
              endTime: Value(endTime!),
              content: Value(content!),
              color: Value(selectedColor!),
              date: Value(widget.selectedDay!)),
        );
      }
      Navigator.of(context).pop();
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final FormFieldValidator<String> onStartValidate;
  final FormFieldValidator<String> onEndValidate;
  final String? startTimeInitValue;
  final String? endTimeInitValue;

  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    required this.onStartValidate,
    required this.onEndValidate,
    this.startTimeInitValue,
    this.endTimeInitValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextFromfeild(
                label: '시작시간',
                onSaved: onStartSaved,
                validator: onStartValidate,
                initialValue: startTimeInitValue,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: CustomTextFromfeild(
                label: '마감시간',
                onSaved: onEndSaved,
                validator: onEndValidate,
                initialValue: endTimeInitValue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Contents extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> onValidated;
  final String? initialValue;

  const _Contents(
      {required this.onSaved,
      required this.onValidated,
      this.initialValue,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextFromfeild(
        label: '내용',
        expand: true,
        onSaved: onSaved,
        validator: onValidated,
        initialValue: initialValue,
      ),
    );
  }
}

typedef OnColorSelected = void Function(String color);

class _Category extends StatelessWidget {
  final String selctedColor;
  final OnColorSelected onTap;

  const _Category({required this.onTap, required this.selctedColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: categoryColors
          .map(
            (e) => Padding(
              padding: EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  onTap(e);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(
                      ///이 String을 16진수로 변환해라
                      ///이 과정을 거치면 0xFF44336이 나온다
                      int.parse(
                        'FF$e',
                        radix: 16,
                      ),
                    ),
                    border: e == selctedColor
                        ? Border.all(
                            color: Colors.black,
                            width: 4,
                          )
                        : null,
                    shape: BoxShape.circle,
                  ),
                  width: 32,
                  height: 32,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SaveButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
              foregroundColor: Colors.white,
            ),
            child: Text('저장'),
          ),
        ),
      ],
    );
  }
}
