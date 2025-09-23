import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _locale = 'en_US';
const _decimalSeparator = '.';
const _groupSeparator = ',';
const _threeZero = '000';
const _integerPattern = '#,###';

class NumberEditingController extends TextEditingController {
  NumberEditingController({
    this.initialNumber = 0,
    this.decimalDigits = 2,
    this.minimum,
    this.maximum,
  }) {
    if (initialNumber != null) {
      text = _format(initialNumber!);
    } else {
      text = '';
    }
  }

  final num? initialNumber;
  int decimalDigits;
  final num? minimum;
  final num? maximum;

  set number(num? value) {
    if (value == null) {
      super.text = '';
      return;
    }

    super.text = _format(value);
  }

  void setDecimalDigits(int value) {
    decimalDigits = value;
  }

  num? get number => _parseNumber(text);

  void increment() {
    final newNumber = (number ?? 0) + 1;
    if (maximum != null && newNumber > maximum!) {
      return;
    }
    number = newNumber;
  }

  void decrement() {
    final newNumber = (number ?? 0) - 1;
    if (minimum != null && newNumber < minimum!) {
      return;
    }
    number = newNumber;
  }

  void addDigit(int digit) {
    final parts = text.split(_decimalSeparator);
    if (parts.length > 1 && parts[1].length >= decimalDigits) {
      return;
    }
    final newText = '$text$digit';
    number = _parseNumber(newText);
  }

  void addDecimalSeparator() {
    if (decimalDigits <= 0) {
      return;
    }
    final currentText = text;
    if (currentText.contains(_decimalSeparator)) {
      return;
    }
    super.text = '$currentText$_decimalSeparator';
  }

  void addThreeZero() {
    final currentText = text;
    final currentNumber = _parseNumber(currentText);
    if (currentText.isEmpty ||
        currentText.contains(_decimalSeparator) ||
        currentNumber == null ||
        currentNumber == 0) {
      return;
    }
    final newText = '$currentText$_threeZero';
    super.text = _format(_parseNumber(newText));
  }

  void backspace() {
    // If the text is empty, do nothing.
    if (text.isEmpty) {
      return;
    }

    // If user selection range (i.e., user has selected some text), delete the selection.
    final selection = this.selection;
    if (selection.start != selection.end) {
      final newText = text.replaceRange(selection.start, selection.end, '');
      super.text = newText;
      this.selection = TextSelection.collapsed(offset: selection.start);
      return;
    }

    // If user moves the cursor to the end of the text, delete the last character.
    if (selection.start == text.length) {
      final newText = text.substring(0, text.length - 1);
      if (newText.endsWith(_decimalSeparator)) {
        super.text = newText;
        this.selection = TextSelection.collapsed(offset: newText.length);
        return;
      }
      super.text = _format(_parseNumber(newText));
      this.selection = TextSelection.collapsed(offset: super.text.length);
      return;
    }

    // If user moves the cursor to the beginning of the text, do nothing.
    if (selection.start == 0) {
      return;
    }

    // If user moves the cursor to the middle of the text, delete the character before the cursor.
    final newText = text.replaceRange(selection.start - 1, selection.start, '');
    if (newText.endsWith(_decimalSeparator)) {
      super.text = newText;
      this.selection = TextSelection.collapsed(offset: selection.start - 1);
      return;
    }
    super.text = _format(_parseNumber(newText));
    // Adjust cursor position after formatting
    final diff = text.length - super.text.length;
    this.selection = TextSelection.collapsed(
        offset: (selection.start - 1 - diff).clamp(0, super.text.length));
  }

  void clearAll() {
    super.text = '';
    selection = TextSelection.collapsed(offset: 0);
  }

  String _format(num? value) {
    if (value == null) {
      return '';
    }
    final integerFormatter = NumberFormat(_integerPattern, _locale);
    final parts = value.toString().split(_decimalSeparator);
    if (parts.length == 1) {
      return integerFormatter.format(value);
    }
    final integerPart = parts[0];
    final decimalPart = parts[1];
    return '${integerFormatter.format(int.tryParse(integerPart) ?? 0)}$_decimalSeparator$decimalPart';
  }

  num? _parseNumber(String text) {
    if (text.isEmpty) {
      return null;
    }
    final sanitized = text.replaceAll(_groupSeparator, '');
    return num.tryParse(sanitized);
  }
}
