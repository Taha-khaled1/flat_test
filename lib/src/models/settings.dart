// To parse this JSON data, do
//
//     final settings = settingsFromJson(jsonString);

import 'dart:convert';

Settings settingsFromJson(String str) => Settings.fromJson(json.decode(str));

String settingsToJson(Settings data) => json.encode(data.toJson());

class Settings {
  Settings({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  String message;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.appName,
    this.enableStripe,
    this.defaultTax,
    this.defaultCurrency,
    this.fcmKey,
    this.enablePaypal,
    this.mainColor,
    this.mainDarkColor,
    this.secondColor,
    this.secondDarkColor,
    this.accentColor,
    this.accentDarkColor,
    this.scaffoldDarkColor,
    this.scaffoldColor,
    this.googleMapsKey,
    this.mobileLanguage,
    this.appVersion,
    this.enableVersion,
    this.defaultCurrencyDecimalDigits,
    this.currencyRight,
    this.homeSection1,
    this.homeSection2,
    this.homeSection3,
    this.homeSection4,
    this.homeSection5,
    this.homeSection6,
    this.homeSection7,
    this.homeSection8,
    this.enable_myfatoorah,
    this.homeSection9,
    this.homeSection10,
    this.homeSection11,
    this.homeSection12,
    this.distanceUnit,
    this.androidApp,
    this.iosApp,
    this.myfatoorahKey,
  });

  String appName;
  String enableStripe;
  String enable_myfatoorah;
  String defaultTax;
  String defaultCurrency;
  String fcmKey;
  String enablePaypal;
  String mainColor;
  String mainDarkColor;
  String secondColor;
  String secondDarkColor;
  String accentColor;
  String accentDarkColor;
  String scaffoldDarkColor;
  String scaffoldColor;
  String googleMapsKey;
  String mobileLanguage;
  String appVersion;
  String enableVersion;
  String defaultCurrencyDecimalDigits;
  String currencyRight;
  String homeSection1;
  String homeSection2;
  String homeSection3;
  String homeSection4;
  String homeSection5;
  String homeSection6;
  String homeSection7;
  String homeSection8;
  String homeSection9;
  String homeSection10;
  String homeSection11;
  String homeSection12;
  String distanceUnit;
  String androidApp;
  String iosApp;
  String myfatoorahKey;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        appName: json["app_name"],
        enableStripe: json["enable_stripe"],
        defaultTax: json["default_tax"],
        defaultCurrency: json["default_currency"],
        fcmKey: json["fcm_key"],
    enable_myfatoorah: json["enable_myfatoorah"],
        enablePaypal: json["enable_paypal"],
        mainColor: json["main_color"],
        mainDarkColor: json["main_dark_color"],
        secondColor: json["second_color"],
        secondDarkColor: json["second_dark_color"],
        accentColor: json["accent_color"],
        accentDarkColor: json["accent_dark_color"],
        scaffoldDarkColor: json["scaffold_dark_color"],
        scaffoldColor: json["scaffold_color"],
        googleMapsKey: json["google_maps_key"],
        mobileLanguage: json["mobile_language"],
        appVersion: json["app_version"],
        enableVersion: json["enable_version"],
        defaultCurrencyDecimalDigits: json["default_currency_decimal_digits"],
        currencyRight: json["currency_right"],
        homeSection1: json["home_section_1"],
        homeSection2: json["home_section_2"],
        homeSection3: json["home_section_3"],
        homeSection4: json["home_section_4"],
        homeSection5: json["home_section_5"],
        homeSection6: json["home_section_6"],
        homeSection7: json["home_section_7"],
        homeSection8: json["home_section_8"],
        homeSection9: json["home_section_9"],
        homeSection10: json["home_section_10"],
        homeSection11: json["home_section_11"],
        homeSection12: json["home_section_12"],
        distanceUnit: json["distance_unit"],
        androidApp: json["android_app"],
        iosApp: json["ios_app"],
        myfatoorahKey: json["myfatoorah_key"],
      );

  Map<String, dynamic> toJson() => {
        "app_name": appName,
        "enable_stripe": enableStripe,
        "default_tax": defaultTax,
        "default_currency": defaultCurrency,
        "fcm_key": fcmKey,
        "enable_paypal": enablePaypal,
        "main_color": mainColor,
        "enable_myfatoorah": enable_myfatoorah,
        "main_dark_color": mainDarkColor,
        "second_color": secondColor,
        "second_dark_color": secondDarkColor,
        "accent_color": accentColor,
        "accent_dark_color": accentDarkColor,
        "scaffold_dark_color": scaffoldDarkColor,
        "scaffold_color": scaffoldColor,
        "google_maps_key": googleMapsKey,
        "mobile_language": mobileLanguage,
        "app_version": appVersion,
        "enable_version": enableVersion,
        "default_currency_decimal_digits": defaultCurrencyDecimalDigits,
        "currency_right": currencyRight,
        "home_section_1": homeSection1,
        "home_section_2": homeSection2,
        "home_section_3": homeSection3,
        "home_section_4": homeSection4,
        "home_section_5": homeSection5,
        "home_section_6": homeSection6,
        "home_section_7": homeSection7,
        "home_section_8": homeSection8,
        "home_section_9": homeSection9,
        "home_section_10": homeSection10,
        "home_section_11": homeSection11,
        "home_section_12": homeSection12,
        "distance_unit": distanceUnit,
        "android_app": androidApp,
        "ios_app": iosApp,
        "myfatoorah_key": myfatoorahKey,
      };
}
