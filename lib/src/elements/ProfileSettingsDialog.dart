import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../generated/l10n.dart';

class ProfileSettingsDialog extends StatefulWidget {
  final user;
  final VoidCallback onChanged;

  ProfileSettingsDialog({Key key, this.user, this.onChanged}) : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';

  String phone;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      S.of(context).profile_settings,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: S.of(context).john_doe,
                              labelText: S.of(context).full_name),
                          initialValue: widget.user.name,
                          validator: (input) => input.trim().length < 3
                              ? S.of(context).not_a_valid_full_name
                              : null,
                          onSaved: (input) => widget.user.name = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: S.of(context).your_address,
                              labelText: S.of(context).address),
                          initialValue: widget.user.address,
                          validator: (input) => input.trim().length < 3
                              ? S.of(context).not_a_valid_address
                              : null,
                          onSaved: (input) => widget.user.address = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: S.of(context).your_biography,
                              labelText: S.of(context).about),
                          initialValue: widget.user.bio,
                          validator: (input) => input.trim().length < 3
                              ? S.of(context).not_a_valid_biography
                              : null,
                          onSaved: (input) => widget.user.bio = input,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(S.of(context).cancel),
                      ),
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          S.of(context).save,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        S.of(context).edit,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  final _phoneFormKey = GlobalKey<FormState>();
  String phoneNumber;
  TextEditingController _code = TextEditingController();

  Future verificationPhone(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    print("start");
    _auth
        .verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential credential) async {
            Fluttertoast.showToast(msg: S.of(context).confirmation);
            await _auth.signInWithCredential(credential).then((result) {
              if (result.user != null) {
                Fluttertoast.showToast(msg: S.of(context).save);
                setState(() {
                  widget.user.phone = phone;
                });
                widget.onChanged();
              }
            }).catchError((e) {
              Fluttertoast.showToast(msg: S.of(context).try_again);
            });
            await _auth.signInWithCredential(credential);
            Fluttertoast.showToast(msg: "verification completed automatically");
            //this callback when verification completed automatically
          },
          verificationFailed: (exception) {
            Fluttertoast.showToast(msg: S.of(context).try_again);
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
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
                        TextField(
                          keyboardType: TextInputType.phone,
                          controller: _code,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
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
                          // Navigator.pop(context);
                          // Fluttertoast.showToast(msg: 'Loading ...');
                          // final code = _code.text.trim();
                          // // AuthCredential credential =
                          //     // PhoneAuthProvider.getCredential(
                          //     //     verificationId: verificationId,
                          //     //     smsCode: code);
                          // await _auth
                          //     .signInWithCredential(credential)
                          //     .then((result) {
                          //   if (result.user != null) {
                          //     print("USER ${result.user.phoneNumber}");
                          //     setState(() {
                          //       widget.user.phone=phone;

                          //     });
                          //     widget.onChanged();
                          //   }
                          // }).catchError((e) {
                          //   Fluttertoast.showToast(
                          //       msg: S.of(context).the_code_is_wrong);
                          // });
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

  void _submit() async {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();
      // await verificationPhone('${phone}', context);
      widget.onChanged();
      Navigator.pop(context);
    }
  }
}
