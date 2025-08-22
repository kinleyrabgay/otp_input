# OtpInputField

A Flutter package that provides a fully customizable OTP (One-Time Password) input field with multiple styles and orientations.

## Installation

To use this package, add `otp_input` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  otp_input: ^1.0.4
````

## Then run

```
flutter pub get
```

## Usage

Import the package in your Dart file:

```dart
import 'package:otp_input/otp_input.dart';
```

### Basic Example

```dart
OtpInputField(
  otpInputFieldCount: 4,
  width: 0.2,
  onOtpEntered: (otp) {
    print('Entered OTP: $otp');
    // Perform actions with the entered OTP
  },
)
```

### Advanced Example

```dart
OtpInputField(
  otpInputFieldCount: 6,
  onOtpEntered: (otp) {
    print('Entered OTP: $otp');
  },
  fieldStyle: OtpFieldStyle.underline,
  orientation: OtpFieldOrientation.horizontal,
  fieldHeight: 40,
  enabledBorderColor: LTColors.neutral90,
  focusedBorderColor: LTColors.primary50,
  obscureText: false,
  autoFocus: true,
  keyboardType: TextInputType.number,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  textStyle: context.theme.textTheme.labelLarge,
),
```

## Properties

* **otpInputFieldCount**: The number of OTP input fields.
* **width**: The width factor of each input field (between 0.0 and 1.0).
* **onOtpEntered**: Callback triggered when all OTP fields are filled.
* **fieldStyle**: Choose between `box`, `underline`, or `dash` style.
* **orientation**: Layout direction (`horizontal` or `vertical`).
* **fieldHeight**: Height of each input field.
* **enabledBorderColor**: Border color when the field is not focused.
* **focusedBorderColor**: Border color when the field is focused.
* **obscureText**: Whether to hide the entered digits (e.g., for passwords).
* **autoFocus**: Automatically focus the first field when widget is built.
* **keyboardType**: Input type (e.g., `TextInputType.number`).
* **mainAxisAlignment**: Controls spacing/alignment between fields.
* **textStyle**: Style for the input text.

## Improvements in v1.0.3

* Added support for **different field styles** (`box`, `underline`, `dash`).
* Introduced **horizontal and vertical orientations**.
* Support for **custom colors** for focused and unfocused borders.
* Added **obscureText** option for password-style inputs.
* **MainAxisAlignment** support for flexible spacing/alignment.
* Improved **keyboard type handling**.
* Enhanced **customization for text style, height, and spacing**.

## Issues and Contributions

Feel free to open issues or contribute to this package on GitHub.