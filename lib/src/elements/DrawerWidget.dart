// ignore_for_file: missing_required_param

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:turkey_app/src/models/points.dart';
import 'package:turkey_app/src/pages/web_view.dart';
import 'package:turkey_app/src/repository/cart_repository.dart';
import 'package:turkey_app/src/repository/menu_item_repository.dart';
import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import 'package:turkey_app/src/helpers/helper.dart';
import 'dart:convert';
import 'CircularLoadingWidget.dart';

class DrawerWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  String val = null;

  read() async {
    final pref = await SharedPreferences.getInstance();
    final key = 'token';
    final value = pref.get(key) ?? 0;
    if (value != 0) {
      val = value;
    }
  }

  BuildContext _contextt;
  _DrawerWidgetState() : super(ProfileController()) {}

  @override
  void initState() {
    // TODO: implement initState
    gPoints();
    getMenuItems();
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
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.apiToken != null
                  ? Navigator.of(context).pushNamed('/Profile')
                  : Navigator.of(context).pushNamed('/Login');
            },
            child: currentUser.value.apiToken != null
                ? UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    accountName: Text(
                      currentUser.value.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      backgroundImage:
                          NetworkImage(currentUser.value.image.thumb),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 32,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(1),
                        ),
                        SizedBox(width: 30),
                        val != null
                            ? Text(
                                val,
                                style: Theme.of(context).textTheme.headline6,
                              )
                            : Text(
                                S.of(context).guest,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                      ],
                    ),
                  ),
          ),

          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 2);
            },
            leading: Icon(
              Icons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).home,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 4);
            },
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).notifications,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 0);
            },
            leading: Icon(
              Icons.local_mall,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).my_orders,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Favorites');
            },
            leading: Icon(
              Icons.favorite,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).favorite_foods,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          currentUser.value == null
              ? Container()
              : ListTile(
                  onTap: () {},
                  dense: true,
                  leading: Icon(
                    Icons.point_of_sale,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).points,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  trailing: pointLoading
                      ? Text(
                          points.data.points.toString(),
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                      : Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ))),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 4);
          //   },
          //   leading: Icon(
          //     Icons.chat,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).messages,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          ListTile(
            dense: true,
            title: Text(
              S.of(context).application_preferences,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                showDialog(
                  context: context,
                  builder: (context) => CircularLoadingWidget(
                    height: MediaQuery.of(context).size.height,
                  ),
                );

                share();
              } else {
                Fluttertoast.showToast(
                    msg: S
                        .of(context)
                        .you_must_signin_to_access_to_this_section);
              }
            },
            leading: Icon(
              Icons.share,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).share,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          menuItem == null
              ? Container()
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      menuItem.data.isNotEmpty ? menuItem.data.length : 0,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewExample(
                                      menuItem.data[index].description,
                                      menuItem.data[index].name)));
                        },
                        title: Text(
                          menuItem.data[index].name,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        leading: menuItem.data[index].hasMedia
                            ? Image.network(
                                menuItem.data[index].media[0].icon,
                                height: 30,
                                width: 30,
                              )
                            : Icon(Icons.error_outline));
                  }),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(
              Icons.help,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).help__support,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                Navigator.of(context).pushNamed('/Settings');
              } else {
                Navigator.of(context).pushReplacementNamed('/Login');
              }
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).settings,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: Icon(
              Icons.translate,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).languages,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (Theme.of(context).brightness == Brightness.dark) {
                setBrightness(Brightness.light);
                setting.value.brightness.value = Brightness.light;
              } else {
                setting.value.brightness.value = Brightness.dark;
                setBrightness(Brightness.dark);
              }
              setting.notifyListeners();
            },
            leading: Icon(
              Icons.brightness_6,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              Theme.of(context).brightness == Brightness.dark
                  ? S.of(context).light_mode
                  : S.of(context).dark_mode,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                logout().then((value) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Pages', (Route<dynamic> route) => false,
                      arguments: 2);
                });
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              currentUser.value.apiToken != null
                  ? S.of(context).log_out
                  : S.of(context).login,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          // currentUser.value.apiToken == null
          //     ? ListTile(
          //         onTap: () {
          //           Navigator.of(context).pushNamed('/SignUp');
          //         },
          //         leading: Icon(
          //           Icons.person_add,
          //           color: Theme.of(context).focusColor.withOpacity(1),
          //         ),
          //         title: Text(
          //           S.of(context).register,
          //           style: Theme.of(context).textTheme.subtitle1,
          //         ),
          //       )
          //     : SizedBox(height: 0),
          setting.value.enableVersion
              ? ListTile(
                  dense: true,
                  title: Text(
                    S.of(context).version + " " + setting.value.appVersion,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(
                    Icons.remove,
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Future<void> share() async {
    Uri url = Helper.getUri('api/share/${currentUser.value.apiToken}');
    print('shareUri ${url}');
    http.Response response = await http.get(url);
    String linkShare = jsonDecode(response.body)['data'];
    Share.share('${linkShare}');
    Navigator.pop(context);
  }
}
