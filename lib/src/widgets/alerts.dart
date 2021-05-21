import 'package:agro_farm/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppAlerts {
  static Future<void> showErrorDialog(
      bool isIOS, BuildContext context, String errorMessage) async {
    return (isIOS)
        ? showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                  'Error',
                  style: TextStyles.subTitle,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        errorMessage,
                        style: TextStyles.body,
                      ),
                    ],
                  ),
                ),
                actions: [
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Okay',
                      style: TextStyles.body,
                    ),
                  ),
                ],
              );
            },
          )
        : showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Error',
                  style: TextStyles.subTitle,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        errorMessage,
                        style: TextStyles.body,
                      ),
                    ],
                  ),
                ),
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Okay',
                      style: TextStyles.body,
                    ),
                  ),
                ],
              );
            });
  }
}
