import 'package:flutter/material.dart';
import 'package:turkey_app/src/pages/cart.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../models/credit_card.dart';
import '../models/food_order.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class CheckoutController extends CartController {
  Payment payment;
  CreditCard creditCard = new CreditCard();
  bool loading = true;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }

  @override
  void onLoadingCartDone() {
    if (payment != null) addOrder(carts);
    super.onLoadingCartDone();
  }

  void addOrder(List<Cart> carts) async {
    Order _order = new Order();
    _order.foodOrders = new List<FoodOrder>();
    _order.tax = carts[0].food.restaurant.defaultTax;
    payment = payment == null ? Payment('my Fatoorah') : payment;
    _order.deliveryFee =
        payment == null ? carts[0].food.restaurant.deliveryFee : 0;
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.isPoint = usePoints;
    _order.orderStatus = _orderStatus;
    _order.deliveryAddress = settingRepo.deliveryAddress.value;

    carts.forEach((_cart) {
      FoodOrder _foodOrder = new FoodOrder();
      _foodOrder.quantity = _cart.quantity;
      _foodOrder.price = _cart.food.price;
      _foodOrder.food = _cart.food;
      _foodOrder.extras = _cart.extras;
      _order.foodOrders.add(_foodOrder);
    });
    orderRepo.addOrder(_order, this.payment).then((value) async {
      print('my order: ${value.toMap()}');
      settingRepo.coupon = new Coupon.fromJSON({});
      return value;
    }).then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  void updateCreditCard(CreditCard creditCard, BuildContext context) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).payment_card_updated_successfully),
      ));
    });
  }
}
