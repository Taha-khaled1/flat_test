import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CartItemWidget extends StatefulWidget {
  String heroTag;
  Cart cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  CartItemWidget(
      {Key key,
      this.cart,
      this.heroTag,
      this.increment,
      this.decrement,
      this.onDismissed})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.cart.id),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.secondary,
        focusColor: Theme.of(context).colorScheme.secondary,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          Navigator.of(context).pushNamed('/Food',
              arguments: RouteArgument(
                  id: widget.cart.food.id, heroTag: widget.heroTag));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: CachedNetworkImage(
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                  imageUrl: widget.cart.food.image.thumb,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
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
                            widget.cart.food.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            children: <Widget>[
                              Helper.getPrice(widget.cart.food.price, context,
                                  style: Theme.of(context).textTheme.headline4,
                                  zeroPlaceholder: '-'),
                              widget.cart.food.discountPrice > 0
                                  ? Helper.getPrice(
                                  widget.cart.food.discountPrice, context,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(TextStyle(color: Colors.grey.shade700,
                                      decoration:
                                      TextDecoration.lineThrough)))
                                  : SizedBox(height: 0),
                            ],
                          ),
                          Wrap(
                            children: List.generate(widget.cart.extras.length,
                                (index) {
                              return Row(

                                children: [
                                  Text(
                                    widget.cart.extras.elementAt(index).name,
                                  ),
                                  SizedBox(width: 10,),
                                  Helper.getPrice(widget.cart.extras.elementAt(index).price, context,
                                      ),
                                ],
                              );
                            }),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.increment();
                            });
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon: Icon(Icons.add_circle,),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        Text(widget.cart.quantity.toString(),
                            style: Theme.of(context).textTheme.subtitle1),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.decrement();
                            });
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon: Icon(Icons.remove_circle),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
