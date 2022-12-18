import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkey_app/src/helpers/helper.dart';
import 'package:turkey_app/src/models/food_by_category.dart';

import '../../generated/l10n.dart';
import '../controllers/category_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/FilterWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/route_argument.dart';
import 'package:http/http.dart' as http;

class CategoryWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CategoryWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends StateMVC<CategoryWidget> {
  // TODO add layout in configuration file
  String layout = 'grid';

  CategoryController _con;

  _CategoryWidgetState() : super(CategoryController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForFoodsByCategory(context, id: widget.routeArgument.id);
    _con.listenForCategory(context, id: widget.routeArgument.id);
    _con.listenForCart();
    getCityId();
    super.initState();
  }

  getCityId() async {
    final prefs = await SharedPreferences.getInstance();
    int cityId = prefs.getInt('cityId');
    getFoodiesInMyCityFromCategory(cityId);
  }

  bool isLoading = true;
  FoodsByCategory products;

  getFoodiesInMyCityFromCategory(int cityId) async {
    Uri uri = Helper.getUri(
        'api/foods/categories/$cityId/${widget.routeArgument.id}');
    http.Response response = await http.get(uri);
    FoodsByCategory foods = FoodsByCategory.fromJson(jsonDecode(response.body));
    setState(() {
      products = foods;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      endDrawer: FilterWidget(onFilter: (filter) {
        Navigator.of(context).pushReplacementNamed('/Category',
            arguments: RouteArgument(id: widget.routeArgument.id));
      }),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _con.scaffoldKey?.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).category,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          _con.loadCart
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.5, vertical: 15),
                  child: SizedBox(
                    width: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : ShoppingCartButtonWidget(
                  iconColor: Theme.of(context).hintColor,
                  labelColor: Theme.of(context).colorScheme.secondary),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshCategory,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(onClickFilter: (filter) {
                  _con.scaffoldKey?.currentState?.openEndDrawer();
                }),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.category,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    _con.category?.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  // trailing: Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: <Widget>[
                  //     // IconButton(
                  //     //   onPressed: () {
                  //     //     setState(() {
                  //     //       this.layout = 'list';
                  //     //     });
                  //     //   },
                  //     //   icon: Icon(
                  //     //     Icons.format_list_bulleted,
                  //     //     color: this.layout == 'list'
                  //     //         ? Theme.of(context).accentColor
                  //     //         : Theme.of(context).focusColor,
                  //     //   ),
                  //     // ),
                  //     // IconButton(
                  //     //   onPressed: () {
                  //     //     setState(() {
                  //     //       this.layout = 'grid';
                  //     //     });
                  //     //   },
                  //     //   icon: Icon(
                  //     //     Icons.apps,
                  //     //     color: this.layout == 'grid'
                  //     //         ? Theme.of(context).accentColor
                  //     //         : Theme.of(context).focusColor,
                  //     //   ),
                  //     // )
                  //   ],
                  // ),
                ),
              ),
              // _con.foods.isEmpty
              //     ? CircularLoadingWidget(height: 500)
              //     : Offstage(
              //         offstage: this.layout != 'list',
              //         child: ListView.separated(
              //           scrollDirection: Axis.vertical,
              //           shrinkWrap: true,
              //           primary: false,
              //           itemCount: _con.foods.length,
              //           separatorBuilder: (context, index) {
              //             return SizedBox(height: 10);
              //           },
              //           itemBuilder: (context, index) {
              //             return FoodListItemWidget(
              //               heroTag: 'favorites_list',
              //               food: _con.foods.elementAt(index),
              //             );
              //           },
              //         ),
              //       ),
              products == null
                  ? CircularLoadingWidget(height: 500)
                  : GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: products.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.08),
                                    onTap: () {
                                      Navigator.of(context).pushNamed('/Food',
                                          arguments: new RouteArgument(
                                              heroTag: 'favorites_list',
                                              id: products.data[index].id
                                                  .toString()));
                                    },
                                    child: Container(
                                      // height: 110,
                                      // width: MediaQuery.of(context).size.width/2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        image: DecorationImage(
                                            image: products
                                                    .data[index].media.isEmpty
                                                ? AssetImage(
                                                    'assets/img/loading.gif')
                                                : NetworkImage(products
                                                    .data[index]
                                                    .media[0]
                                                    .thumb),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  products.data[index].name,
                                  style: Theme.of(context).textTheme.bodyText1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  products.data[index].restaurant.name,
                                  style: Theme.of(context).textTheme.caption,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              // products == null
              //     ? CircularLoadingWidget(height: 500)
              //     : GridView.count(
              //         scrollDirection: Axis.vertical,
              //         shrinkWrap: true,
              //         primary: false,
              //         crossAxisSpacing: 7,
              //         mainAxisSpacing: 9,
              //         padding: EdgeInsets.symmetric(horizontal: 20),
              //         // Create a grid with 2 columns. If you change the scrollDirection to
              //         // horizontal, this produces 2 rows.
              //         crossAxisCount: 2,
              //         // Generate 100 widgets that display their index in the List.
              //         children: List.generate(products.data.length, (index) {
              //           return Padding(
              //             padding: const EdgeInsets.all(5.0),
              //             child: InkWell(
              //               highlightColor: Colors.transparent,
              //               splashColor:
              //                   Theme.of(context).accentColor.withOpacity(0.08),
              //               onTap: () {
              //                 Navigator.of(context).pushNamed('/Food',
              //                     arguments: new RouteArgument(
              //                         heroTag: 'favorites_list',
              //                         id: products.data[index].id.toString()));
              //               },
              //               child: Container(
              //                 height: 300,
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: <Widget>[
              //                     Expanded(
              //                       child: Container(
              //                         // height: 110,
              //                         // width: MediaQuery.of(context).size.width/2,
              //                         decoration: BoxDecoration(
              //                             borderRadius: BorderRadius.all(
              //                                 Radius.circular(20)),
              //                             image: DecorationImage(
              //                                 image: NetworkImage(products
              //                                     .data[index].media[0].url),
              //                                 fit: BoxFit.cover)),
              //                       ),
              //                     ),
              //                     SizedBox(height: 5),
              //                     Text(
              //                       products.data[index].name,
              //                       style:
              //                           Theme.of(context).textTheme.bodyText1,
              //                       overflow: TextOverflow.ellipsis,
              //                     ),
              //                     SizedBox(height: 2),
              //                     Text(
              //                       products.data[index].restaurant.name,
              //                       style: Theme.of(context).textTheme.caption,
              //                       overflow: TextOverflow.ellipsis,
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           );
              //         }),
              //       )
            ],
          ),
        ),
      ),
    );
  }
}
