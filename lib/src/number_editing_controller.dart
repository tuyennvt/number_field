import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _threeZero = '000';
const _defaultLocale = 'en_US';
const _defaultDecimalSeparator = '.';
const _defaultGroupSeparator = ',';
const _defaultDecimalPattern = '#,##0.00';
const _defaultIntegerPattern = '#,##0';

class NumberEditingController extends TextEditingController {
  NumberEditingController({
    this.initialNumber = 0,
    this.decimalDigits = 2,
    this.minimum,
    this.maximum,
    this.locale = _defaultLocale,
  }) {
    assert(
      decimalDigits >= 0,
      'Decimal digits must be greater than or equal to 0',
    );
    assert(
      locale.isNotEmpty,
      'Locale must be a valid locale',
    );
    assert(
      minimum == null || maximum == null || minimum! <= maximum!,
      'Minimum must be less than or equal to maximum',
    );
    assert(
      initialNumber == null || minimum == null || initialNumber! >= minimum!,
      'Initial number must be greater than or equal to minimum',
    );
    assert(
      initialNumber == null || maximum == null || initialNumber! <= maximum!,
      'Initial number must be less than or equal to maximum',
    );

    _initialize();
  }

  final num? initialNumber;
  int decimalDigits;
  final num? minimum;
  final num? maximum;
  final String locale;

  String _decimalSeparator = _defaultDecimalSeparator;
  String _groupSeparator = _defaultGroupSeparator;

  String _effectiveDecimalPattern = _defaultDecimalPattern;
  NumberFormat _effectiveDecimalFormatter =
      NumberFormat(_defaultDecimalPattern, _defaultLocale);

  String _effectiveIntegerPattern = _defaultIntegerPattern;
  NumberFormat _effectiveIntegerFormatter =
      NumberFormat(_defaultIntegerPattern, _defaultLocale);

  String get decimalSeparator => _decimalSeparator;

  /// Khởi tạo các formatter và separator dựa trên locale
  void _initialize() {
    NumberFormat decimalFormatter;
    try {
      // Tạo formatter dựa trên locale (ví dụ: 'vi_VN', 'en_US')
      decimalFormatter = NumberFormat.decimalPattern(locale);
    } catch (error, stackTrace) {
      // Nếu locale không hợp lệ, sử dụng locale mặc định
      log(
        'Error creating decimal formatter, using formatter with default pattern: $_defaultDecimalPattern',
        error: error,
        stackTrace: stackTrace,
        name: 'NumberEditingController',
      );
      decimalFormatter = NumberFormat.decimalPattern(_defaultLocale);
    }

    // Lấy các ký tự phân cách từ locale (ví dụ: '.' hoặc ',')
    _decimalSeparator = _getDecimalSeparator(decimalFormatter);
    _groupSeparator = _getGroupSeparator(decimalFormatter);

    // Tạo pattern format phù hợp với số chữ số thập phân
    _effectiveDecimalPattern = _getEffectiveDecimalPattern(decimalFormatter);
    _effectiveDecimalFormatter = NumberFormat(_effectiveDecimalPattern, locale);
    _effectiveIntegerPattern = _getEffectiveIntegerPattern(decimalFormatter);
    _effectiveIntegerFormatter = NumberFormat(_effectiveIntegerPattern, locale);

    // Set giá trị ban đầu nếu có
    if (initialNumber != null) {
      text = _formatNumber(initialNumber!);
    } else {
      text = '';
    }
  }

  String _getDecimalSeparator(NumberFormat formatter) =>
      formatter.symbols.DECIMAL_SEP;

  String _getGroupSeparator(NumberFormat formatter) =>
      formatter.symbols.GROUP_SEP;

  /// Set giá trị số mới và format lại text
  ///
  /// Sử dụng _formatNumberOnChange để giữ trạng thái đang nhập liệu
  set number(num? value) {
    if (value == null) {
      super.text = '';
      return;
    }

    super.text = _formatNumberOnChange(value);
  }

  /// Set giá trị số mới và format đầy đủ
  ///
  /// Khác với setter number, hàm này format đầy đủ phần thập phân
  /// (ví dụ: "1,234.50" thay vì "1,234.5")
  void setNumberAndFormat(num? value) {
    if (value == null) {
      super.text = '';
      return;
    }
    super.text = _formatNumber(value);
  }

  void setDecimalDigits(int value) => decimalDigits = value;

  num? get number => _parseNumber(text);

  /// Tăng giá trị số hiện tại
  ///
  /// [incrementValue] giá trị tăng thêm (mặc định là 1)
  /// Không tăng nếu vượt quá giá trị maximum
  void increment([num incrementValue = 1]) {
    final newNumber = (number ?? 0) + incrementValue;
    if (maximum != null && newNumber > maximum!) {
      return;
    }
    number = newNumber;
  }

  /// Giảm giá trị số hiện tại
  ///
  /// [decrementValue] giá trị giảm đi (mặc định là 1)
  /// Không giảm nếu nhỏ hơn giá trị minimum
  void decrement([num decrementValue = 1]) {
    final newNumber = (number ?? 0) - decrementValue;
    if (minimum != null && newNumber < minimum!) {
      return;
    }
    number = newNumber;
  }

  /// Thêm một chữ số vào cuối số hiện tại
  void addDigit(int digit) {
    // Tách text thành phần nguyên và phần thập phân
    final parts = text.split(_decimalSeparator);
    final fractionPart = parts.length > 1 ? parts[1] : null;

    // Nếu phần thập phân đã đủ số chữ số cho phép và số khác 0, không cho thêm nữa
    if (fractionPart != null &&
        fractionPart.length >= decimalDigits &&
        number != 0) {
      return;
    }

    // Nếu số hiện tại là 0, thay thế bằng chữ số mới; ngược lại nối thêm vào cuối
    final newText = number == 0 ? '$digit' : '$text$digit';
    number = _parseNumber(newText);
  }

  /// Thêm dấu phân cách thập phân vào cuối text
  void addDecimalSeparator() {
    // Không cho phép thêm nếu không có phần thập phân (decimalDigits = 0)
    if (decimalDigits <= 0) {
      return;
    }
    // Không cho phép thêm nếu đã có dấu phân cách thập phân
    if (text.contains(_decimalSeparator)) {
      return;
    }
    super.text = '$text$_decimalSeparator';
  }

  /// Thêm 3 số 0 vào cuối số hiện tại (nhân với 1000)
  void addThreeZero() {
    final currentNumber = _parseNumber(text);

    // Chỉ cho phép thêm 000 khi:
    // - Text không rỗng
    // - Chưa có dấu phân cách thập phân (chỉ áp dụng cho số nguyên)
    // - Số hiện tại hợp lệ và khác 0
    if (text.isEmpty ||
        text.contains(_decimalSeparator) ||
        currentNumber == null ||
        currentNumber == 0) {
      return;
    }

    final newText = '$text$_threeZero';
    final newNumber = _parseNumber(newText);
    super.text = _formatNumberOnChange(newNumber);
  }

  /// Xóa ký tự trước vị trí con trỏ (giống phím Backspace)
  void backspace() {
    // Nếu text rỗng, không làm gì
    if (text.isEmpty) {
      return;
    }

    // Nếu người dùng đã chọn một đoạn text (selection range), xóa toàn bộ đoạn đó
    final selection = this.selection;
    if (selection.start != selection.end) {
      final newText = text.replaceRange(selection.start, selection.end, '');
      super.text = newText;
      this.selection = TextSelection.collapsed(offset: selection.start);
      return;
    }

    // Nếu con trỏ ở cuối text, xóa ký tự cuối cùng
    if (selection.start == text.length) {
      final newText = text.substring(0, text.length - 1);
      // Nếu sau khi xóa, text kết thúc bằng dấu phân cách thập phân, giữ nguyên không format
      if (newText.endsWith(_decimalSeparator)) {
        super.text = newText;
        this.selection = TextSelection.collapsed(offset: newText.length);
        return;
      }
      // Format lại số sau khi xóa
      super.text = _formatNumberOnChange(_parseNumber(newText));
      this.selection = TextSelection.collapsed(offset: super.text.length);
      return;
    }

    // Nếu con trỏ ở đầu text, không làm gì
    if (selection.start == 0) {
      return;
    }

    // Nếu con trỏ ở giữa text, xóa ký tự trước con trỏ
    final newText = text.replaceRange(selection.start - 1, selection.start, '');
    // Nếu sau khi xóa, text kết thúc bằng dấu phân cách thập phân, giữ nguyên không format
    if (newText.endsWith(_decimalSeparator)) {
      super.text = newText;
      this.selection = TextSelection.collapsed(offset: selection.start - 1);
      return;
    }

    // Lưu độ dài text trước khi format
    final oldLength = newText.length;
    super.text = _formatNumberOnChange(_parseNumber(newText));

    // Điều chỉnh vị trí con trỏ sau khi format (vì format có thể thay đổi độ dài text)
    // diff là số ký tự bị thay đổi do formatting (ví dụ: thêm/bớt dấu phân cách nhóm)
    // Ví dụ: "1234" (4 ký tự) -> "1,234" (5 ký tự) => diff = -1
    final diff = oldLength - super.text.length;
    this.selection = TextSelection.collapsed(
        offset: (selection.start - 1 - diff).clamp(0, super.text.length));
  }

  void clearAll() {
    super.text = '';
    selection = TextSelection.collapsed(offset: 0);
  }

  /// Format số với đầy đủ chữ số thập phân
  ///
  /// Ví dụ với decimalDigits = 2: 1234.5 -> "1,234.50"
  String _formatNumber(num? numberValue) {
    if (numberValue == null) {
      return '';
    }
    return _effectiveDecimalFormatter.format(numberValue);
  }

  /// Format số khi người dùng đang nhập liệu
  ///
  /// Khác với _formatNumber, hàm này giữ nguyên phần thập phân đang nhập
  /// để người dùng có thể tiếp tục nhập (ví dụ: "1,234.5" thay vì "1,234.50")
  String _formatNumberOnChange(num? numberValue) {
    if (numberValue == null) {
      return '';
    }

    // Tách số thành phần nguyên và phần thập phân
    final parts = numberValue.toString().split('.');

    // Nếu chỉ có phần nguyên, format và trả về
    if (parts.length == 1) {
      return _effectiveIntegerFormatter.format(numberValue);
    }

    // Format phần nguyên với dấu phân cách nhóm (ví dụ: 1,234)
    final integerPart = parts[0];
    final integerValue = int.tryParse(integerPart);
    if (integerValue == null) {
      return '';
    }
    final integerFormatted = _effectiveIntegerFormatter.format(integerValue);

    // Giữ nguyên phần thập phân đang nhập, chỉ cắt bớt nếu vượt quá số chữ số cho phép
    String fractionPart = parts[1];
    if (fractionPart.length > decimalDigits) {
      fractionPart = fractionPart.substring(0, decimalDigits);
    }

    return '$integerFormatted$_decimalSeparator$fractionPart';
  }

  /// Parse chuỗi text thành số
  ///
  /// Loại bỏ các ký tự định dạng (dấu phân cách nhóm) và chuyển dấu phân cách thập phân
  /// theo locale thành dấu chấm chuẩn để parse
  num? _parseNumber(String raw) {
    if (raw.isEmpty) {
      return null;
    }
    // Loại bỏ dấu phân cách nhóm (ví dụ: "1,234" -> "1234")
    // Chuyển dấu phân cách thập phân theo locale thành dấu chấm (ví dụ: "1234,56" -> "1234.56")
    final sanitized =
        raw.replaceAll(_groupSeparator, '').replaceAll(_decimalSeparator, '.');
    return num.tryParse(sanitized);
  }

  /// Tạo pattern định dạng số dựa trên locale và số chữ số thập phân
  ///
  /// Pattern sẽ có dạng: '#,##0' (không có phần thập phân) hoặc '#,##0.00' (có phần thập phân)
  /// Số lượng chữ số 0 sau dấu chấm phụ thuộc vào [decimalDigits]
  ///
  /// Ví dụ:
  /// - decimalDigits = 0 -> '#,##0'
  /// - decimalDigits = 2 -> '#,##0.00'
  /// - decimalDigits = 3 -> '#,##0.000'
  String _getEffectiveDecimalPattern(NumberFormat formatter) {
    final pattern = formatter.symbols.DECIMAL_PATTERN;

    // Tách pattern thành phần nguyên và phần thập phân
    final parts = pattern.split('.');

    // Nếu pattern không hợp lệ, sử dụng pattern mặc định
    if (parts.isEmpty) {
      return decimalDigits == 0
          ? _defaultIntegerPattern
          : _defaultDecimalPattern;
    }

    final integerPart = parts[0];

    // Nếu không cần phần thập phân, chỉ trả về phần nguyên
    if (decimalDigits == 0) {
      return integerPart;
    }

    // Tạo phần thập phân với số chữ số 0 theo yêu cầu
    // Ví dụ: decimalDigits = 3 -> '000'
    final fractionPart = '0' * decimalDigits;
    return '$integerPart.$fractionPart';
  }

  /// Lấy pattern cho phần nguyên (không có phần thập phân)
  ///
  /// Ví dụ: '#,##0.00' -> '#,##0'
  String _getEffectiveIntegerPattern(NumberFormat formatter) {
    final pattern = formatter.symbols.DECIMAL_PATTERN;
    final parts = pattern.split('.');
    if (parts.isEmpty) {
      return _defaultIntegerPattern;
    }
    return parts[0];
  }
}
