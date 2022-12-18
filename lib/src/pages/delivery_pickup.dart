// ignore_for_file: unused_field, unused_local_variable, unused_element

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:turkey_app/src/models/my_fatoorah.dart';
import 'package:turkey_app/src/repository/settings_repository.dart';
import '../../generated/l10n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/NotDeliverableAddressesItemWidget.dart';
import '../elements/PickUpMethodItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import 'package:http/http.dart' as http;

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

// Base Url
final String baseUrl = "https://api.myfatoorah.com";
// final String baseUrl = "https://apitest.myfatoorah.com";

// Token for regular payment
String regularPaymentToken;
bool isPaypal = true;
// Token for direct payment and recurring
// final String directPaymentToken =
//     "fVysyHHk25iQP4clu6_wb9qjV3kEq_DTc1LBVvIwL9kXo9ncZhB8iuAMqUHsw-vRyxr3_jcq5-bFy8IN-C1YlEVCe5TR2iCju75AeO-aSm1ymhs3NQPSQuh6gweBUlm0nhiACCBZT09XIXi1rX30No0T4eHWPMLo8gDfCwhwkbLlqxBHtS26Yb-9sx2WxHH-2imFsVHKXO0axxCNjTbo4xAHNyScC9GyroSnoz9Jm9iueC16ecWPjs4XrEoVROfk335mS33PJh7ZteJv9OXYvHnsGDL58NXM8lT7fqyGpQ8KKnfDIGx-R_t9Q9285_A4yL0J9lWKj_7x3NAhXvBvmrOclWvKaiI0_scPtISDuZLjLGls7x9WWtnpyQPNJSoN7lmQuouqa2uCrZRlveChQYTJmOr0OP4JNd58dtS8ar_8rSqEPChQtukEZGO3urUfMVughCd9kcwx5CtUg2EpeP878SWIUdXPEYDL1eaRDw-xF5yPUz-G0IaLH5oVCTpfC0HKxW-nGhp3XudBf3Tc7FFq4gOeiHDDfS_I8q2vUEqHI1NviZY_ts7M97tN2rdt1yhxwMSQiXRmSQterwZWiICuQ64PQjj3z40uQF-VHZC38QG0BVtl-bkn0P3IjPTsTsl7WBaaOSilp4Qhe12T0SRnv8abXcRwW3_HyVnuxQly_OsZzZry4ElxuXCSfFP2b4D2-Q";
//
// final String regularPaymentToken =
//     'bearer rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL';

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;

  String phoneNumber;

  String error;
  bool isDelivery = false;

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  GlobalKey<FormState> _deliveryAddressFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    if (regularPaymentToken == null) {
      getSettings();
    }
    //MFSDK.init(baseUrl, regularPaymentToken);
    super.initState();
  }

  String _response = '';
  String _loading = "Loading...";

  AddFatoorahOrder(String invoceId) async {
    String url =
        "http://turkey.freelance-jo.cloud/system/api/foods/payment/$invoceId";
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      _con.goCheckout(context);
    }
  }

  void executeRegularPayment(String price) {
    // The value "1" is the paymentMethodId of KNET payment method.
    // You should call the "initiatePayment" API to can get this id and the ids of all other payment methods
    String paymentMethod = "2";

    var request = new MFExecutePaymentRequest(
      int.parse(paymentMethod),
      double.parse(price),
    );

    MFSDK.executePayment(context, request, MFAPILanguage.AR,
        (String invoiceId, MFResult<MFPaymentStatusResponse> result) {
      if (result.isSuccess()) {
        setState(() {
          print("My Fatoorah TRUE $invoiceId");
          var res = result.response.toJson();
          MyFatoorah myFatoorah = MyFatoorah.fromJson(result.response.toJson());
          print("MY FATOORAH OBJECT FROM JSON :$res");
          _response = result.response.toJson().toString();
          // print(jsonDecode(_response));

          //delete from my cart and send invoiceId to api
        });
        if (result.response.invoiceTransactions[0].transactionStatus ==
            'Succss')
          AddFatoorahOrder(invoiceId);
        else
          Fluttertoast.showToast(
              msg: 'Please check your balance in credit card');
      } else {
        setState(() {
          print("My Fatoorah FALSE $invoiceId");
          print(result.error.toJson());
          _response = result.error.message;
        });
      }
    });

    setState(() {
      _response = _loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_con.list == null) {
      _con.list = new PaymentMethodList(context);
//      widget.pickup = widget.list.pickupList.elementAt(0);
//      widget.delivery = widget.list.pickupList.elementAt(1);
    }
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).delivery_or_pickup,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).colorScheme.secondary),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // CartBottomDetailsWidget(con: _con),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20, right: 10),
            //   child: ListTile(
            //     contentPadding: EdgeInsets.symmetric(vertical: 0),
            //     leading: Icon(
            //       Icons.domain,
            //       color: Theme.of(context).hintColor,
            //     ),
            //     title: Text(
            //       S.of(context).pickup,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: Theme.of(context).textTheme.headline4,
            //     ),
            //     subtitle: Text(
            //       S.of(context).pickup_your_food_from_the_restaurant,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: Theme.of(context).textTheme.caption,
            //     ),
            //   ),
            // ),
            PickUpMethodItem(
                paymentMethod: _con.getPickUpMethod(),
                onPressed: (paymentMethod) {
                  _con.togglePickUp(isDelivery);
                }),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20, right: 10),
            //   child: ListTile(
            //     contentPadding: EdgeInsets.symmetric(vertical: 0),
            //     leading: Icon(
            //       Icons.payment,
            //       color: Theme.of(context).hintColor,
            //     ),
            //     title: Text(
            //       'الدفع الالكتروني',
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: Theme.of(context).textTheme.headline4,
            //     ),
            //     subtitle: Text(
            //       "",
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: Theme.of(context).textTheme.caption,
            //     ),
            //   ),
            // ),
            isPaypal
                ? PickUpMethodItem(
                    paymentMethod: _con.getMyFatorah(),
                    onPressed: (paymentMethod) {
                      _con.payByMyFatorah();
                    })
                : Container(),
//            _con.carts.isNotEmpty? _con.carts[0].food.restaurant.availableForDelivery?PickUpMethodItem(
//                paymentMethod: _con.getDeliveryMethod(),
//                onPressed: (paymentMethod) {
//                  print('can deliver? ${_con.carts[0].food.restaurant.availableForDelivery}');
//                  _con.toggleDelivery();
//                  Address _address = _con.deliveryAddress;
//                  showDialog(context: context, builder: (context) {
//                    return SimpleDialog(
// //            contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                      titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
//                      title: Row(
//                        children: <Widget>[
//                          Icon(
//                            Icons.place,
//                            color: Theme
//                                .of(context)
//                                .hintColor,
//                          ),
//                          SizedBox(width: 10),
//                          Text(
//                            S
//                                .of(context)
//                                .add_delivery_address,
//                            style: Theme
//                                .of(context)
//                                .textTheme
//                                .bodyText1,
//                          )
//                        ],
//                      ),
//                      children: <Widget>[
//                        Form(
//                          key: _deliveryAddressFormKey,
//                          child: Column(
//                            children: <Widget>[
//                              Padding(
//                                padding: const EdgeInsets.symmetric(
//                                    horizontal: 20),
//                                child: new TextFormField(
//                                  style: TextStyle(color: Theme
//                                      .of(context)
//                                      .hintColor),
//                                  keyboardType: TextInputType.text,
//                                  decoration: getInputDecoration(hintText: S
//                                      .of(context)
//                                      .home_address, labelText: S
//                                      .of(context)
//                                      .description),
//                                  initialValue: _address.description?.isNotEmpty ??
//                                      false ? _address.description : null,
//                                  validator: (input) =>
//                                  input
//                                      .trim()
//                                      .length == 0
//                                      ? 'Not valid address description'
//                                      : null,
//                                  onSaved: (input) => _address.description = input,
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.symmetric(
//                                    horizontal: 20),
//                                child: new TextFormField(
//                                  style: TextStyle(color: Theme
//                                      .of(context)
//                                      .hintColor),
//                                  keyboardType: TextInputType.text,
//                                  decoration: getInputDecoration(hintText: S
//                                      .of(context)
//                                      .hint_full_address, labelText: S
//                                      .of(context)
//                                      .full_address),
//                                  initialValue: _address.address?.isNotEmpty ??
//                                      false ? _address.address : null,
//                                  validator: (input) =>
//                                  input
//                                      .trim()
//                                      .length == 0 ? S
//                                      .of(context)
//                                      .notValidAddress : null,
//                                  onSaved: (input) => _address.address = input,
//                                ),
//                              ),
//                              SizedBox(
//                                width: double.infinity,
//                                child: CheckboxFormField(
//                                  context: context,
//                                  initialValue: _address.isDefault ?? false,
//                                  onSaved: (input) => _address.isDefault = input,
//                                  title: Text(S
//                                      .of(context)
//                                      .makeItDefault),
//                                ),
//                              )
//                            ],
//                          ),
//                        ),
//                        Row(
//                          children: <Widget>[
//                            MaterialButton(
//                              onPressed: () {
//                                Navigator.pop(context);
//                              },
//                              child: Text(
//                                S
//                                    .of(context)
//                                    .cancel,
//                                style: TextStyle(color: Theme
//                                    .of(context)
//                                    .hintColor),
//                              ),
//                            ),
//                            MaterialButton(
//                              onPressed: (){
//                                _submit(_address);
//                              },
//                              child: Text(
//                                S
//                                    .of(context)
//                                    .save,
//                                style: TextStyle(color: Theme
//                                    .of(context)
//                                    .accentColor),
//                              ),
//                            ),
//                          ],
//                          mainAxisAlignment: MainAxisAlignment.end,
//                        ),
//                        SizedBox(height: 10),
//                      ],
//                    );
//                  });
//                }):Container():Container(),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 10, left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.map,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).delivery,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    //     &&
                    //     Helper.canDelivery(_con.carts[0].food.restaurant,
                    // carts: _con.carts)
                    ///This Was here > with is empty
                    subtitle: _con.carts.isNotEmpty
                        ? Text(
                            S
                                .of(context)
                                .click_to_confirm_your_address_and_pay_or_long_press,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          )
                        : Text(
                            S.of(context).deliveryMethodNotAllowed,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                  ),
                ),
                // &&
                // Helper.canDelivery(_con.carts[0].food.restaurant,
                // carts: _con.carts)
                ///and here
                _con.carts.isNotEmpty
                    ? DeliveryAddressesItemWidget(
                        paymentMethod: _con.getDeliveryMethod(),
                        address: _con.deliveryAddress,
                        onPressed: (Address _address) {
                          print('Address : ${_con.deliveryAddress.id}');
                          if (_con.deliveryAddress.id == null ||
                              _con.deliveryAddress.id == 'null') {
                            DeliveryAddressDialog(
                              context: context,
                              address: _address,
                              onChanged: (Address _address) {
                                _con.addAddress(_address, context);
                              },
                            );
                          } else {
                            _con.toggleDelivery();
                          }
                        },
                        onLongPress: (Address _address) {
                          DeliveryAddressDialog(
                            context: context,
                            address: _address,
                            onChanged: (Address _address) {
                              _con.updateAddress(_address, context);
                            },
                          );
                        },
                      )
                    : NotDeliverableAddressesItemWidget()
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: MaterialButton(
                onPressed: () {
                  checkOut();
                },
                disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                padding: EdgeInsets.symmetric(vertical: 14),
                color: _con.carts.isNotEmpty
                    ? !_con.carts[0].food.restaurant.closed
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).focusColor.withOpacity(0.5)
                    : Theme.of(context).focusColor.withOpacity(0.5),
                shape: StadiumBorder(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).checkout,
                      style: Theme.of(context).textTheme.bodyText1.merge(
                          TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Helper.getPrice(_con.total, context,
                        style: Theme.of(context).textTheme.bodyText1.merge(
                            TextStyle(color: Theme.of(context).primaryColor)),
                        zeroPlaceholder: 'Free'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkOut() {
    if (_con.list.pickupList.elementAt(2).selected) {
      executeRegularPayment(_con.total.toString());
    } else {
      _con.goCheckout(context);
    }
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

  void _submit(Address address) {
    if (_deliveryAddressFormKey.currentState.validate()) {
      _deliveryAddressFormKey.currentState.save();
      _con.updateAddress(address, context);
      Navigator.pop(context);
    }
  }
}
