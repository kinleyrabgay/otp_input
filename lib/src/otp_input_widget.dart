import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum OtpFieldStyle { box, underline, dash, circle }

enum OtpFieldOrientation { horizontal, vertical }

class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    required this.otpInputFieldCount,
    required this.onOtpEntered,
    this.fieldStyle = OtpFieldStyle.box,
    this.orientation = OtpFieldOrientation.horizontal,
    this.fieldWidth = 50.0,
    this.fieldHeight = 60.0,
    this.fieldGap = 8.0,
    this.borderRadius = 8.0,
    this.borderWidth = 1.5,
    this.filled = false,
    this.fillColor,
    this.cursorColor,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.textStyle,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.keyboardType = TextInputType.number,
    this.autoFocus = false,
    this.enabled = true,
    this.autofillHints = const [AutofillHints.oneTimeCode],
    this.inputFormatters,
    this.onChanged,
    this.controller,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding = EdgeInsets.zero,
  });

  final int otpInputFieldCount;
  final Function(String) onOtpEntered;
  final ValueChanged<String>? onChanged;
  final OtpFieldStyle fieldStyle;
  final OtpFieldOrientation orientation;
  final double fieldWidth;
  final double fieldHeight;
  final double fieldGap;
  final double borderRadius;
  final double borderWidth;
  final bool filled;
  final Color? fillColor;
  final Color? cursorColor;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final TextStyle? textStyle;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final bool obscureText;
  final String obscuringCharacter;
  final TextInputType keyboardType;
  final bool autoFocus;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets padding;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _otp;

  @override
  void initState() {
    super.initState();

    // Initialize OTP list
    _otp = List.filled(widget.otpInputFieldCount, '');

    // Initialize controllers with existing text if parent controller exists
    _controllers = List.generate(
      widget.otpInputFieldCount,
      (index) => TextEditingController(
        text: widget.controller?.text.length != null &&
                widget.controller!.text.length > index
            ? widget.controller!.text[index]
            : '',
      ),
    );

    // Initialize focus nodes
    _focusNodes = List.generate(widget.otpInputFieldCount, (_) => FocusNode());

    // Listen to parent controller
    widget.controller?.addListener(_syncExternalController);

    // Auto-focus first field after build
    if (widget.autoFocus && _focusNodes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
        _controllers[0].selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controllers[0].text.length,
        );
      });
    }
  }

  // Sync parent controller changes to individual fields
  void _syncExternalController() {
    if (widget.controller == null) return;
    final text = widget.controller!.text;
    for (int i = 0; i < widget.otpInputFieldCount; i++) {
      _controllers[i].text = i < text.length ? text[i] : '';
      _otp[i] = _controllers[i].text;
    }
    _emitChange(); // Ensure change is emitted when controller updates
  }

  @override
  void dispose() {
    for (var controller in _controllers) controller.dispose();
    for (var node in _focusNodes) node.dispose();
    widget.controller?.removeListener(_syncExternalController);
    super.dispose();
  }

  // Determine border based on style
  InputBorder _getBorder(Color color) {
    switch (widget.fieldStyle) {
      case OtpFieldStyle.box:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: color, width: widget.borderWidth),
        );
      case OtpFieldStyle.underline:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: widget.borderWidth),
        );
      case OtpFieldStyle.dash:
        return OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: color, width: widget.borderWidth),
        );
      case OtpFieldStyle.circle:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.fieldWidth / 2),
          borderSide: BorderSide(color: color, width: widget.borderWidth),
        );
    }
  }

  // Emit OTP change only for non-empty fields
  void _emitChange() {
    final value = _otp.join();
    final nonEmptyCount = _otp.where((e) => e.isNotEmpty).length;

    // Emit onChanged always if something changes
    widget.onChanged?.call(value);

    // Emit onOtpEntered only if full length entered
    if (nonEmptyCount == widget.otpInputFieldCount) {
      widget.onOtpEntered(value);
    }
  }

  void _onChanged(String value, int index) {
    // Handle paste: multiple characters at once
    if (value.length > 1) {
      for (int i = 0; i < value.length && index + i < _otp.length; i++) {
        _controllers[index + i].text = value[i];
        _otp[index + i] = value[i];
      }
      int nextIndex = index + value.length;
      if (nextIndex < _otp.length) {
        _focusNodes[nextIndex].requestFocus();
      } else {
        _focusNodes.last.unfocus();
      }
      _emitChange();
      return;
    }

    // Single character input
    _otp[index] = value;

    if (value.isNotEmpty && index < _otp.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (index == _otp.length - 1) {
      _focusNodes[index].unfocus();
    }

    _emitChange();
  }

  // Handle backspace key to move back
  void _onKey(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      _otp[index - 1] = '';
      _emitChange();
    }
  }

  Widget _buildTextField(int index) {
    return SizedBox(
      width: widget.fieldWidth,
      height: widget.fieldHeight,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) => _onKey(event, index),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: widget.keyboardType,
          textAlign: TextAlign.center,
          style: widget.textStyle ?? Theme.of(context).textTheme.titleLarge,
          maxLength: 1,
          obscureText: widget.obscureText,
          obscuringCharacter: widget.obscuringCharacter,
          enabled: widget.enabled,
          cursorColor: widget.cursorColor,
          cursorHeight: widget.cursorHeight,
          cursorWidth: widget.cursorWidth,
          cursorRadius: widget.cursorRadius,
          autofillHints: widget.autofillHints,
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            LengthLimitingTextInputFormatter(1),
            if (widget.inputFormatters != null) ...widget.inputFormatters!,
          ],
          decoration: InputDecoration(
            counterText: '',
            filled: widget.filled,
            fillColor: widget.fillColor,
            enabledBorder: _getBorder(widget.enabledBorderColor ?? Colors.grey),
            focusedBorder: _getBorder(widget.focusedBorderColor ?? Colors.blue),
          ),
          onChanged: (value) => _onChanged(value, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (int i = 0; i < widget.otpInputFieldCount; i++) {
      children.add(_buildTextField(i));
      if (i < widget.otpInputFieldCount - 1) {
        children.add(
          SizedBox(
            width: widget.orientation == OtpFieldOrientation.horizontal
                ? widget.fieldGap
                : 0,
            height: widget.orientation == OtpFieldOrientation.vertical
                ? widget.fieldGap
                : 0,
          ),
        );
      }
    }

    return Padding(
      padding: widget.padding,
      child: widget.orientation == OtpFieldOrientation.horizontal
          ? Row(
              mainAxisAlignment: widget.mainAxisAlignment,
              crossAxisAlignment: widget.crossAxisAlignment,
              children: children,
            )
          : Column(
              mainAxisAlignment: widget.mainAxisAlignment,
              crossAxisAlignment: widget.crossAxisAlignment,
              children: children,
            ),
    );
  }
}
