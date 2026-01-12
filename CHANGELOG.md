## 1.1.0

### New Features
* Added locale support for number formatting (decimal and group separators)
* Added `setNumberAndFormat()` method to controller for full formatting
* Added `setDecimalDigits()` method to dynamically change decimal digits
* Added support for custom increment/decrement values
* Added `PopScope` for better back button handling
* Added `onFieldSubmitted` callback
* Added `onEditingComplete` callback

### Improvements
* Improved number formatting logic with separate formatting for input and display
* Enhanced cursor management after operations
* Better validation with auto-correction to min/max values
* Improved zero handling - auto-select all text when field contains 0
* Enhanced triple zero (000) button - now multiplies by 1000
* Better keyboard animation with `SlideTransition`
* Improved view insets management

### UI/UX Enhancements
* Added customizable button radius
* Added customizable icon color for backspace button
* Submit button now shows checkmark icon by default (empty label)
* Added shadow and elevation to keyboard buttons
* Improved button press feedback with overlay colors

### Bug Fixes
* Fixed cursor positioning after backspace operation
* Fixed decimal separator handling during input
* Fixed formatting issues when switching between integer and decimal modes
* Fixed keyboard overlay positioning

### Documentation
* Comprehensive README with detailed API reference
* Added advanced usage examples
* Added behavior details section
* Added architecture documentation

## 1.0.0

* Initial release
* Custom number keyboard with slide animation
* Basic number formatting with thousand separators
* Min/max validation
* Form integration
* Customizable keyboard styles
