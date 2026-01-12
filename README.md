# Number Field

A Flutter package that provides a custom number input field with a dedicated number keyboard.

## Features

- 🎹 **Custom Number Keyboard**: Dedicated number keyboard with smooth slide animation
- 🔢 **Smart Number Formatting**: Automatic thousand separators and decimal support with locale support
- ✅ **Validation & Limits**: Built-in min/max validation with auto-correction
- 🎨 **Highly Customizable**: Complete control over keyboard styling, colors, and button appearance
- 📱 **Responsive Design**: Adapts to different screen sizes with configurable width ratio
- 🔄 **Form Integration**: Seamless integration with Flutter Form validation
- 🚀 **Performance Optimized**: Uses Overlay for efficient keyboard rendering
- 🌍 **Locale Support**: Supports different locales for number formatting (decimal and group separators)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  number_field:
    git:
      url: https://github.com/tuyennvt/number_field.git
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:number_field/number_field.dart';

void main() {
  runApp(MaterialApp(
    builder: (context, child) =>
        NumberKeyboardViewInsets(child: child ?? const SizedBox.shrink()),
    home: MyHomePage(),
  ));
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NumberField(
        onChanged: (value) {
          print('Value: $value');
        },
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
    locale: 'en_US', // Supports locale for number formatting
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
4 5 6  [Submit ✓]
7 8 9
. 0 000
```

### Keyboard Features

- **Number buttons (0-9)**: Standard number input
- **Decimal separator (.)**: For decimal numbers (automatically adapts to locale, e.g., "." or ",")
- **Triple zero (000)**: Quick way to multiply by 1000 (only works for integers, not decimals)
- **Backspace**: Delete last character (tap) or clear all (long press)
- **Submit**: Confirm input and close keyboard (shows checkmark icon by default, or custom label)

## Customization

### Styling the Keyboard

```dart
NumberField(
  keyboardStyles: NumberKeyboardStyles(
    widthRatio: 2.0, // Controls keyboard width relative to screen
    padding: EdgeInsets.all(16),
    gutter: 12, // Space between buttons
    buttonStyles: NumberKeyboardButtonStyles(
      height: 60,
      radius: 8, // Border radius
      backgroundColor: Colors.grey[100],
      textStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    submitButtonStyles: NumberKeyboardSubmitButtonStyles(
      height: 132, // Default: (buttonHeight * 2) + gutter
      label: 'Done', // Empty string shows checkmark icon
      backgroundColor: Colors.green,
      textStyle: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
    backspaceButtonStyles: NumberKeyboardBackspaceButtonStyles(
      height: 132, // Default: (buttonHeight * 2) + gutter
      backgroundColor: Color(0xFFE1E3E6),
      iconColor: Color(0xFF3E464F),
    ),
  ),
)
```

### Available Style Classes

- `NumberKeyboardStyles`: Overall keyboard styling (width ratio, padding, gutter)
- `NumberKeyboardButtonStyles`: Number button styling (height, radius, colors, text style)
- `NumberKeyboardSubmitButtonStyles`: Submit button styling (height, radius, label, colors, text style)
- `NumberKeyboardBackspaceButtonStyles`: Backspace button styling (height, radius, colors, icon color)

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

The `NumberEditingController` extends `TextEditingController` and provides powerful number management:

```dart
final controller = NumberEditingController(
  initialNumber: 0,
  decimalDigits: 2,
  minimum: 0,
  maximum: 1000,
  locale: 'en_US', // Default: 'en_US'
);

// Available properties
controller.number;              // Get current number value
controller.decimalSeparator;    // Get decimal separator based on locale

// Available methods
controller.number = 100;        // Set number (formats during input)
controller.setNumberAndFormat(100); // Set number with full formatting
controller.setDecimalDigits(3); // Change decimal digits
controller.increment();         // Add 1 (respects maximum)
controller.decrement();         // Subtract 1 (respects minimum)
controller.increment(10);       // Add custom value
controller.decrement(5);        // Subtract custom value
controller.addDigit(5);         // Add digit 5
controller.addDecimalSeparator(); // Add decimal separator
controller.addThreeZero();      // Multiply by 1000 (only for integers)
controller.backspace();         // Delete last character
controller.clearAll();          // Clear all text
```

### Key Features

- **Smart Formatting**: Automatically formats numbers with thousand separators during input
- **Locale Support**: Adapts decimal and group separators based on locale (e.g., "1,234.56" for en_US, "1.234,56" for de_DE)
- **Min/Max Validation**: Prevents input outside specified range
- **Decimal Control**: Configurable decimal digits (0 for integers only)
- **Cursor Management**: Smart cursor positioning after operations

## Important Notes

### Required Setup

1. **Wrap with NumberKeyboardViewInsets**: This is **mandatory** for proper view inset management:

```dart
void main() {
  runApp(MaterialApp(
    builder: (context, child) =>
        NumberKeyboardViewInsets(child: child ?? const SizedBox.shrink()),
    home: MyHomePage(),
  ));
}
```

**Why is this required?**
- `NumberKeyboardViewInsets` manages the view insets for the custom keyboard
- It ensures content is pushed up when the keyboard appears
- Without it, the keyboard will overlay your content

2. **MediaQuery Support**: Ensure you have `WidgetsApp` or `MaterialApp` **above** `NumberKeyboardViewInsets`

3. **Scaffold Integration**: Use `Scaffold`, `SafeArea`, or similar widgets **below** `NumberKeyboardViewInsets` to respond to view insets

### Back Button Handling

The keyboard automatically handles the back button:
- When keyboard is open: back button closes the keyboard
- When keyboard is closed: back button works normally (pops the route)

This is implemented using `PopScope` widget internally.

### Architecture

The package uses a modular architecture:

- **NumberField**: Main widget that manages focus, keyboard display, and form integration
  - Uses `PopScope` for back button handling
  - Manages overlay entry for keyboard
  - Handles focus and validation
  
- **NumberFieldPreview**: Internal widget that displays the text field
  - Uses `TextFormField` with `keyboardType: TextInputType.none`
  - Handles form validation and submission
  
- **NumberKeyboard**: Custom keyboard with slide animation
  - Rendered in an overlay
  - Uses `SlideTransition` for smooth animation
  - Positioned at bottom with `SafeArea`
  
- **NumberEditingController**: Specialized controller extending `TextEditingController`
  - Smart number formatting with locale support
  - Min/max validation
  - Decimal digit control
  
- **NumberKeyboardViewInsets**: Manages view insets and keyboard positioning
  - Inserts modified `MediaQuery` with custom bottom insets
  - Tracks multiple keyboards if needed
  - Provides helper methods to check if keyboard is showing

- **NumberKeyboardButtons**: Layout and rendering of keyboard buttons
  - 4x4 grid layout (3 columns for numbers + 1 column for actions)
  - Customizable button styles
  
- **KeyboardBody**: Manages keyboard size reporting to view insets system

## API Reference

### NumberField Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `focusNode` | `FocusNode?` | `null` | Focus node for the field |
| `controller` | `NumberEditingController?` | `null` | Controller for managing the number value |
| `style` | `TextStyle?` | `null` | Text style for the input |
| `decoration` | `InputDecoration` | `const InputDecoration()` | Decoration for the input field |
| `keyboardStyles` | `NumberKeyboardStyles` | `const NumberKeyboardStyles()` | Styling for the keyboard |
| `enabled` | `bool` | `true` | Whether the field is enabled |
| `readOnly` | `bool` | `false` | Whether the field is read-only |
| `textAlign` | `TextAlign` | `TextAlign.end` | Text alignment |
| `cursorColor` | `Color` | `Color(0xFF0070F4)` | Cursor color |
| `onChanged` | `ValueChanged<num?>?` | `null` | Called when value changes |
| `onFieldSubmitted` | `Function(num?)?` | `null` | Called when keyboard is submitted |
| `onEditingComplete` | `Function()?` | `null` | Called when editing is complete |
| `autovalidateMode` | `AutovalidateMode` | `AutovalidateMode.disabled` | Form validation mode |
| `validator` | `FormFieldValidator<num?>?` | `null` | Form field validator |
| `onSaved` | `FormFieldSetter<num?>?` | `null` | Form field save callback |

### NumberEditingController Properties

| Property | Type | Description |
|----------|------|-------------|
| `initialNumber` | `num?` | Initial number value |
| `decimalDigits` | `int` | Number of decimal digits (0 for integers) |
| `minimum` | `num?` | Minimum allowed value |
| `maximum` | `num?` | Maximum allowed value |
| `locale` | `String` | Locale for number formatting (default: 'en_US') |

## Requirements

- Flutter >= 3.24.3
- Dart SDK ^3.5.3

## Dependencies

- `flutter`: Flutter SDK
- `intl`: For internationalization and number formatting support

## Advanced Examples

### Custom Locale (Vietnamese)

```dart
final controller = NumberEditingController(
  initialNumber: 1234567.89,
  decimalDigits: 2,
  locale: 'vi_VN', // Vietnamese locale
);

// Will format as: 1.234.567,89 (using . for thousands, , for decimal)
```

### Integer Only Field

```dart
final controller = NumberEditingController(
  initialNumber: 1000,
  decimalDigits: 0, // No decimal digits
  minimum: 0,
  maximum: 999999,
);

// Decimal separator button will not be shown
// Triple zero button will work
```

### Currency Input

```dart
NumberField(
  controller: NumberEditingController(
    decimalDigits: 2,
    minimum: 0,
  ),
  decoration: InputDecoration(
    labelText: 'Amount',
    prefixText: '\$ ',
    suffixText: ' USD',
    border: OutlineInputBorder(),
  ),
  textAlign: TextAlign.end,
)
```

### Percentage Input

```dart
NumberField(
  controller: NumberEditingController(
    decimalDigits: 2,
    minimum: 0,
    maximum: 100,
  ),
  decoration: InputDecoration(
    labelText: 'Discount',
    suffixText: ' %',
  ),
)
```

### Checking if Keyboard is Showing

```dart
@override
Widget build(BuildContext context) {
  final isKeyboardShowing = 
      NumberKeyboardViewInsetsQuery.keyboardShowingIn(context);
  
  return Scaffold(
    body: Column(
      children: [
        if (isKeyboardShowing)
          Text('Keyboard is open'),
        NumberField(...),
      ],
    ),
  );
}
```

## Example

See the `example/` directory for a complete working example with:
- Basic number input
- Custom keyboard styling
- Form integration
- Different configurations

## Behavior Details

### Number Formatting

- **During Input**: Numbers are formatted with thousand separators, but decimal part is kept as-is (e.g., "1,234.5")
- **On Submit/Blur**: Numbers are fully formatted with all decimal digits (e.g., "1,234.50" for 2 decimal digits)
- **Zero Handling**: When field contains 0 and gains focus, all text is selected for easy replacement

### Triple Zero (000) Button

- Only works when:
  - Text is not empty
  - No decimal separator present (integers only)
  - Current number is not 0
- Effect: Multiplies current number by 1000

### Decimal Separator Button

- Only shown when `decimalDigits > 0`
- Disabled if decimal separator already present
- Adapts to locale (e.g., "." for en_US, "," for de_DE)

### Validation

- Min/max validation happens on blur/submit
- If value is outside range, it's automatically corrected to nearest valid value
- If field is empty and has minimum, it's set to minimum on blur

## Limitations

- Locale support depends on `intl` package's available locales
- Test coverage needs improvement
- No support for negative numbers yet
- No support for scientific notation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
