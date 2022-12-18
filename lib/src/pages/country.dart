import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkey_app/src/helpers/helper.dart';
import 'package:turkey_app/src/models/countries.dart';
import 'package:http/http.dart' as http;
import '../../generated/l10n.dart';

class Country extends StatefulWidget {
  @override
  _CountryState createState() => _CountryState();
}

bool isLoading = true;
LatLng cityLatLng;

class _CountryState extends State<Country> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  Countries allCountries;

  getData() async {
    Uri uri = Helper.getUri('api/countries');
    http.Response response = await http.get(uri);
    Countries countries = Countries.fromJson(jsonDecode(response.body));
    if(mounted)
    setState(() {
      allCountries = countries;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : CountriesGrid(list: allCountries));
  }
}

class CountriesGrid extends StatefulWidget {
  final Countries list;

  CountriesGrid({this.list});

  @override
  _CountriesGridState createState() => _CountriesGridState();
}

class _CountriesGridState extends State<CountriesGrid> {
  int index;
  List<Restaurant> cities = [];
  Restaurant selectedCity;
  String currentCurrency;
  String currentEquation;

  navigateToHome(int c_id, LatLng c_latLng, String currency, equation) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('cityId', c_id);
    prefs.setDouble(
      'cityLat',
      c_latLng.latitude,
    );
    prefs.setDouble(
      'cityLng',
      c_latLng.longitude,
    );
    prefs.setString('currency', currency);
    prefs.setDouble('equation', double.parse(equation));

    Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            S.of(context).select_the_country,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 250,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: widget.list == null ? 0 : widget.list.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        index = i;
                        cities = widget.list.data[i].restaurants;
                        currentCurrency = "  ريال  ";
                        currentEquation = widget.list.data[i].equation;

                        selectedCity =
                            cities.isNotEmpty ? cities[0] : Restaurant();
                      });
                    },
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            color: index == i
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              widget.list.data[i].name == null
                                  ? "null"
                                  : widget.list.data[i].name,
                              style: TextStyle(
                                  color: index == i
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).colorScheme.secondary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "ElMessiri-Bold"),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 0),
                                      blurRadius: 3,
                                      spreadRadius: 3)
                                ],
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    widget.list.data[i].media[0].url,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          index == null && cities.isEmpty
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 80),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                    ),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: DropdownButton<Restaurant>(
                      hint: Row(
                        children: <Widget>[
                          Icon(
                            Icons.pin_drop,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text('             '
                              // style:  TextStyle(color: Colors.black),
                              ),
                        ],
                      ),
                      value: selectedCity,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      underline: Text(''),
                      onChanged: (Restaurant Value) {
                        setState(() {
                          selectedCity = Value;
                        });
                      },
                      items: cities.map((Restaurant city) {
                        return DropdownMenuItem<Restaurant>(
                          value: city,
                          child: InkWell(
                            onTap: () {
                              List<String> latLng = city.latitude.split(',');
                              print(latLng[0]);
                              setState(() {
                                cityLatLng = LatLng(double.parse(latLng[0]),
                                    double.parse(latLng[0]));
                              });
                              navigateToHome(city.id, cityLatLng,
                                  currentCurrency, currentEquation);
                              print("Done");
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.pin_drop,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  city.name,
                                  // style:  TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
