import 'package:flutter/material.dart';
import 'package:number_field/src/number_field_preview.dart';
import 'package:number_field/src/number_keyboard_styles.dart';

import 'number_editing_controller.dart';
import 'number_keyboard.dart';
import 'number_keyboard_view_insets.dart';

class NumberField extends StatefulWidget {
  const NumberField({
    super.key,
    this.focusNode,
    this.controller,
    this.style,
    this.decoration = const InputDecoration(),
    this.keyboardStyles = const NumberKeyboardStyles(),
    this.enabled = true,
    this.readOnly = false,
    this.textAlign = TextAlign.end,
    this.cursorColor = const Color(0xFF0070F4),
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
    this.onSaved,
  });

  final FocusNode? focusNode;
  final NumberEditingController? controller;
  final TextStyle? style;
  final InputDecoration decoration;
  final NumberKeyboardStyles keyboardStyles;
  final bool enabled;
  final bool readOnly;
  final TextAlign textAlign;
  final Color cursorColor;
  final ValueChanged<num?>? onChanged;
  final Function(num?)? onFieldSubmitted;
  final Function()? onEditingComplete;
  final AutovalidateMode autovalidateMode;
  final FormFieldValidator<num?>? validator;
  final FormFieldSetter<num?>? onSaved;

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField>
    with TickerProviderStateMixin {
  late final _keyboardSlideController = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );

  OverlayEntry? _overlayEntry;
  late var _focusNode = widget.focusNode ?? FocusNode();
  late var _controller = widget.controller ?? NumberEditingController();

  bool get _isKeyboardShown =>
      _overlayEntry != null &&
      _keyboardSlideController.status != AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _keyboardSlideController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      } else if (status == AnimationStatus.completed) {
        _showFieldOnScreen();
      }
    });
    _controller.addListener(_controllerListener);
    _focusNode.addListener(_focusNodeListener);
  }

  @override
  void didUpdateWidget(NumberField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller != null) {
        // We should only detach our listener and not dispose an outside
        // controller if provided.
        _controller.removeListener(_controllerListener);
      } else {
        _controller.dispose();
      }

      _controller = widget.controller ?? NumberEditingController();
      _controller.addListener(_controllerListener);
    }

    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        // Dispose the focus node created by our state instance.
        _focusNode.removeListener(_focusNodeListener);
        _focusNode.dispose();
        // Assign the new outside focus node.
        _focusNode = widget.focusNode!;
        _focusNode.addListener(_focusNodeListener);
      } else if (widget.focusNode == null) {
        // Instantiate new local focus node.
        _focusNode = FocusNode();
        _focusNode.addListener(_focusNodeListener);
      } else {
        // Switch the outside focus node.
        _focusNode = widget.focusNode!;
        _focusNode.addListener(_focusNodeListener);
      }
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _keyboardSlideController.dispose();

    if (widget.controller != null) {
      // We should only detach our listener and not dispose an outside
      // controller if provided.
      _controller.removeListener(_controllerListener);
    } else {
      _controller.dispose();
    }

    if (widget.focusNode != null) {
      // Only detach our listener and not dispose an outside
      _focusNode.removeListener(_focusNodeListener);
    } else {
      _focusNode.dispose();
    }

    super.dispose();
  }

  void _onFocusChanged(BuildContext context, {required bool open}) {
    if (!open) {
      _keyboardSlideController.reverse();
    } else {
      _openKeyboard(context);
      _keyboardSlideController.forward(from: 0);
      _showFieldOnScreen();
      if (_controller.number == 0) {
        // Select all text if the number is 0
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      } else {
        // Move the cursor to the end of the text
        _controller.selection =
            TextSelection.collapsed(offset: _controller.text.length);
      }
    }
    setState(() {});
  }

  void _controllerListener() {
    widget.onChanged?.call(_controller.number);
  }

  void _focusNodeListener() {
    if (widget.readOnly || !widget.enabled) {
      return;
    }
    if (_focusNode.hasFocus) {
      _onFocusChanged(context, open: true);
      return;
    }
    _onFocusChanged(context, open: false);
    _controller.number = _validate();
    widget.onFieldSubmitted?.call(_controller.number);
  }

  bool _showFieldOnScreenScheduled = false;

  /// Shows the number field on screen by e.g. auto scrolling in list views.
  void _showFieldOnScreen() {
    if (_showFieldOnScreenScheduled) {
      return;
    }
    _showFieldOnScreenScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFieldOnScreenScheduled = false;
      if (!mounted) {
        return;
      }

      context.findRenderObject()?.showOnScreen(
            duration: const Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn,
          );
    });
  }

  void _openKeyboard(BuildContext context) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Localizations.override(
        context: this.context,
        locale: Localizations.localeOf(this.context),
        child: NumberKeyboard(
          controller: _controller,
          onSubmitPressed: _submit,
          insetsState: NumberKeyboardViewInsetsState.of(this.context),
          slideAnimation: _keyboardSlideController,
          styles: widget.keyboardStyles,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Launches keyboard slide animation in reversed direction.
  /// By the end of it the [_overlayEntry] will be removed
  /// by the [_keyboardSlideController] listener callback.
  ///
  /// Keep in mind: it does not remove the focus from the field.
  void _closeKeyboard() {
    _keyboardSlideController.reverse();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
  }

  num? _validate() {
    final number = _controller.number;
    if (number == null) {
      if (_controller.minimum != null) {
        return _controller.minimum!;
      }
      return null;
    }
    if (_controller.minimum != null && number < _controller.minimum!) {
      return _controller.minimum!;
    }
    if (_controller.maximum != null && number > _controller.maximum!) {
      return _controller.maximum!;
    }
    return number;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isKeyboardShown,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        _closeKeyboard();
      },
      child: NumberFieldPreview(
        controller: _controller,
        focusNode: _focusNode,
        onTap: _onTap,
        style: widget.style,
        decoration: widget.decoration,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        textAlign: widget.textAlign,
        cursorColor: widget.cursorColor,
        autovalidateMode: widget.autovalidateMode,
        validator: (_) => widget.validator?.call(_controller.number),
        onSaved: (_) => widget.onSaved?.call(_controller.number),
      ),
    );
  }

  void _onTap() {
    if (widget.readOnly || !widget.enabled) {
      return;
    }
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    } else if (!_isKeyboardShown) {
      _onFocusChanged(context, open: true);
    }
  }
}
