
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotask/utils/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {Key key, @required this.alertMessage, @required this.onPressed})
      : super(key: key);

  final String alertMessage;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.warning, color: Colors.amber[700]),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Alert',
              style: kTaskTextStyle.copyWith(color: Colors.amber[700]),
            ),
          ],
        ),
      ),
      content: Text(
        alertMessage ?? 'alert dialog',
        style: kTaskTextStyle,
      ),
      actions: <Widget>[
        Material(
          child: InkWell(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              child: Center(child: Text('No')),
            ),
            onTap: () {
              Navigator.pop(context, false);
            },
          ),
        ),
        Material(
          child: InkWell(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              child: Center(child: Text('Yes')),
            ),
            onTap: onPressed,
          ),
        ),
      ],
    );
  }
}