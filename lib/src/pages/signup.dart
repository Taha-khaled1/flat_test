import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:turkey_app/src/pages/country.dart';
import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  GlobalKey<ScaffoldState> scaffoldKey;
  final fbLogin = new FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  UserController _con;

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      key: _con.scaffoldKey,
      body: ListView(shrinkWrap: true, children: [
        Stack(alignment: Alignment.topRight, children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              "assets/img/backleft.png",
              fit: BoxFit.fill,
              width: 140,
              height: 180,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                //alignment: Alignment.topLeft,
                //margin: EdgeInsets.only(top: 30,
                //  bottom: MediaQuery.of(context).size.height*0.7),
                width: 340,
                height: 230,
                child: Image.asset(
                  "assets/img/meat2.png",
                  fit: BoxFit.fill,
                )),
          ),
        ]),
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.all(8),
            child: Text(
              S.of(context).new_register,
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
              S.of(context).register_by,
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
                    googleSignUp();
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
                  fontFamily: "ElMessiri-Bold"),
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
                  keyboardType: TextInputType.text,
                  onSaved: (input) => _con.user.name = input,
                  validator: (input) => input.length < 3
                      ? S.of(context).should_be_more_than_3_letters
                      : null,
                  decoration: InputDecoration(
                    hintText: S.of(context).full_name,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                    contentPadding: EdgeInsets.all(12),
                    hintStyle:
                        TextStyle(color: Colors.black54.withOpacity(0.7)),
                    prefixIcon:
                        Icon(Icons.person_outline, color: Colors.black54),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.2))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.5))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.2))),
                  ),
                ),
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
                        TextStyle(color: Colors.black54.withOpacity(0.7)),
                    prefixIcon:
                        Icon(Icons.alternate_email, color: Colors.black54),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.2))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.5))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.2))),
                  ),
                ),
                TextFormField(
                  obscureText: _con.hidePassword,
                  onSaved: (input) => _con.user.password = input,
                  validator: (input) => input.length < 6
                      ? S.of(context).should_be_more_than_6_letters
                      : null,
                  decoration: InputDecoration(
                    hintText: S.of(context).password,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                    contentPadding: EdgeInsets.all(12),
                    hintStyle:
                        TextStyle(color: Colors.black54.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.black54),
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
                            color:
                                Theme.of(context).focusColor.withOpacity(0.2))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.5))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.2))),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 40,
          width: 70,
          margin: EdgeInsets.only(left: 80, right: 80),
          child: MaterialButton(
            shape: StadiumBorder(),
            child: Text(
              S.of(context).register,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: "ElMessiri-Bold"),
            ),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              // _con.register();
            },
          ),
        ),
        SizedBox(height: 15),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/Login');
          },
          textColor: Theme.of(context).colorScheme.secondary,
          child: Text(
            S.of(context).i_have_account_back_to_login,
            style: TextStyle(fontFamily: "ElMessiri-Bold"),
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Country()),
                (route) => false);
          },
          shape: StadiumBorder(),
          textColor: Theme.of(context).hintColor,
          child: Text(S.of(context).skip),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        ),
      ]),
    );
  }

  googleSignUp() async {
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
      _con.regWithFacebook('google', context);
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

        _con.regWithFacebook('facebook', context);
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
