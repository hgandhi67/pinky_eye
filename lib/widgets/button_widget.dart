import 'package:flutter/material.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';

class ButtonWidget extends StatefulWidget {
  final String name;
  final Color bgColor;
  final double size;
  final Color textColor;

  const ButtonWidget({
    Key key,
    this.name,
    this.bgColor = Palette.primaryColor,
    this.size : 18, this.textColor : Colors.white,
  }) : super(key: key);

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
              ),
            ]),
        child: Text(
          widget.name,
          textAlign: TextAlign.center,
          style: Styles.buttonTextStyle(
            color: widget.textColor,
            size: widget.size,
          ),
        ));
  }
}
