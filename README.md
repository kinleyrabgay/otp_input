# OtpInputField

A Flutter package that provides a customizable OTP (One-Time Password) input field.

## Installation

To use this package, add `otp_input` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  otp_input: ^1.0.3
```

## Then run

```
flutter pub get
```

## Usage

Import the package in your Dart file:

```
import 'package:otp_input/otp_input.dart';
```

Add the OtpInputField widget to your widget tree:

```
OtpInputField(
  otpInputFieldCount: 4,
  width: 0.2,
  onOtpEntered: (otp) {
    print('Entered OTP: $otp');
    // Perform actions with the entered OTP
  },
)
```

## Properties

- otpInputFieldCount: The number of OTP input fields.
- width: The width factor of each input field, a value between 0.0 and 1.0.
- onOtpEntered: Callback function triggered when all OTP fields are filled.

## Issues and Contributions

Feel free to open issues or contribute to this package on GitHub.
