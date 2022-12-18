import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';

import '../helpers/helper.dart';
import '../repository/user_repository.dart' as userRepo;
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  UserController _con;

  _LoginWidgetState() : super(UserController()) {
    _con = controller;
  }

  GlobalKey<ScaffoldState> scaffoldKey;
  final fbLogin = new FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void initState() {
    super.initState();
    if (userRepo.currentUser.value.apiToken != null) {
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        key: _con.scaffoldKey,
        body: ListView(
          //padding: EdgeInsets.only(top: 30,right: 15,left: 15),
          // alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Stack(alignment: Alignment.topRight, children: [
              Image.asset(
                "assets/img/back.png",
                fit: BoxFit.fill,
                width: 140,
                height: 180,
              ),
              Center(
                child: Container(
                    //alignment: Alignment.topLeft,
                    //margin: EdgeInsets.only(top: 30,
                    //  bottom: MediaQuery.of(context).size.height*0.7),
                    width: 340,
                    height: 230,
                    child: Image.asset(
                      "assets/img/meat.png",
                      fit: BoxFit.fill,
                    )),
              ),
            ]),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.all(8),
                child: Text(
                  S.of(context).login,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Text(
                  S.of(context).login_by,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(right: 35, left: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        face();
                      },
                      child: Image.asset(
                        "assets/img/face.png",
                        width: 40,
                        height: 40,
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: () {
                        googleLogin();
                      },
                      child: Image.asset(
                        "assets/img/google.png",
                        width: 40,
                        height: 40,
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      Fluttertoast.showToast(msg: 'Soon ');
                    },
                    child: Image.asset(
                      "assets/img/twiter.png",
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Text(
                  S.of(context).register_or,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(125, 10, 10, 1),
                    )
                  ]),
              margin: EdgeInsets.only(left: 50, right: 50),
              child: Form(
                key: _con.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => _con.user.email = input,
                      validator: (input) => !input.contains('@')
                          ? S.of(context).should_be_a_valid_email
                          : null,
                      decoration: InputDecoration(
                        hintText: S.of(context).email,
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        contentPadding: EdgeInsets.all(12),
                        hintStyle:
                            TextStyle(color: Colors.grey[800].withOpacity(0.7)),
                        prefixIcon:
                            Icon(Icons.alternate_email, color: Colors.black54),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _con.user.password = input,
                      validator: (input) => input.length < 3
                          ? S.of(context).should_be_more_than_3_characters
                          : null,
                      obscureText: _con.hidePassword,
                      decoration: InputDecoration(
                        hintText: S.of(context).password,
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        contentPadding: EdgeInsets.all(12),
                        hintStyle:
                            TextStyle(color: Colors.grey[800].withOpacity(0.7)),
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Colors.black54),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _con.hidePassword = !_con.hidePassword;
                            });
                          },
                          color: Colors.black54,
                          icon: Icon(_con.hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/ForgetPassword');
              },
              textColor: Theme.of(context).colorScheme.secondary,
              child: Text(
                S.of(context).i_forgot_password,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 40,
              width: 70,
              margin: EdgeInsets.only(left: 80, right: 80),
              child: MaterialButton(
                shape: StadiumBorder(),
                child: Text(
                  S.of(context).login,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  _con.login(_con.user, context);
                },
              ),
            ),
            SizedBox(height: 10),

            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/SignUp');
              },
              textColor: Theme.of(context).colorScheme.secondary,
              child: Text(
                S.of(context).i_dont_have_an_account,
                style: TextStyle(fontFamily: "ElMessiri-Bold"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed('/Pages', arguments: 2);
              },
              shape: StadiumBorder(),
              textColor: Theme.of(context).hintColor,
              child: Text(S.of(context).skip),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            ),

//             Positioned(
//               top: 0,
//               child: Container(
//                 width: config.App(context).appWidth(100),
//                 height: config.App(context).appHeight(37),
//                 decoration: BoxDecoration(color: Theme.of(context).accentColor),
//               ),
//             ),
//             Positioned(
//               top: config.App(context).appHeight(37) - 120,
//               child: Container(
//                 width: config.App(context).appWidth(84),
//                 height: config.App(context).appHeight(37),
//                 child: Text(
            //                  S.of(context).lets_start_with_login,
//                   style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: Theme.of(context).primaryColor)),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: config.App(context).appHeight(37) - 50,
//               child: Container(
//                 decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
//                   BoxShadow(
//                     blurRadius: 50,
//                     color: Theme.of(context).hintColor.withOpacity(0.2),
//                   )
//                 ]),
//                 margin: EdgeInsets.symmetric(
//                   horizontal: 20,
//                 ),
//                 padding: EdgeInsets.only(top: 50, right: 27, left: 27, bottom: 20),
//                 width: config.App(context).appWidth(88),
// //              height: config.App(context).appHeight(55),
//                 child: Form(
//                   key: _con.loginFormKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       TextFormField(
//                         keyboardType: TextInputType.emailAddress,
//                         onSaved: (input) => _con.user.email = input,
//                         validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
//                         decoration: InputDecoration(
//                           labelText: S.of(context).email,
//                           labelStyle: TextStyle(color: Theme.of(context).accentColor),
//                           contentPadding: EdgeInsets.all(12),
//                           hintText: 'johndoe@gmail.com',
//                           hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
//                           prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
//                           border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                           focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
//                           enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       TextFormField(
//                         keyboardType: TextInputType.text,
//                         onSaved: (input) => _con.user.password = input,
//                         validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_characters : null,
//                         obscureText: _con.hidePassword,
//                         decoration: InputDecoration(
//                           labelText: S.of(context).password,
//                           labelStyle: TextStyle(color: Theme.of(context).accentColor),
//                           contentPadding: EdgeInsets.all(12),
//                           hintText: '••••••••••••',
//                           hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
//                           prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
//                           suffixIcon: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 _con.hidePassword = !_con.hidePassword;
//                               });
//                             },
//                             color: Theme.of(context).focusColor,
//                             icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
//                           ),
//                           border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                           focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
//                           enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       BlockButtonWidget(
//                         text: Text(
//                           S.of(context).login,
//                           style: TextStyle(color: Theme.of(context).primaryColor),
//                         ),
//                         color: Theme.of(context).accentColor,
//                         onPressed: () {
//                           _con.login();
//                         },
//                       ),
//                       SizedBox(height: 15),
//                       MaterialButton(
//                         onPressed: () {
//                           Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
//                         },
//                         shape: StadiumBorder(),
//                         textColor: Theme.of(context).hintColor,
//                         child: Text(S.of(context).skip),
//                         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
//                       ),
//                       SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 10,
//               child: Column(
//                 children: <Widget>[
//                   MaterialButton(
//                     onPressed: () {
//                       Navigator.of(context).pushReplacementNamed('/ForgetPassword');
//                     },
//                     textColor: Theme.of(context).hintColor,
//                     child: Text(S.of(context).i_forgot_password),
//                   ),
//                   MaterialButton(
//                     onPressed: () {
//                       Navigator.of(context).pushReplacementNamed('/SignUp');
//                     },
//                     textColor: Theme.of(context).hintColor,
//                     child: Text(S.of(context).i_dont_have_an_account),
//                   ),
//                 ],
//               ),
//             )
          ],
        ),
      ),
    );
  }

  googleLogin() async {
    try {
      await _googleSignIn.signIn();
      // Navigator.of(scaffoldKey.currentContext)
      //     .pushReplacementNamed('/Pages', arguments: 2);

      setState(() {
        _con.user.name = _googleSignIn.currentUser.displayName;
        _con.user.email = _googleSignIn.currentUser.email;
        _con.user.password = '123456';
        // _con.user.flag = 'google';
      });

      _save(_googleSignIn.currentUser.email);
      print("Google Uset ${_con.user.toMap()}");
      _con.loginWithFacebook('google', context);
    } catch (err) {
      print("error: ${err.toString()}");
    }
  }

  _save(String token) async {
    final pref = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    pref.setString(key, value);
  }

  Future<void> FacebookUser(String uId, String uToken) async {
    String URL =
        'https://graph.facebook.com/v9.0/$uId/?fields=first_name,last_name,email&access_token=$uToken';
    Map<String, String> header = {"Content-Type": "application/json"};
    http.Response response = await http.get(Uri.parse(URL));

    String first_name = jsonDecode(response.body)['first_name'];
    String last_name = jsonDecode(response.body)['last_name'];
    String uEmail = jsonDecode(response.body)['email'];
    final profile = jsonDecode(response.body);
    print("USER PROFILE ${profile['phone']}");

    setState(() {
      _con.user.name = first_name + ' ' + last_name;
      _con.user.email = uEmail == null ? uId + '@turkey.com' : uEmail;
      _con.user.password = '123456';
      // _con.user.flag = 'facebook';
    });
  }

  face() async {
    final FacebookLoginResult result = await fbLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
         Logged in!
         Token: ${result.accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

        await FacebookUser(accessToken.userId, result.accessToken.token);

        _con.loginWithFacebook('facebook', context);
        // Navigator.of(context)
        //     .pushReplacementNamed('/Pages', arguments: 2);

        final token = result.accessToken.token;
        _save(token);
        print(token);
        print("success ${_con.user.toMap()}");

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("cancle");

        break;
      case FacebookLoginStatus.error:
        print("error");

        break;
    }
  }
}
