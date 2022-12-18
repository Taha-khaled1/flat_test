import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkey_app/src/pages/country.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';

class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends StateMVC<PhoneLogin> {
  GlobalKey<ScaffoldState> scaffoldKey;
  final fbLogin = new FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  String _phoneNumber;
  UserController _con;
  final TextEditingController controller1 = TextEditingController();
  String initialCountry = 'SA';
  PhoneNumber number = PhoneNumber(isoCode: 'SA');

  _PhoneLoginState() : super(UserController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      key: _con.scaffoldKey,
      body: SafeArea(
        child: ListView(shrinkWrap: true, children: [
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
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
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
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
                      String phone = number.phoneNumber;
                      if (number.phoneNumber[number.dialCode.length] == '0') {
                        phone = number.phoneNumber.replaceFirst('0', '');
                      }
                      _con.user.phone = phone;
                      print('On Saved: $phone');
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: true,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: controller1,
                    formatInput: false,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(),
                  ),

                  // TextFormField(
                  //   textDirection: TextDirection.ltr,
                  //   keyboardType: TextInputType.phone,
                  //   onSaved: (input) => _con.user.phone = input,
                  //   validator: (input) {
                  //     String phone = input;
                  //     RegExp regExp = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
                  //     print("REG:${regExp.hasMatch(input)}");
                  //     if (regExp.hasMatch(_con.user.phone)) return null;
                  //     return S.of(context).not_a_valid_phone;
                  //   },
                  //   decoration: InputDecoration(
                  //     hintText: S.of(context).phone,
                  //     labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  //     contentPadding: EdgeInsets.all(12),
                  //     hintStyle:
                  //         TextStyle(color: Colors.black54.withOpacity(0.7)),
                  //     prefixIcon: Icon(Icons.call, color: Colors.black54),
                  //     border: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //             color:
                  //                 Theme.of(context).focusColor.withOpacity(0.2))),
                  //     focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //             color:
                  //                 Theme.of(context).focusColor.withOpacity(0.5))),
                  //     enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //             color:
                  //                 Theme.of(context).focusColor.withOpacity(0.2))),
                  //   ),
                  // ),
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
                ),
              ),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                _con.loginWithPhone();
              },
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
      ),
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
