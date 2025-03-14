import 'package:calendar_test/const/color.dart';
import 'package:flutter/material.dart';

class CustomTextFromfeild extends StatelessWidget {
  final String label;
  final bool expand;

  const CustomTextFromfeild(
      {required this.label, this.expand = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (!expand) renderTextFormField(),
        if (expand) Expanded(child: renderTextFormField())
      ],
    );
  }

  renderTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
      ),
      maxLines: expand ? null : 1,
      minLines: expand ? null : 1,
      expands: expand,
      cursorColor: Colors.grey,
    );
  }
}
