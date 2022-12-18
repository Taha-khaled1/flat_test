import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/l10n.dart';
import '../helpers/checkbox_form_field.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/address.dart';
import '../repository/settings_repository.dart';

// ignore: must_be_immutable
class DeliveryAddressDialog {
  BuildContext context;
  Address address;
  ValueChanged<Address> onChanged;
  GlobalKey<FormState> _deliveryAddressFormKey = new GlobalKey<FormState>();

  DeliveryAddressDialog({this.context, this.address, this.onChanged}) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
//            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.place,
                  color: Theme.of(context).hintColor,
                ),
                SizedBox(width: 10),
                Text(
                  S.of(context).add_delivery_address,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            children: <Widget>[
              Form(
                key: _deliveryAddressFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(hintText: S.of(context).home_address, labelText: S.of(context).description),
                        initialValue: address.description?.isNotEmpty ?? false ? address.description : null,
                        validator: (input) => input.trim().length == 0 ? 'Not valid address description' : null,
                        onSaved: (input) => address.description = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(hintText: S.of(context).hint_full_address, labelText: S.of(context).full_address),
                        initialValue: address.address?.isNotEmpty ?? false ? address.address : null,
                        validator: (input) => input.trim().length == 0 ? S.of(context).notValidAddress : null,
                        onSaved: (input) => address.address = input,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CheckboxFormField(
                        context: context,
                        initialValue: address.isDefault ?? false,
                        onSaved: (input) => address.isDefault = input,
                        title: Text(S.of(context).makeItDefault),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).cancel,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                  MaterialButton(
                    onPressed: ()=>_submit(address.isDefault ),
                    child: Text(
                      S.of(context).save,
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              SizedBox(height: 10),
            ],
          );
        });
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit(bool isDef) async{
    if(address.latitude==null){
      LocationResult result = await showLocationPicker(
        context,
        setting.value.googleMapsKey,
        initialCenter: LatLng(deliveryAddress.value?.latitude ?? 0, deliveryAddress.value?.longitude ?? 0),
        //automaticallyAnimateToCurrentLocation: true,
        //mapStylePath: 'assets/mapStyle.json',
        myLocationButtonEnabled: true,
        //resultCardAlignment: Alignment.bottomCenter,
      );
      address = new Address.fromJSON({
        'address': result.address,
        'latitude': result.latLng.latitude,
        'longitude': result.latLng.longitude,
      });
      _deliveryAddressFormKey.currentState.save();
      onChanged(address);

        print('ADDRESS : ${address.longitude}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('address_id', address.id);
        prefs.setString('address_desc', address.description);
        prefs.setString('address_adress', address.address);
        prefs.setDouble('address_lat', address.latitude);
        prefs.setDouble('address_lng', address.longitude);

      Navigator.pop(context);
      print("result = $result");
    }else{
    if (_deliveryAddressFormKey.currentState.validate()) {
      _deliveryAddressFormKey.currentState.save();
      onChanged(address);
      if(isDef){
        print('ADDRESS : ${address.longitude}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('address_id', address.id);
        prefs.setString('address_desc', address.description);
        prefs.setString('address_adress', address.address);
        prefs.setDouble('address_lat', address.latitude);
        prefs.setDouble('address_lng', address.longitude);
      }
      Navigator.pop(context);
    }}
  }
}
