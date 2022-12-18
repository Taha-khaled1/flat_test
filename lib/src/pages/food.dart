import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:turkey_app/src/models/extra.dart';
import '../../generated/l10n.dart';
import '../controllers/food_controller.dart';
import '../elements/AddToCartAlertDialog.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/ExtraItemWidget.dart';
import '../elements/ShoppingCartFloatButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/food_repository.dart';
import '../repository/user_repository.dart';

// ignore: must_be_immutable
class FoodWidget extends StatefulWidget {
  RouteArgument routeArgument;

  FoodWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _FoodWidgetState createState() {
    return _FoodWidgetState();
  }
}

Map<String, List<bool>> requierdMap = {};

class _FoodWidgetState extends StateMVC<FoodWidget> {
  FoodController _con;
  bool isChoosedREq = false;

  bool notRequired = false;

  _FoodWidgetState() : super(FoodController()) {
    _con = controller;
  }

  bool cartIsEmpty = true;
  Map<String, List<Extra>> groups;

  @override
  void initState() {
    _con.listenForFood(context, foodId: widget.routeArgument.id);
    _con.listenForCart();
    _con.listenForFavorite(foodId: widget.routeArgument.id);
    requierdMap = _con.required;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _con.refreshFood,
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          backgroundColor: Colors.grey.shade200,
          key: _con.scaffoldKey,
          body: _con.food == null || _con.food?.image == null
              ? CircularLoadingWidget(height: 500)
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 350,
                              child: Stack(
                                children: [
                                  Container(
                                    child: Hero(
                                      tag: widget.routeArgument.heroTag ??
                                          '' + _con.food.id,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20.0),
                                          bottomLeft: Radius.circular(20.0),
                                        ),
                                        child: CachedNetworkImage(
                                          height: 270,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                          imageUrl: _con.food.image.url,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            'assets/img/loading.gif',
                                            fit: BoxFit.cover,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      addToCart(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            description(),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 30,
                        right: 0,
                        child: _con.loadCart
                            ? SizedBox(
                                width: 60,
                                height: 60,
                                child: RefreshProgressIndicator(),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ShoppingCartFloatButtonWidget(
                                  iconColor: Theme.of(context).primaryColor,
                                  labelColor: Theme.of(context).hintColor,
                                  routeArgument: RouteArgument(
                                      param: '/Food', id: _con.food.id),
                                ),
                              ),
                      ),
                      Positioned(
                          top: 30,
                          left: 0,
                          child: IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                color: Theme.of(context).primaryColor,
                                size: 40,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              })),
                    ],
                  ),
                )),
    );
  }

  Widget addToCart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                MaterialButton(
                  padding: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  onPressed: () {
                    addFoodToCard();
                  },
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        Text(
                          S.of(context).add_to_cart,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Helper.getPrice(
                            _con.total,
                            context,
                            style: Theme.of(context).textTheme.headline4.merge(
                                TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5),
                _con.favorite?.id != null
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                            onPressed: () {
                              _con.removeFromFavorite(_con.favorite, context);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: Theme.of(context).colorScheme.secondary,
                            )),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                            onPressed: () {
                              if (currentUser.value.apiToken == null) {
                                Navigator.of(context).pushNamed("/Login");
                              } else {
                                _con.addToFavorite(_con.food, context);
                              }
                            },
                            icon: Icon(
                              Icons.favorite_border,
                              color: Theme.of(context).colorScheme.secondary,
                            )),
                      ),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _con.decrementQuantity();
                  },
                  iconSize: 30,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  icon: Icon(Icons.remove_circle_outline),
                  color: Theme.of(context).hintColor,
                ),
                Text(_con.quantity.toString(),
                    style: Theme.of(context).textTheme.subtitle1),
                IconButton(
                  onPressed: () {
                    _con.incrementQuantity();
                  },
                  iconSize: 30,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  icon: Icon(Icons.add_circle_outline),
                  color: Theme.of(context).hintColor,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Wrap(
        runSpacing: 8,
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _con.food?.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      _con.food?.restaurant?.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Helper.getPrice(
                      _con.food.price,
                      context,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    _con.food.discountPrice > 0
                        ? Helper.getPrice(_con.food.discountPrice, context,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(
                                    decoration: TextDecoration.lineThrough)))
                        : SizedBox(height: 0),
                  ],
                ),
              ),
            ],
          ),
          Html(
            data: _con.food.description ?? "",
          ),
          Divider(
            thickness: 3,
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            title: Text(
              S.of(context).select_extras_to_add_them_on_the_food,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          _con.food.extraGroups == null
              ? CircularLoadingWidget(height: 100)
              : ListView.separated(
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, extraGroupIndex) {
                    var extraGroup =
                        _con.food.extraGroups.elementAt(extraGroupIndex);
                    return Wrap(
                      children: <Widget>[
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.add_circle_outline,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            extraGroup.name,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          trailing: extraGroup.required == 1
                              ? Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 30),
                                )
                              : Text(''),
                        ),
                        ListView.separated(
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, extraIndex) {
                            return Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (foodExtras[extraGroup.id] ==
                                        extraIndex) {
                                      setState(() {
                                        foodExtras[extraGroup.id] = -1;
                                      });
                                    } else {
                                      setState(() {
                                        foodExtras[extraGroup.id] = extraIndex;
                                      });
                                    }
                                    _con.food.extras
                                            .where(
                                                (extra) =>
                                                    extra.extraGroupId ==
                                                    extraGroup.id)
                                            .elementAt(extraIndex)
                                            .checked =
                                        !_con.food.extras
                                            .where((extra) =>
                                                extra.extraGroupId ==
                                                extraGroup.id)
                                            .elementAt(extraIndex)
                                            .checked;
                                    if (extraGroup.required == 1) {
                                      if (_con.food.extras
                                          .where((extra) =>
                                              extra.extraGroupId ==
                                              extraGroup.id)
                                          .elementAt(extraIndex)
                                          .checked) {
                                        for (int i = 0;
                                            i <
                                                _con.food.extras
                                                    .where((extra) =>
                                                        extra.extraGroupId ==
                                                        extraGroup.id)
                                                    .length;
                                            i++) {
                                          if (i != extraIndex) {
                                            _con.food.extras
                                                .where((extra) =>
                                                    extra.extraGroupId ==
                                                    extraGroup.id)
                                                .toList()[i]
                                                .checked = false;
                                          }
                                        }
                                      }
                                      requierdMap[_con.food.extras
                                              .where((extra) =>
                                                  extra.extraGroupId ==
                                                  extraGroup.id)
                                              .elementAt(extraIndex)
                                              .extraGroupId
                                              .toString()][0] =
                                          _con.food.extras
                                              .where((extra) =>
                                                  extra.extraGroupId ==
                                                  extraGroup.id)
                                              .elementAt(extraIndex)
                                              .checked;
                                    }
                                    _con.calculateTotal();
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child:
                                        foodExtras[extraGroup.id] == extraIndex
                                            ? Icon(Icons.check,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)
                                            : Container(),
                                  ),
                                ),
                                Flexible(
                                  child: ExtraItemWidget(
                                      extra: _con.food.extras
                                          .where((extra) =>
                                              extra.extraGroupId ==
                                              extraGroup.id)
                                          .elementAt(extraIndex),
                                      onChanged: _con.calculateTotal,
                                      i: extraIndex,
                                      isReq: extraGroup.required,
                                      extras: _con.food.extras
                                          .where((extra) =>
                                              extra.extraGroupId ==
                                              extraGroup.id)
                                          .toList()),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 20);
                          },
                          itemCount: _con.food.extras
                              .where((extra) =>
                                  extra.extraGroupId == extraGroup.id)
                              .length,
                          primary: false,
                          shrinkWrap: true,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20);
                  },
                  itemCount: _con.food.extraGroups.length,
                  primary: false,
                  shrinkWrap: true,
                ),
          cartIsEmpty || (_con.loadCart)
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      onPressed: () {
                        if (currentUser.value.apiToken != null) {
                          Navigator.of(context).pushNamed('/Cart',
                              arguments: widget.routeArgument);
                        } else {
                          Navigator.of(context).pushNamed('/Login');
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).complete_the_purchase,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  addFoodToCard() {
    if (currentUser.value.apiToken == null) {
      Navigator.of(context).pushNamed("/Login");
    } else {
      if (_con.isSameRestaurants(_con.food)) {
        cartIsEmpty = false;
        _con.addToCart(_con.food, requierdMap, context);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AddToCartAlertDialogWidget(
                oldFood: _con.carts.elementAt(0)?.food,
                newFood: _con.food,
                onPressed: (food, {reset: true}) {
                  return _con.addToCart(_con.food, requierdMap, context,
                      reset: true);
                });
          },
        );
      }
    }
  }
}
