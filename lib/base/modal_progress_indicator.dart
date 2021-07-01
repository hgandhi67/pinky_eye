import 'package:flutter/material.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';

class ModalProgressHUD extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Offset offset;
  final bool dismissible;
  final Widget child;
  final bool isAnimated;

  ModalProgressHUD({
    Key key,
    @required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.offset,
    this.dismissible = false,
    @required this.child,
    this.isAnimated: false,
  })  : assert(child != null),
        assert(inAsyncCall != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!inAsyncCall) return child;

    Widget layOutProgressIndicator;
    if (offset == null) {
      layOutProgressIndicator = Center(
        child: Container(
          alignment: Alignment.center,
          height: 120.0,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Palette.lightRedColor),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                'Loading...',
                style: Styles.subscriptionTextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: Palette.lightRedColor,
                ),
              )
            ],
          ),
        ),
      );
    } else {
      layOutProgressIndicator = Positioned(
        child: Container(
          alignment: Alignment.center,
          height: 120.0,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Palette.lightRedColor),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                'Loading...',
                style: Styles.subscriptionTextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: Palette.lightRedColor,
                ),
              )
            ],
          ),
        ),
        left: offset.dx,
        top: offset.dy,
      );
    }

    return new Stack(
      children: [
        child,
        Positioned.fill(
          child: Opacity(
            child: ModalBarrier(dismissible: dismissible, color: color),
            opacity: opacity,
          ),
        ),
        layOutProgressIndicator,
      ],
    );
  }
}
