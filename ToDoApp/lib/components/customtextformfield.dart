
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key key,
    @required this.textFormField,
    @required this.leadingIcon
  }) : super(key: key);

  final TextFormField textFormField;
  final Icon leadingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin:
      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
      child: Row(
        children: <Widget>[
          new Padding(
              padding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: leadingIcon
          ),
          Container(
            height: 30.0,
            width: 2.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 0.0, right: 10.0),
          ),
          Expanded(
              child: textFormField
          )
        ],
      ),
    );
  }
}