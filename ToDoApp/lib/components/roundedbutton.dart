
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.colorTheme,
    @required this.buttonName,
    @required this.onPressed
  }) : super(key: key);

  final Color colorTheme;
  final String buttonName;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              splashColor:  colorTheme,
              color:  colorTheme,
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "$buttonName",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20,letterSpacing: 1.5),
                    ),
                  ),
                  Spacer(),
                  Transform.translate(
                    offset: Offset(15.0, 0.0),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 10.0),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                            new BorderRadius.circular(28.0)),
                        splashColor: Colors.white,
                        color: Colors.white,
                        child: Icon(
                          Icons.arrow_forward,
                          color:  colorTheme,
                        ),
                        onPressed: () => {},
                      ),
                    ),
                  )
                ],
              ),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}