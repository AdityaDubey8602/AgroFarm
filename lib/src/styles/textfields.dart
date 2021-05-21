import 'package:agro_farm/src/styles/base.dart';
import 'package:agro_farm/src/styles/colors.dart';
import 'package:agro_farm/src/styles/text.dart';
import 'package:flutter/material.dart';

abstract class TextFieldStyles {
  static double get textBoxHorizontal => BaseStyles.listFieldHorizontal;

  static double get textBoxVertical => BaseStyles.listFieldVertical;

  static TextStyle get text => TextStyles.body;

  static TextStyle get placeholder => TextStyles.suggestion;

  static Color get cursorColor => AppColors.darkBlue;

  static Widget iconPrefix(IconData icon) => BaseStyles.iconPrefix(icon);

  static TextAlign get textAlign => TextAlign.center;

  static BoxDecoration get cupertinoDecoration {
    return BoxDecoration(
      border: Border.all(
        color: AppColors.straw,
        width: BaseStyles.borderwidth,
      ),
      borderRadius: BorderRadius.circular(BaseStyles.borderradius),
    );
  }

  static BoxDecoration get cupertinoErrorDecoration {
    return BoxDecoration(
      border: Border.all(
        color: AppColors.red,
        width: BaseStyles.borderwidth,
      ),
      borderRadius: BorderRadius.circular(BaseStyles.borderradius),
    );
  }

  static InputDecoration materialDecoration(
      String hintText, IconData icon, String errorText) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(8.0),
      hintText: hintText,
      hintStyle: TextFieldStyles.placeholder,
      border: InputBorder.none,
      errorText: errorText,
      errorStyle: TextStyles.error,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.straw,
          width: BaseStyles.borderwidth,
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderradius,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.straw,
          width: BaseStyles.borderwidth,
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderradius,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.straw,
          width: BaseStyles.borderwidth,
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderradius,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.red,
          width: BaseStyles.borderwidth,
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderradius,
        ),
      ),
      prefixIcon: iconPrefix(icon),
    );
  }
}
