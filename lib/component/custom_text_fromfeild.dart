import 'package:calendar_test/const/color.dart';
import 'package:flutter/material.dart';

class CustomTextFromfeild extends StatelessWidget {
  final String label;
  final bool expand;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const CustomTextFromfeild(
      {required this.onSaved,
      required this.validator,
      required this.label,
      this.expand = false,
      super.key});

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

      /// 저장 했을때, 텍스트 필드 안에 들어가있는 값을 변수 저장
      onSaved: onSaved,
      /// 값을 저장하고 그 값을 검증할때 로직
      validator: validator,

      maxLines: expand ? null : 1,
      minLines: expand ? null : 1,
      expands: expand,
      cursorColor: Colors.grey,
    );
  }
}
