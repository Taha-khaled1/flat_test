import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../repository/cart_repository.dart';
import '../repository/category_repository.dart';
import '../repository/food_repository.dart';

class CategoryController extends ControllerMVC {
  List<Food> foods = <Food>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Category category;
  bool loadCart = false;
  List<Cart> carts = [];
  BuildContext context;
  CategoryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForFoodsByCategory(BuildContext context,
      {String id, String message}) async {
    final Stream<Food> stream = await getFoodsByCategory(id);
    stream.listen((Food _food) {
      setState(() {
        foods.add(_food);
      });
    }, onError: (a) {
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

  void listenForCategory(BuildContext context,
      {String id, String message}) async {
    final Stream<Category> stream = await getCategory(id);
    stream.listen((Category _category) {
      setState(() => category = _category);
    }, onError: (a) {
      print(a);
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

  Future<void> listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
  }

  bool isSameRestaurants(Food food) {
    if (carts.isNotEmpty) {
      return carts[0].food?.restaurant?.id == food.restaurant?.id;
    }
    return true;
  }

  void addToCart(Food food, BuildContext context, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _newCart = new Cart();
    _newCart.food = food;
    _newCart.extras = [];
    _newCart.quantity = 1;
    // if food exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {
      _oldCart.quantity++;
      updateCart(_oldCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).this_food_was_added_to_cart),
        ));
      });
    } else {
      // the food doesnt exist in the cart add new one
      addCart(_newCart, reset).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        if (reset) carts.clear();
        carts.add(_newCart);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).thisFoodWasAddedToFavorite),
        ));
      });
    }
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  Future<void> refreshCategory() async {
    foods.clear();
    category = new Category();
    listenForFoodsByCategory(context,
        message: S.of(context).category_refreshed_successfuly);
    listenForCategory(context,
        message: S.of(context).category_refreshed_successfuly);
  }
}
