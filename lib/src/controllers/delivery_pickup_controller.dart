import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/payment_method.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class DeliveryPickupController extends CartController {
  GlobalKey<ScaffoldState> scaffoldKey;
  model.Address deliveryAddress;
  PaymentMethodList list;
  BuildContext context;
  DeliveryPickupController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    super.listenForCarts(context);
    listenForDeliveryAddress();
    print(settingRepo.deliveryAddress.value.toMap());
  }

  void listenForDeliveryAddress() async {
    this.deliveryAddress = settingRepo.deliveryAddress.value;
    print(this.deliveryAddress.id);
  }

  void addAddress(model.Address address, BuildContext context) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).new_address_added_successfully),
      ));
    });
  }

  void updateAddress(model.Address address, BuildContext context) {
    userRepo.updateAddress(address).then((value) {
      print(value);
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).the_address_updated_successfully),
      ));
    });
  }

  PaymentMethod getPickUpMethod() {
    return list.pickupList.elementAt(0);
  }

  PaymentMethod getDeliveryMethod() {
    return list.pickupList.elementAt(1);
  }

  PaymentMethod getMyFatorah() {
    return list.pickupList.elementAt(2);
  }

  void toggleDelivery() {
    // list.pickupList.forEach((element) {
    //   if (element != getDeliveryMethod() || element != getMyFatorah()) {
    //     element.selected = false;
    //   }
    // });
    setState(() {
      getDeliveryMethod().selected = !getDeliveryMethod().selected;
      // isDelivery=true;
    });
  }

  void payByMyFatorah() {
    list.pickupList.forEach((element) {
      if (element != getMyFatorah()) {
        element.selected = false;
      }
    });
    setState(() {
      getMyFatorah().selected = !getMyFatorah().selected;
    });
  }

  void togglePickUp(bool isDelivery) {
    list.pickupList.forEach((element) {
      if (element != getPickUpMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getPickUpMethod().selected = !getPickUpMethod().selected;
      // isDelivery=false;
    });
  }

  PaymentMethod getSelectedMethod() {
    return list.pickupList.firstWhere((element) => element.selected);
  }

  @override
  void goCheckout(BuildContext context) {
    Navigator.of(context).pushNamed(getSelectedMethod().route);
  }
}
