import 'package:flutter/material.dart';

const _keyboardWidthRatio = 1.5;
const _defaultPadding = EdgeInsets.fromLTRB(
  10,
  10,
  10,
  10,
);
const _defaultGutter = 10.0;

const _defaultButtonHeight = 48.0;
const _defaultRadius = 6.0;
const _defaultButtonBackgroundColor = Colors.white;
const _keyboardTextStyle = TextStyle(
  fontSize: 24,
  height: 32 / 24,
  fontWeight: FontWeight.w500,
  leadingDistribution: TextLeadingDistribution.even,
  color: Color(0xFF15171A),
);

const _defaultSubmitButtonHeight = (_defaultButtonHeight * 2) + _defaultGutter;
const _keyboardSubmitTextStyle = TextStyle(
  fontSize: 18,
  height: 28 / 18,
  fontWeight: FontWeight.w500,
  leadingDistribution: TextLeadingDistribution.even,
  color: Color(0xFFFFFFFF),
);
const _defaultSubmitButtonBackgroundColor = Color(0xFF0070F4);

const _defaultBackspaceButtonHeight =
    (_defaultButtonHeight * 2) + _defaultGutter;
const _defaultBackspaceButtonBackgroundColor = Color(0xFFE1E3E6);
const _defaultBackspaceButtonIconColor = Color(0xFF3E464F);

class NumberKeyboardStyles {
  const NumberKeyboardStyles({
    this.widthRatio = _keyboardWidthRatio,
    this.padding = _defaultPadding,
    this.gutter = _defaultGutter,
    this.buttonStyles = const NumberKeyboardButtonStyles(),
    this.submitButtonStyles = const NumberKeyboardSubmitButtonStyles(),
    this.backspaceButtonStyles = const NumberKeyboardBackspaceButtonStyles(),
  });

  final double widthRatio;
  final EdgeInsets padding;
  final double gutter;
  final NumberKeyboardButtonStyles buttonStyles;
  final NumberKeyboardSubmitButtonStyles submitButtonStyles;
  final NumberKeyboardBackspaceButtonStyles backspaceButtonStyles;

  double buttonWidth(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final actualWidth =
        MediaQuery.sizeOf(context).width - viewInsets.horizontal;
    final actualWidthWithoutPadding = actualWidth - padding.horizontal;
    return ((actualWidthWithoutPadding / widthRatio) - (gutter * 3)) / 4;
  }
}

class NumberKeyboardButtonStyles {
  const NumberKeyboardButtonStyles({
    this.height = _defaultButtonHeight,
    this.radius = _defaultRadius,
    this.textStyle = _keyboardTextStyle,
    this.backgroundColor = _defaultButtonBackgroundColor,
  });

  final double height;
  final double radius;
  final TextStyle textStyle;
  final Color backgroundColor;
}

class NumberKeyboardSubmitButtonStyles {
  const NumberKeyboardSubmitButtonStyles({
    this.height = _defaultSubmitButtonHeight,
    this.radius = _defaultRadius,
    this.label = 'Done',
    this.textStyle = _keyboardSubmitTextStyle,
    this.backgroundColor = _defaultSubmitButtonBackgroundColor,
  });

  final double height;
  final double radius;
  final String label;
  final TextStyle textStyle;
  final Color backgroundColor;
}

class NumberKeyboardBackspaceButtonStyles {
  const NumberKeyboardBackspaceButtonStyles({
    this.height = _defaultBackspaceButtonHeight,
    this.radius = _defaultRadius,
    this.backgroundColor = _defaultBackspaceButtonBackgroundColor,
    this.iconColor = _defaultBackspaceButtonIconColor,
  });

  final double height;
  final double radius;
  final Color backgroundColor;
  final Color iconColor;
}
