import 'package:agro_farm/src/styles/text.dart';
import 'package:agro_farm/src/styles/textfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final bool isIos;
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String) onChanged;
  final String errorText;
  final String initialText;
  final int maxLines;

  AppTextField({
    @required this.isIos,
    @required this.hintText,
    @required this.cupertinoIcon,
    @required this.materialIcon,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.errorText,
    this.initialText,
    this.maxLines = 1,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode _node;
  bool displayCupertinoErrorBorder;
  TextEditingController _controller;

  @override
  void initState() {
    _node = FocusNode();
    _controller = TextEditingController();
    if (widget.initialText != null) _controller.text = widget.initialText;
    _node.addListener(_handleFocusChange);
    displayCupertinoErrorBorder = false;
    super.initState();
  }

  void _handleFocusChange() {
    if (_node.hasFocus == false && widget.errorText != null) {
      displayCupertinoErrorBorder = true;
    } else {
      displayCupertinoErrorBorder = false;
    }

    widget.onChanged(_controller.text);
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isIos) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
        child: Column(
          children: [
            CupertinoTextField(
              keyboardType: widget.textInputType,
              padding: EdgeInsets.all(12.0),
              placeholder: widget.hintText,
              textAlign: TextFieldStyles.textAlign,
              placeholderStyle: TextFieldStyles.placeholder,
              style: TextFieldStyles.text,
              cursorColor: TextFieldStyles.cursorColor,
              decoration: (displayCupertinoErrorBorder)
                  ? TextFieldStyles.cupertinoErrorDecoration
                  : TextFieldStyles.cupertinoDecoration,
              prefix: TextFieldStyles.iconPrefix(widget.cupertinoIcon),
              onChanged: widget.onChanged,
              obscureText: widget.obscureText,
              focusNode: _node,
              controller: _controller,
              maxLines: widget.maxLines,
            ),
            (widget.errorText != null)
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      left: 10.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.errorText,
                          style: TextStyles.error,
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
        child: TextField(
          keyboardType: (widget.textInputType != null)
              ? widget.textInputType
              : TextInputType.text,
          cursorColor: TextFieldStyles.cursorColor,
          style: TextFieldStyles.text,
          textAlign: TextFieldStyles.textAlign,
          decoration: TextFieldStyles.materialDecoration(
            widget.hintText,
            widget.materialIcon,
            widget.errorText,
          ),
          obscureText: widget.obscureText,
          controller: _controller,
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
        ),
      );
    }
  }
}
