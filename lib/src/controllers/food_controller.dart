import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/extra.dart';
import '../models/favorite.dart';
import '../models/food.dart';
import '../repository/cart_repository.dart';
import '../repository/food_repository.dart';

class FoodController extends ControllerMVC {
  Food food;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  Favorite favorite;
  Map<String, List<bool>> required = {};
  bool loadCart = false;
  GlobalKey<ScaffoldState> scaffoldKey;
  BuildContext context;
  FoodController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForFood(BuildContext context,
      {String foodId, String message}) async {
    final Stream<Food> stream = await getFood(foodId);
    stream.listen((Food _food) {
      setState(() => food = _food);
      for (int i = 0; i < food.extraGroups.length; i++) {
        if (food.extraGroups[i].required == 1) {
          if (required['${food.extraGroups[i].id}'] == null) {
            required.putIfAbsent(
                food.extraGroups[i].id.toString(), () => [false]);
          } else {
            required['${food.extraGroups[i].id}'].add(false);
          }
        }
      }
      print(required.length);
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      calculateTotal();
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForFavorite({String foodId}) async {
    final Stream<Favorite> stream = await isFavoriteFood(foodId);
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
    });
  }

  void listenForCart() async {
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

  void addToCart(
      Food food, Map<String, List<bool>> requierdMap1, BuildContext context,
      {bool reset = false}) async {
    bool doAddToCart = false;
    if (requierdMap1.isEmpty) {
      doAddToCart = false;
    } else {
      List<bool> doneAdd = [];
      int ind = 0;
      requierdMap1.forEach((key, value) {
        doneAdd.add(false);
        bool reqBool = false;
        for (int i = 0; i < value.length; i++) {
          if (value[i] == true) {
            doneAdd[ind] = true;
            break;
          }
        }
        ind++;
      });
      print(doneAdd);
      for (int i = 0; i < doneAdd.length; i++) {
        if (doneAdd[i] == false) {
          doAddToCart = false;
          break;
        } else {
          doAddToCart = true;
        }
      }
    }
    if (doAddToCart) {
      print(doAddToCart);
      setState(() {
        this.loadCart = true;
      });
      var _newCart = new Cart();
      _newCart.food = food;
      _newCart.extras =
          food.extras.where((element) => element.checked).toList();
      _newCart.quantity = this.quantity;
      // if food exist in the cart then increment quantity
      var _oldCart = isExistInCart(_newCart);
      if (_oldCart != null) {
        _oldCart.quantity += this.quantity;
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).this_food_was_added_to_cart),
          ));
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: S.of(context).select_extras_to_add_them_on_the_food,
      );
    }
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  void addToFavorite(Food food, BuildContext context) async {
    var _favorite = new Favorite();
    _favorite.food = food;
    _favorite.extras = food.extras.where((Extra _extra) {
      return _extra.checked;
    }).toList();
    addFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = value;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).thisFoodWasAddedToFavorite),
      ));
    });
  }

  void removeFromFavorite(Favorite _favorite, BuildContext context) async {
    removeFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = new Favorite();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).thisFoodWasRemovedFromFavorites),
      ));
    });
  }

  Future<void> refreshFood() async {
    var _id = food.id;
    food = new Food();
    listenForFavorite(foodId: _id);
    listenForFood(context,
        foodId: _id, message: S.of(context).foodRefreshedSuccessfuly);
  }

  void calculateTotal() {
    this.loadCart = false;
    total = food?.price ?? 0;
    food?.extras?.forEach((extra) {
      total += extra.checked ? extra.price : 0;
    });
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (this.quantity <= 99) {
      ++this.quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal();
    }
  }
}
