import 'package:calendar_test/component/custom_text_fromfeild.dart';
import 'package:calendar_test/const/color.dart';
import 'package:flutter/material.dart';

class ScheduleButtomSheet extends StatefulWidget {
  const ScheduleButtomSheet({super.key});

  @override
  State<ScheduleButtomSheet> createState() => _ScheduleButtomSheetState();
}

class _ScheduleButtomSheetState extends State<ScheduleButtomSheet> {
  String selectedColor = categoryColors.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 600,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 16),
          child: Column(
            children: [
              _Time(),
              SizedBox(height: 8),
              _Contents(),
              SizedBox(height: 8),
              _Category(
                selctedColor: selectedColor,
                onTap: (String color){
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
              SizedBox(height: 8),
              _SaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  const _Time({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFromfeild(
            label: '시작시간',
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: CustomTextFromfeild(
            label: '마감시간',
          ),
        ),
      ],
    );
  }
}

class _Contents extends StatelessWidget {
  const _Contents({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextFromfeild(
        label: '내용',
        expand: true,
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
                onTap: (){
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
  const _SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
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
