import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  OverlayEntry loader;
  BuildContext context;
  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    // _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  Future<void> savePoints(String points) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('points', points);
  }

  void regWithFacebook(String flag, BuildContext context) {
    Overlay.of(context).insert(loader);
    repository.register(user).then((value) {
      if (value != null && value.apiToken != null) {
        print("VALUE = $value >>>>>> API TOKEN = ${value.apiToken}");
        Navigator.of(scaffoldKey.currentContext)
            .pushReplacementNamed('/Pages', arguments: 2);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).wrong_email_or_password),
        ));
      }
    }).catchError((e) {
      print("REGISTER WITH FACEBOOK ERROR WILL TRY LOGIN :${e.toString()}");
      loader?.remove();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).this_email_account_exists),
      ));
      // loginWithFacebook(flag);
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  void loginWithFacebook(String flag, BuildContext context) {
    Overlay.of(context).insert(loader);
    repository.login(user).then((value) async {
      if (value != null && value.apiToken != null) {
        await savePoints(value.points);
        print(value.points);
        Navigator.of(scaffoldKey.currentContext)
            .pushReplacementNamed('/Pages', arguments: 2);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).wrong_email_or_password),
        ));
      }
    }).catchError((e) {
      loader.remove();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).this_account_not_exist),
      ));
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  void login(User usrr, BuildContext context) async {
    // FocusScope.of(context).unfocus();
    // if (loginFormKey.currentState.validate())
    //   loginFormKey.currentState.save();
    //   Overlay.of(context).insert(loader);
    repository.login(usrr).then((value) async {
      if (value != null && value.apiToken != null) {
        await savePoints(value.points);
        print(value.points);
        repository.update(usrr);
        Navigator.of(scaffoldKey.currentContext)
            .pushReplacementNamed('/Pages', arguments: 2);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).wrong_email_or_password),
        ));
      }
    }).catchError((e) {
      print(e.toString());
      loader.remove();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).this_account_not_exist),
      ));
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  String phoneNumber;
  TextEditingController _code = TextEditingController();
  TextEditingController _name = TextEditingController();

  loginWithPhone() async {
    loginFormKey.currentState.save();
    final _formKey = GlobalKey<FormState>();

    showDialog(
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text(
              S.of(context).full_name,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary, fontSize: 30),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    validator: (val) {
                      if (val.isEmpty)
                        return '.';
                      else
                        return null;
                    },
                    controller: _name,
                    decoration: InputDecoration(
                      hintText: S.of(context).full_name,
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      contentPadding: EdgeInsets.all(12),
                      hintStyle:
                          TextStyle(color: Colors.black54.withOpacity(0.7)),
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
                )
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text(
                  S.of(context).confirmation,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    user.name = _name.text;

                    await verificationPhone('${user.phone}', context);
                  }
                },
              )
            ],
          );
        });
  }

  Future verificationPhone(String phone, BuildContext context) async {
    Overlay.of(context).insert(loader);
    auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
    print("start");
    _auth
        .verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 60),
          verificationCompleted: (auth.AuthCredential credential) async {
            Navigator.pop(context);
            Overlay.of(context).insert(loader);
            await _auth.signInWithCredential(credential).then((result) {
              if (result.user != null) {
                print("USER ${result.user.phoneNumber}");
                user.email = result.user.phoneNumber + "@turkey.com";
                user.password = result.user.phoneNumber;

                int min = 100000; //min and max values act as your 6 digit range
                int max = 999999;
                var randomizer = new Random();
                var rNum = min + randomizer.nextInt(max - min);

                user.phone = result.user.phoneNumber;
                register(context);
              }
            }).catchError((e) {
              loader?.remove();
              Fluttertoast.showToast(msg: S.of(context).the_code_is_wrong);
            });
          },
          verificationFailed: (exception) {
            loader?.remove();
            Fluttertoast.showToast(msg: S.of(context).try_again);
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            Navigator.pop(context);
            loader?.remove();
            final _formKey = GlobalKey<FormState>();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    title: Text(
                      S.of(context).confirmation_code,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 30),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            validator: (val) {
                              if (val.isEmpty)
                                return '.';
                              else
                                return null;
                            },
                            keyboardType: TextInputType.phone,
                            controller: _code,
                            decoration: InputDecoration(
                              hintText: S.of(context).confirmation_code,
                              labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              contentPadding: EdgeInsets.all(12),
                              hintStyle: TextStyle(
                                  color: Colors.black54.withOpacity(0.7)),
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
                        )
                      ],
                    ),
                    actions: <Widget>[
                      MaterialButton(
                        child: Text(
                          S.of(context).confirmation,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () async {
                          // if (_formKey.currentState.validate()) {
                          //   Navigator.pop(context);
                          //   Overlay.of(context).insert(loader);
                          //   final code = _code.text.trim();
                          //   _code.clear();
                          //   auth.AuthCredential credential =
                          //       auth.PhoneAuthProvider.getCredential(
                          //           verificationId: verificationId,
                          //           smsCode: code);
                          //   await _auth
                          //       .signInWithCredential(credential)
                          //       .then((result) {
                          //     if (result.user != null) {
                          //       print("USER ${result.user.phoneNumber}");
                          //       user.email =
                          //           result.user.phoneNumber + "@turkey.com";
                          //       user.phone = result.user.phoneNumber;
                          //       user.password = result.user.phoneNumber;

                          //       register(context);
                          //     }
                          //   }).catchError((e) {
                          //     loader?.remove();
                          //     Fluttertoast.showToast(
                          //         msg: S.of(context).the_code_is_wrong);
                          //   });
                          // }
                        },
                      )
                    ],
                  );
                });
          },
          codeAutoRetrievalTimeout: (verificationId) {},
        )
        .then((value) => null);
  }

  void register(BuildContext context) async {
    // FocusScope.of(context).unfocus();
    // if (loginFormKey.currentState.validate())
    //   loginFormKey.currentState.save();
    // user.email="client@demo.com";
    // user.password="123456";
    repository.register(user).then((value) {
      if (value != null && value.apiToken != null) {
        Navigator.of(scaffoldKey.currentContext)
            .pushReplacementNamed('/Pages', arguments: 2);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).wrong_email_or_password),
        ));
      }
    }).catchError((e) {
      login(user, context);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(S.of(context).this_email_account_exists),
      // ));
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  void resetPassword(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(S.of(context).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext)
                    .pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader.remove();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).error_verify_email_settings),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
}
