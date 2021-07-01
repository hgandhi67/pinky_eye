import 'package:flutter/material.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';

class SubscriptionTile extends StatefulWidget {
  final bool isSelectionAvail;
  final bool isSelected;
  final String name;
  final String price;
  final String reviews;
  final Color subsPlanColor;

  const SubscriptionTile({
    Key key,
    this.isSelectionAvail,
    this.isSelected,
    this.name,
    this.price,
    this.reviews,
    this.subsPlanColor,
  }) : super(key: key);

  @override
  _SubscriptionTileState createState() => _SubscriptionTileState();
}

class _SubscriptionTileState extends State<SubscriptionTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Palette.subscriptionBgColor,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _getLeftLayout(),
            ),
            Visibility(
              visible: widget.isSelectionAvail && widget.isSelected,
              child: _getRightLayout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getLeftLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.name,
          style: Styles.subscriptionTextStyle(
            color: Palette.white,
            fontWeight: FontWeight.w400,
            fontSize: 15.0,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Row(
          children: <Widget>[
            Text(
              widget.price,
              style: Styles.subscriptionTextStyle(
                color: Palette.white,
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              '-',
              style: Styles.subscriptionTextStyle(
                color: Palette.white,
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              '${widget.reviews} Reviews',
              style: Styles.subscriptionTextStyle(
                color: Palette.white,
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getRightLayout() {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Image.asset(
        'images/check_subscription.png',
        height: 30.0,
        width: 30.0,
      ),
    );
  }
}
