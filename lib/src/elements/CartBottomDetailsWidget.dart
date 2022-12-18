import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';

class CartBottomDetailsWidget extends StatelessWidget {
  const CartBottomDetailsWidget({
    Key key,
    @required CartController con,
  })  : _con = con,
        super(key: key);

  final CartController _con;

  @override
  Widget build(BuildContext context) {
    return _con.carts.isEmpty
        ? SizedBox(height: 0)
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        S.of(context).subtotal,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Helper.getPrice(_con.subTotal, context,
                        style: Theme.of(context).textTheme.subtitle1,
                        zeroPlaceholder: '0')
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        S.of(context).delivery_fee,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    if (Helper.canDelivery(_con.carts[0].food.restaurant,
                        carts: _con.carts))
                      Helper.getPrice(
                          _con.carts[0].food.restaurant.deliveryFee, context,
                          style: Theme.of(context).textTheme.subtitle1,
                          zeroPlaceholder: 'Free')
                    else
                      Helper.getPrice(0, context,
                          style: Theme.of(context).textTheme.subtitle1,
                          zeroPlaceholder: 'Free')
                  ],
                ),
                SizedBox(height: 10),
                MaterialButton(
                  onPressed: () {
                    _con.goCheckout(context);
                  },
                  disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  color: !_con.carts[0].food.restaurant.closed
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).focusColor.withOpacity(0.5),
                  shape: StadiumBorder(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).checkout,
                        style: Theme.of(context).textTheme.bodyText1.merge(
                            TextStyle(color: Theme.of(context).primaryColor)),
                      ),
                      SizedBox(
                        width: 20,
                      ),


                      SizedBox(
                        width: 20,
                      ),
                      Helper.getPrice(_con.total, context,
                          style: Theme.of(context).textTheme.bodyText1.merge(
                              TextStyle(color: Theme.of(context).primaryColor)),
                          zeroPlaceholder: 'Free'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
  }
}
