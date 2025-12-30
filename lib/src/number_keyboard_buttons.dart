import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_field/src/number_keyboard_styles.dart';

class NumberKeyboardButtons extends StatelessWidget {
  const NumberKeyboardButtons({
    super.key,
    required this.onSubmitPressed,
    required this.onBackspacePressed,
    required this.onBackspaceLongPress,
    required this.onDecimalSeparatorPressed,
    required this.onThreeZeroPressed,
    required this.onDigitPressed,
    required this.styles,
  });

  final VoidCallback onSubmitPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onBackspaceLongPress;
  final VoidCallback? onDecimalSeparatorPressed;
  final VoidCallback onThreeZeroPressed;
  final ValueChanged<int> onDigitPressed;
  final NumberKeyboardStyles styles;

  @override
  Widget build(BuildContext context) {
    final buttonWidth = styles.buttonWidth(context);
    return Container(
      padding: styles.padding,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _Button(
                    value: 1,
                    onPressed: () => onDigitPressed(1),
                    styles: styles.buttonStyles,
                    width: buttonWidth,
                  ),
                  SizedBox(width: styles.gutter),
                  _Button(
                    value: 2,
                    onPressed: () => onDigitPressed(2),
                    styles: styles.buttonStyles,
                    width: buttonWidth,
                  ),
                  SizedBox(width: styles.gutter),
                  _Button(
                    value: 3,
                    onPressed: () => onDigitPressed(3),
                    styles: styles.buttonStyles,
                    width: buttonWidth,
                  ),
                ],
              ),
              SizedBox(height: styles.gutter),
              Row(
                children: [
                  _Button(
                    value: 4,
                    onPressed: () => onDigitPressed(4),
                    styles: styles.buttonStyles,
                    width: buttonWidth,
                  ),
                  SizedBox(width: styles.gutter),
                  _Button(
                    value: 5,
                    onPressed: () => onDigitPressed(5),
                    styles: styles.buttonStyles,
                    width: buttonWidth,
                  ),
                  SizedBox(width: styles.gutter),
                  _Button(
                    value: 6,
                    onPressed: () => onDigitPressed(6),
                    styles: styles.buttonStyles,
                    width: buttonWidth,
                  ),
                ],
              ),
              SizedBox(height: styles.gutter),
              Row(
                children: [
                  _Button(
                    value: 7,
                    onPressed: () => onDigitPressed(7),
                    styles: styles.buttonStyles,
                    width: buttonWidth,
                  ),
                  SizedBox(width: styles.gutter),
                  _Button(
                    value: 8,
                    onPressed: () => onDigitPressed(8),
                    styles: styles.buttonStyles,
                    width: buttonWidth,
                  ),
                  SizedBox(width: styles.gutter),
                  _Button(
                    value: 9,
                    onPressed: () => onDigitPressed(9),
                    styles: styles.buttonStyles,
                    width: buttonWidth,
                  ),
                ],
              ),
              SizedBox(height: styles.gutter),
              Row(
                children: [
                  if (onDecimalSeparatorPressed != null) ...[
                    _DecimalSeparatorButton(
                      onPressed: onDecimalSeparatorPressed!,
                      styles: styles.buttonStyles,
                      width: buttonWidth,
                    ),
                  ] else ...[
                    SizedBox(
                      width: buttonWidth,
                      height: styles.buttonStyles.height,
                    ),
                  ],
                  SizedBox(width: styles.gutter),
                  _Button(
                    value: 0,
                    onPressed: () => onDigitPressed(0),
                    styles: styles.buttonStyles,
                    width: buttonWidth,
                  ),
                  SizedBox(width: styles.gutter),
                  _ThreeButton(
                    onPressed: onThreeZeroPressed,
                    styles: styles.buttonStyles,
                    width: buttonWidth,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: styles.gutter),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BackspaceButton(
                onPressed: onBackspacePressed,
                onLongPress: onBackspaceLongPress,
                styles: styles.backspaceButtonStyles,
                width: buttonWidth,
              ),
              SizedBox(height: styles.gutter),
              _SubmitButton(
                label: styles.submitButtonStyles.label,
                onPressed: onSubmitPressed,
                styles: styles.submitButtonStyles,
                width: buttonWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.value,
    required this.onPressed,
    required this.styles,
    required this.width,
  });

  final int value;
  final VoidCallback onPressed;
  final NumberKeyboardButtonStyles styles;
  final double width;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(styles.backgroundColor),
        foregroundColor: WidgetStateProperty.all(styles.textStyle.color),
        overlayColor: WidgetStateProperty.all(const Color(0xFFD1D5DA)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(styles.radius),
          ),
        ),
        shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.3)),
        elevation: WidgetStateProperty.all(2),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        textStyle: WidgetStateProperty.all(styles.textStyle),
        fixedSize: WidgetStateProperty.all(Size(width, styles.height)),
      ),
      child: Text(value.toString()),
    );
  }
}

class _ThreeButton extends StatelessWidget {
  const _ThreeButton({
    required this.onPressed,
    required this.styles,
    required this.width,
  });

  final VoidCallback onPressed;
  final NumberKeyboardButtonStyles styles;
  final double width;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(styles.backgroundColor),
        foregroundColor: WidgetStateProperty.all(styles.textStyle.color),
        overlayColor: WidgetStateProperty.all(const Color(0xFFD1D5DA)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(styles.radius),
          ),
        ),
        shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.3)),
        elevation: WidgetStateProperty.all(2),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        textStyle: WidgetStateProperty.all(styles.textStyle),
        fixedSize: WidgetStateProperty.all(Size(width, styles.height)),
      ),
      child: Text('000'),
    );
  }
}

class _DecimalSeparatorButton extends StatelessWidget {
  const _DecimalSeparatorButton({
    required this.onPressed,
    required this.styles,
    required this.width,
  });

  final VoidCallback onPressed;
  final NumberKeyboardButtonStyles styles;
  final double width;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(styles.backgroundColor),
        foregroundColor: WidgetStateProperty.all(styles.textStyle.color),
        overlayColor: WidgetStateProperty.all(const Color(0xFFD1D5DA)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(styles.radius),
          ),
        ),
        shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.3)),
        elevation: WidgetStateProperty.all(2),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        textStyle: WidgetStateProperty.all(styles.textStyle),
        fixedSize: WidgetStateProperty.all(Size(width, styles.height)),
      ),
      child: Text('.'),
    );
  }
}

class _BackspaceButton extends StatelessWidget {
  const _BackspaceButton({
    required this.onPressed,
    required this.onLongPress,
    required this.styles,
    required this.width,
  });

  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final NumberKeyboardBackspaceButtonStyles styles;
  final double width;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(styles.backgroundColor),
        foregroundColor: WidgetStateProperty.all(styles.iconColor),
        overlayColor: WidgetStateProperty.all(const Color(0xFFD1D5DA)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(styles.radius),
          ),
        ),
        shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.3)),
        elevation: WidgetStateProperty.all(2),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        fixedSize: WidgetStateProperty.all(Size(width, styles.height)),
      ),
      child: Icon(CupertinoIcons.delete_left),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.label,
    required this.onPressed,
    required this.styles,
    required this.width,
  });

  final String label;
  final VoidCallback onPressed;
  final NumberKeyboardSubmitButtonStyles styles;
  final double width;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(styles.backgroundColor),
        foregroundColor: WidgetStateProperty.all(styles.textStyle.color),
        overlayColor: WidgetStateProperty.all(const Color(0xFF004392)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(styles.radius),
          ),
        ),
        shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.3)),
        elevation: WidgetStateProperty.all(2),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        textStyle: WidgetStateProperty.all(styles.textStyle),
        fixedSize: WidgetStateProperty.all(Size(width, styles.height)),
      ),
      child: label.isEmpty ? Icon(CupertinoIcons.check_mark) : Text(label),
    );
  }
}
