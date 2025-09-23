# Number Field

A Flutter package that provides a custom number input field with a dedicated number keyboard.

## Features

- 🎹 **Custom Number Keyboard**: Dedicated number keyboard with smooth slide animation
- 🔢 **Smart Number Formatting**: Automatic thousand separators and decimal support
- ✅ **Validation & Limits**: Built-in min/max validation with auto-correction
- 🎨 **Highly Customizable**: Complete control over keyboard styling and appearance
- 📱 **Responsive Design**: Adapts to different screen sizes
- 🔄 **Form Integration**: Seamless integration with Flutter Form validation
- 🚀 **Performance Optimized**: Uses Overlay for efficient keyboard rendering

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  number_field: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:number_field/number_field.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NumberKeyboardViewInsets(
      child: Scaffold(
        body: NumberField(
          onChanged: (value) {
            print('Value: $value');
          },
        ),
      ),
    );
  }
}
```

### With Controller

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _controller = NumberEditingController(
    initialNumber: 1000,
    decimalDigits: 2,
    minimum: 0,
    maximum: 10000,
  );

  @override
  Widget build(BuildContext context) {
    return NumberField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Enter Amount',
        prefixText: '\$ ',
      ),
      onChanged: (value) {
        print('Amount: $value');
      },
    );
  }
}
```

## Keyboard Layout

The custom keyboard features an intuitive layout:

```
1 2 3  [Backspace]
4 5 6  [Submit]
7 8 9
. 0 000
```

### Keyboard Features

- **Number buttons (0-9)**: Standard number input
- **Decimal separator (.)**: For decimal numbers
- **Triple zero (000)**: Quick way to add thousands
- **Backspace**: Delete last character (long press to clear all)
- **Submit**: Confirm input and close keyboard

## Customization

### Styling the Keyboard

```dart
NumberField(
  keyboardStyles: NumberKeyboardStyles(
    widthRatio: 2.0,
    padding: EdgeInsets.all(16),
    gutter: 12,
    buttonStyles: NumberKeyboardButtonStyles(
      height: 60,
      backgroundColor: Colors.grey[100],
      textStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
    submitButtonStyles: NumberKeyboardSubmitButtonStyles(
      label: 'Done',
      backgroundColor: Colors.green,
    ),
  ),
)
```

### Available Style Classes

- `NumberKeyboardStyles`: Overall keyboard styling
- `NumberKeyboardButtonStyles`: Number button styling
- `NumberKeyboardSubmitButtonStyles`: Submit button styling
- `NumberKeyboardBackspaceButtonStyles`: Backspace button styling

## Form Validation

```dart
final _formKey = GlobalKey<FormState>();
final _controller = NumberEditingController();

Form(
  key: _formKey,
  child: NumberField(
    controller: _controller,
    validator: (value) {
      if (value == null || value <= 0) {
        return 'Please enter a positive number';
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: 'Quantity',
    ),
  ),
)
```

## NumberEditingController

The `NumberEditingController` provides powerful number management:

```dart
final controller = NumberEditingController(
  initialNumber: 0,
  decimalDigits: 2,
  minimum: 0,
  maximum: 1000,
);

// Available methods
controller.increment();        // Add 1
controller.decrement();        // Subtract 1
controller.addDigit(5);        // Add digit 5
controller.addThreeZero();     // Add 000
controller.backspace();        // Delete last character
controller.clearAll();         // Clear all text
```

## Important Notes

### Required Setup

1. **Wrap with NumberKeyboardViewInsets**: This is mandatory for proper view inset management:

```dart
MaterialApp(
  builder: (context, child) =>
      NumberKeyboardViewInsets(child: child ?? const SizedBox.shrink()),
  home: MyHomePage(),
)
```

2. **MediaQuery Support**: Ensure you have `WidgetsApp` or `MaterialApp` above `NumberKeyboardViewInsets`

3. **Scaffold Integration**: Use `Scaffold`, `SafeArea`, or similar widgets below to respond to view insets

### Architecture

The package uses a modular architecture:

- **NumberField**: Main widget that manages focus and keyboard display
- **NumberKeyboard**: Custom keyboard with slide animation
- **NumberEditingController**: Specialized controller for number formatting
- **NumberKeyboardViewInsets**: Manages view insets and keyboard positioning

## Requirements

- Flutter >= 3.24.3
- Dart SDK ^3.5.3

## Dependencies

- `flutter`: Flutter SDK
- `intl`: Internationalization support

## Example

See the `example/` directory for a complete working example.

## Limitations

- Currently supports `en_US` locale with `.` and `,` separators
- Test coverage needs improvement
- API documentation could be more detailed

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
