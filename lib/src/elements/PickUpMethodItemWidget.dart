import 'package:flutter/material.dart';

import '../models/payment_method.dart';

// ignore: must_be_immutable
class PickUpMethodItem extends StatefulWidget {
  PaymentMethod paymentMethod;
  ValueChanged<PaymentMethod> onPressed;

  PickUpMethodItem({Key key, this.paymentMethod, this.onPressed}) : super(key: key);

  @override
  _PickUpMethodItemState createState() => _PickUpMethodItemState();
}

class _PickUpMethodItemState extends State<PickUpMethodItem> {
  String heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.secondary,
      focusColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        this.widget.onPressed(widget.paymentMethod);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 0.5)
                  ),
                ),
                Container(
                  height: widget.paymentMethod.selected ? 30 : 0,
                  width: widget.paymentMethod.selected ? 30 : 0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.secondary.withOpacity(this.widget.paymentMethod.selected ? 0.74 : 0),
                  ),
                  child: Icon(
                    Icons.check,
                    size: this.widget.paymentMethod.selected ? 20 : 0,
                    color: Theme.of(context).primaryColor.withOpacity(widget.paymentMethod.selected ? 0.9 : 0),
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.paymentMethod.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          widget.paymentMethod.description,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
