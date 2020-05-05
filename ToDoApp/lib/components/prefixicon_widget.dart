
import 'package:flutter/material.dart';

class PrefixIconWidget extends StatelessWidget {
  const PrefixIconWidget({
    Key key,
    @required this.prefixIcon
  }) : super(key: key);
  final Icon prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Padding(
              padding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
              child: prefixIcon
          ),
        ),
        Flexible(
          child: Container(
            height: 30.0,
            width: 2.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 0.0, right: 10.0),
          ),
        ),
      ],
    );
  }
}