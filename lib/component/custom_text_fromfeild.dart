import 'package:calendar_test/const/color.dart';
import 'package:flutter/material.dart';

class CustomTextFromfeild extends StatelessWidget {
  final String label;
  const CustomTextFromfeild({
    required this.label,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
        style: TextStyle(
          color: PRIMARY_COLOR,
          fontWeight: FontWeight.w600,
        ),),
        TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[300],
          ),
          cursorColor: Colors.grey,
        ),
      ],
    );
  }
}
