import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BottomDisplayText extends StatelessWidget {
  const BottomDisplayText({
    Key key,
    @required this.colorTheme,
    @required this.actionText,
    @required this.displayText,
    @required this.textGestureRecognizer,
  }) : super(key: key);

  final Color colorTheme;
  final String displayText,actionText;
  final TapGestureRecognizer textGestureRecognizer;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25.0),
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: Container(
              // padding: const EdgeInsets.only(left: 20.0),
              alignment: Alignment.center,
              child:RichText(text: TextSpan(
                  text: '$displayText',
                  style: TextStyle(color: colorTheme,fontSize: 16.0),
                  children: [
                    TextSpan(
                        text: '$actionText',
                        style: TextStyle(color: colorTheme,fontSize: 18,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,
                            decorationThickness: 2),
                        recognizer: textGestureRecognizer
                    )
                  ]
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}