import 'package:flutter/material.dart';
import 'package:number_field/src/number_keyboard_buttons.dart';
import 'package:number_field/src/number_keyboard_styles.dart';

import 'keyboard_body.dart';
import 'number_editing_controller.dart';
import 'number_keyboard_view_insets.dart';

class NumberKeyboard extends StatelessWidget {
  const NumberKeyboard({
    super.key,
    required this.controller,
    required this.onSubmitPressed,
    this.insetsState,
    this.slideAnimation,
    this.styles = const NumberKeyboardStyles(),
  });

  final NumberEditingController controller;
  final VoidCallback onSubmitPressed;
  final NumberKeyboardViewInsetsState? insetsState;
  final Animation<double>? slideAnimation;
  final NumberKeyboardStyles styles;

  @override
  Widget build(BuildContext context) {
    final curvedSlideAnimation = CurvedAnimation(
      parent: slideAnimation ?? AlwaysStoppedAnimation(1),
      curve: Curves.ease,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: const Offset(0, 0),
      ).animate(curvedSlideAnimation),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              type: MaterialType.transparency,
              child: ColoredBox(
                color: Color(0xFFC2C7CE),
                child: SafeArea(
                  top: false,
                  child: KeyboardBody(
                    insetsState: insetsState,
                    slideAnimation:
                        slideAnimation == null ? null : curvedSlideAnimation,
                    child: NumberKeyboardButtons(
                      onSubmitPressed: onSubmitPressed,
                      onBackspacePressed: controller.backspace,
                      onBackspaceLongPress: controller.clearAll,
                      decimalSeparator: controller.decimalSeparator,
                      onDecimalSeparatorPressed: controller.decimalDigits > 0
                          ? controller.addDecimalSeparator
                          : null,
                      onThreeZeroPressed: controller.addThreeZero,
                      onDigitPressed: controller.addDigit,
                      styles: styles,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
