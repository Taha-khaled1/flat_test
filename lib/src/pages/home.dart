import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkey_app/src/elements/CircularLoadingWidget.dart';
import 'package:turkey_app/src/helpers/helper.dart';
import 'package:turkey_app/src/elements/grid_all_food_in_category.dart';
import 'package:turkey_app/src/models/food_by_category.dart';
import 'package:turkey_app/src/models/route_argument.dart';
import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/HomeSliderWidget.dart';
import 'package:turkey_app/src/models/home_foods.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;

Map<String, bool> category = {};

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;

  Map<String, FoodsByCategory> foodsMap = {};

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  int categoryIsEmpty = 0;
  int cityID;
  HomeFoods foodies;
  bool isLoading = true;

  @override
  void initState() {
    getCityId();
    super.initState();
  }

  getCityId() async {
    final prefs = await SharedPreferences.getInstance();
    int cityId = prefs.getInt('cityId');
    setState(() {
      cityID = cityId;
      getCategories(cityID);
    });
  }

  getCategories(int cityId) async {
    Uri url = Helper.getUri('api/foods/categoriesall/$cityId');
    http.Response response = await http.get(url);
    HomeFoods foods = HomeFoods.fromJson(jsonDecode(response.body));
    print(" FOODS IN HOME :${foods.data.length}");
    setState(() {
      foodies = foods;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: ValueListenableBuilder(
            valueListenable: settingsRepo.setting,
            builder: (context, value, child) {
              return Text(
                value.appName ?? S.of(context).home,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .merge(TextStyle(letterSpacing: 1.3)),
              );
            },
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).colorScheme.secondary),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshHome,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  HomeSliderWidget(slides: _con.slides),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SearchBarWidget(
                      onClickFilter: (event) {
                        widget.parentScaffoldKey.currentState.openEndDrawer();
                      },
                    ),
                  ),
                  isLoading
                      ? CircularLoadingWidget(height: 200)
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: foodies.data.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Container(
                                child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: ListTile(
                                          dense: true,
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 0),
                                          title: Text(
                                            foodies.data[index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/Category',
                                            arguments: RouteArgument(
                                                id: foodies.data[index].id
                                                    .toString()));
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3.0),
                                            child: Text(
                                              S.of(context).see_all,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey[800]),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3.0),
                                            child: Icon(Icons.chevron_right),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                GridAllFoodInCategory(
                                  foodies: foodies.data[index].foods,
                                ),
                              ],
                            ));
                          }),
                  SizedBox(
                    height: 50,
                  ),
                ]),
          ),
        ));
  }
}
