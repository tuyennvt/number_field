import 'package:flutter/material.dart';

import 'number_editing_controller.dart';

class NumberFieldPreview extends StatelessWidget {
  const NumberFieldPreview({
    super.key,
    required this.controller,
    required this.focusNode,
    this.style,
    this.decoration = const InputDecoration(),
    this.enabled = true,
    this.readOnly = false,
    this.textAlign,
    this.cursorColor,
    required this.onTap,
    required this.autovalidateMode,
    required this.validator,
    required this.onSaved,
  });
  final NumberEditingController controller;
  final FocusNode focusNode;
  final TextStyle? style;
  final InputDecoration decoration;
  final bool enabled;
  final bool readOnly;
  final TextAlign? textAlign;
  final Color? cursorColor;
  final VoidCallback onTap;
  final AutovalidateMode autovalidateMode;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: style,
      decoration: decoration,
      enabled: enabled,
      readOnly: readOnly,
      keyboardType: TextInputType.none,
      textAlign: textAlign ?? TextAlign.end,
      onTap: onTap,
      cursorColor: cursorColor,
      autovalidateMode: autovalidateMode,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
