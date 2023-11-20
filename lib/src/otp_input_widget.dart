import 'package:flutter/material.dart';

class OtpInputField extends StatefulWidget {
  final int otpInputFieldCount;
  final double width;
  final Function(String) onOtpEntered;

  const OtpInputField({
    super.key,
    required this.otpInputFieldCount,
    required this.width,
    required this.onOtpEntered,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<String> otpNumbers;

  @override
  void initState() {
    super.initState();
    otpNumbers = List.filled(widget.otpInputFieldCount, '');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.otpInputFieldCount,
          (index) => SizedBox(
            width: MediaQuery.of(context).size.width * widget.width,
            child: TextFormField(
              key: Key('otpField_$index'),
              autofocus: index == 0,
              onSaved: (pin) {},
              onChanged: (value) {
                otpNumbers[index] = value;
                if (value.length == 1) {
                  if (index < widget.otpInputFieldCount - 1) {
                    FocusScope.of(context).nextFocus();
                  } else {
                    widget.onOtpEntered(otpNumbers.join());
                  }
                }
              },
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: const InputDecoration(counterText: ""),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}
