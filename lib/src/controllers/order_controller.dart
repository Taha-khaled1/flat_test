import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  BuildContext context;
  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForOrders(context);
  }

  void listenForOrders(BuildContext context, {String message}) async {
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
    }, onError: (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void doCancelOrder(Order order, BuildContext context) {
    cancelOrder(order).then((value) {
      setState(() {
        order.active = false;
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e),
      ));
    }).whenComplete(() {
      //refreshOrders();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).orderThisorderidHasBeenCanceled(order.id)),
      ));
    });
  }

  Future<void> refreshOrders() async {
    orders.clear();
    listenForOrders(context,
        message: S.of(context).order_refreshed_successfuly);
  }
}
