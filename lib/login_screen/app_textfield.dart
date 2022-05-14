import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final FocusNode? focusNode;
  final bool alwaysUsefillColor;
  final Function(String value)? onChanged, onSubmitted;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  const AppTextField(
      {Key? key,
      this.label,
      this.focusNode,
      this.keyboardType,
      this.onChanged,
      this.onSubmitted,
      this.prefixIcon,
      this.alwaysUsefillColor = false})
      : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  Color fillColor = Colors.transparent;
  @override
  void initState() {
    fillColor = widget.alwaysUsefillColor
        ? fillColor = const Color(0xFF403757).withOpacity(0.6)
        : Colors.transparent;
    super.initState();

    _focusNode = FocusNode()
      ..addListener(() {
        if (!widget.alwaysUsefillColor) {
          if (_focusNode.hasFocus) {
            setState(() {
              fillColor = const Color(0xFF403757).withOpacity(0.6);
            });
          } else {
            setState(() {
              fillColor = Colors.transparent;
            });
          }
        }
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode ?? _focusNode,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
          fillColor: fillColor,
          filled: true,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          labelText: widget.label,

          // prefixIconConstraints:
          //     const BoxConstraints(maxHeight: 30, maxWidth: 30),
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.prefixIcon ?? const Offstage(),
            ],
          )),
    );
  }
}
