import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkey_app/src/models/points.dart';
import 'package:turkey_app/src/pages/cart.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../repository/cart_repository.dart';
import '../repository/coupon_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  dynamic all_point = currentUser.value.all_points;
  double total = 0.0;
  String currency = '';

  double equation = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;
  BuildContext context;
  getCurrencyAndEquation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currency = prefs.getString('currency');
      equation = prefs.getDouble('equation');
    });
  }

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCarts(BuildContext context, {String message}) async {
    carts.clear();
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          if (_cart == null) {
            print('aaaaaaa');
          } else {
            coupon = _cart.food.applyCoupon(coupon);
            print('sadsad :${coupon.discountType}');
            coupon.discountables.forEach((element) {
              if (coupon.valid && _cart.food.description != '') {
                if (element.discountableType == "App\\Models\\Food") {
                  if (element.discountableId == _cart.food.id) {
                    // coupon = _couponDiscountPrice(coupon);
                    _cart.extras.forEach((element) {
                      if (coupon.discountType == 'fixed') {
                        element.price -= coupon.discount;
                      } else {
                        element.price = element.price -
                            (element.price * coupon.discount / 100);
                      }
                      if (element.price < 0) {
                        element.price = 0;
                      }
                    });
                  }
                } else if (element.discountableType ==
                    "App\\Models\\Restaurant") {
                  if (element.discountableId == _cart.food.restaurant.id) {
                    // coupon = _couponDiscountPrice(coupon);
                    _cart.extras.forEach((element) {
                      if (coupon.discountType == 'fixed') {
                        element.price -= coupon.discount;
                      } else {
                        element.price = element.price -
                            (element.price * coupon.discount / 100);
                      }
                      if (element.price < 0) {
                        element.price = 0;
                      }
                    });
                  }
                } else if (element.discountableType ==
                    "App\\Models\\Category") {
                  if (element.discountableId == _cart.food.category.id) {
                    // coupon = _couponDiscountPrice(coupon);
                    _cart.extras.forEach((element) {
                      if (coupon.discountType == 'fixed') {
                        element.price -= coupon.discount;
                      } else {
                        element.price = element.price -
                            (element.price * coupon.discount / 100);
                      }
                      if (element.price < 0) {
                        element.price = 0;
                      }
                    });
                  }
                }
              }
            });
            carts.add(_cart);
          }
        });
      }
    }, onError: (a) {
      print("ERROR$a");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (carts.isNotEmpty) {
        calculateSubtotal();
      }
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
      onLoadingCartDone();
    });
  }

  void onLoadingCartDone() {}

  void listenForCartsCount(BuildContext context, {String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    });
  }

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
    });
    listenForCarts(context, message: S.of(context).carts_refreshed_successfuly);
  }

  void removeFromCart(Cart _cart, BuildContext context) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).reset_cart),
      ));
    });
  }

  void calculateSubtotal() async {
    await getCurrencyAndEquation();
    double cartPrice = 0;
    subTotal = 0;
    carts.forEach((cart) {
      cartPrice = cart.food.price;
      cart.extras.forEach((element) {
        cartPrice += element.price;
      });

      cartPrice *= cart.quantity;
      subTotal = subTotal + cartPrice;
      subTotal = subTotal * equation;
    });
    if (Helper.canDelivery(carts[0].food.restaurant, carts: carts)) {
      deliveryFee = carts[0].food.restaurant.deliveryFee;
    }
    taxAmount =
        (subTotal + deliveryFee) * carts[0].food.restaurant.defaultTax / 100;
    total = subTotal + taxAmount + deliveryFee;
    if (usePoints) {
      Points points = await getPoints();
      if (total <= points.data.value) {
        total = 0;
      } else {
        total = total - points.data.value;
      }
    }

    setState(() {});
  }

  void doApplyCoupon(String code, BuildContext context,
      {String message}) async {
    coupon = new Coupon.fromJSON({"code": code, "valid": null});
    final Stream<Coupon> stream = await verifyCoupon(code);
    stream.listen((Coupon _coupon) async {
      coupon = _coupon;

      listenForCarts(context);
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      listenForCarts(context);
//      saveCoupon(currentCoupon).then((value) => {
//          });
    });
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  void goCheckout(BuildContext context) {
    // if (!currentUser.value.profileCompleted()) {
    //   scaffoldKey?.currentState?.showSnackBar(SnackBar(
    //     content: Text(S.of(context).completeYourProfileDetailsToContinue),
    //     action: SnackBarAction(
    //       label: S.of(context).settings,
    //       textColor: Theme.of(context).accentColor,
    //       onPressed: () {
    //         Navigator.of(context).pushNamed('/Settings');
    //       },
    //     ),
    //   ));
    // } else {
    if (carts[0].food.restaurant.closed) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    } else {
      Navigator.of(context).pushNamed('/DeliveryPickup');
    }
    // }
  }

  Color getCouponIconColor(BuildContext context) {
    print(coupon.toMap());
    if (coupon?.valid == true) {
      return Colors.green;
    } else if (coupon?.valid == false) {
      return Colors.redAccent;
    }
    return Theme.of(context).focusColor.withOpacity(0.7);
  }
}
