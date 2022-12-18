import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:turkey_app/src/elements/DrawerWidget.dart';
import 'package:turkey_app/src/models/points.dart';
import 'package:turkey_app/src/repository/cart_repository.dart';
import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

bool usePoints = false;

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts(context);
    gPoints();
    getSettings();
    super.initState();
  }

  var pointLoading = false;
  Points points;
  gPoints() async {
    points = await getPoints();
    setState(() {
      pointLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: _con.scaffoldKey,
        // bottomNavigationBar: CartBottomDetailsWidget(con: _con),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   onPressed: () {
          //     if (widget.routeArgument != null) {
          //       Navigator.of(context).pushReplacementNamed(
          //           widget.routeArgument.param,
          //           arguments: RouteArgument(id: widget.routeArgument.id));
          //     } else {
          //       Navigator.of(context)
          //           .pushReplacementNamed('/Pages', arguments: 2);
          //     }
          //   },
          //   icon: Icon(Icons.arrow_back),
          //   color: Theme.of(context).hintColor,
          // ),
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => _con.scaffoldKey?.currentState?.openDrawer(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).cart,
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        drawer: DrawerWidget(),
        body: RefreshIndicator(
          onRefresh: _con.refreshCarts,
          child: _con.carts.isEmpty
              ? EmptyCartWidget()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.shopping_cart,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            S.of(context).shopping_cart,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Text(
                            S
                                .of(context)
                                .verify_your_quantity_and_click_checkout,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      ListView.separated(
                        padding: EdgeInsets.only(top: 15, bottom: 20),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.carts.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 15);
                        },
                        itemBuilder: (context, index) {
                          return CartItemWidget(
                            cart: _con.carts.elementAt(index),
                            heroTag: 'cart',
                            increment: () {
                              _con.incrementQuantity(
                                  _con.carts.elementAt(index));
                            },
                            decrement: () {
                              _con.decrementQuantity(
                                  _con.carts.elementAt(index));
                            },
                            onDismissed: () {
                              _con.removeFromCart(
                                  _con.carts.elementAt(index), context);
                            },
                          );
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(18),
                        margin: EdgeInsets.only(bottom: 15),
                        // decoration: BoxDecoration(
                        //     color: Theme.of(context).primaryColor,
                        //     borderRadius: BorderRadius.all(Radius.circular(20)),
                        //     boxShadow: [
                        //       BoxShadow(
                        //           color: Theme.of(context)
                        //               .focusColor
                        //               .withOpacity(0.15),
                        //           offset: Offset(0, 2),
                        //           blurRadius: 5.0)
                        //     ]),
                        child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.text,
                              onSubmitted: (String value) {
                                _con.doApplyCoupon(value, context);
                              },
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                              controller: TextEditingController()
                                ..text = coupon?.code ?? '',
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintStyle:
                                    Theme.of(context).textTheme.bodyText1,
                                suffixText: coupon?.valid == null
                                    ? ''
                                    : (coupon.valid
                                        ? S.of(context).validCouponCode
                                        : S.of(context).invalidCouponCode),
                                suffixStyle: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .merge(TextStyle(
                                        color:
                                            _con.getCouponIconColor(context))),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Icon(
                                    Icons.confirmation_number,
                                    color: _con.getCouponIconColor(context),
                                    size: 28,
                                  ),
                                ),
                                hintText: S.of(context).haveCouponCode,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                              ),
                            ),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        width: 0.5,
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.5)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                S.of(context).use_points,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${pointLoading ? points.data.points : ''}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Checkbox(
                                          value: usePoints,
                                          onChanged: (val) {
                                            _usePointsChange(val);
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      CartBottomDetailsWidget(con: _con),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  _usePointsChange(val) {
    setState(() {
      usePoints = val;
    });
    _con.calculateSubtotal();
  }
}
