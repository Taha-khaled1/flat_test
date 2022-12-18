import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/map_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';

class MapToPay extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MapToPay({Key key, this.routeArgument, this.parentScaffoldKey})
      : super(key: key);

  @override
  _MapToPayState createState() => _MapToPayState();
}

class _MapToPayState extends StateMVC<MapToPay> {
  MapController _con;
  static LatLng center = LatLng(24.633333, 46.716667);
  final Set<Marker> _marker = {};
  LatLng _lastMapPosition = center;

  _MapToPayState() : super(MapController()) {
    _con = controller;
  }

  LatLng currentPostion;

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      center = LatLng(currentPostion.latitude, currentPostion.longitude);
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  GoogleMapController _controller;
  loc.Location _location = loc.Location();

  @override
  void initState() {
    _con.currentRestaurant = widget.routeArgument?.param as Restaurant;
    if (_con.currentRestaurant?.latitude != null) {
      // user select a restaurant
      _con.getRestaurantLocation();
      _con.getDirectionSteps();
    } else {
      _con.getCurrentLocation();
    }
    super.initState();
  }
  bool isCameraPosition = true;
  void _onMapCreated(GoogleMapController _contr) {
    _controller = _contr;
    _location.onLocationChanged.listen((currentLocation) {
      if (isCameraPosition) {
        _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 15)));
        isCameraPosition = false;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
//        fit: StackFit.expand,
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            _con.cameraPosition == null
                ? CircularLoadingWidget(height: 0)
                : GoogleMap(
                    myLocationEnabled: true,
                    mapToolbarEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition:
                        CameraPosition(target: center, zoom: 15),
                    onMapCreated: _onMapCreated,
                    onCameraMove: _onCameraMove,
                  ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 32,
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                left: 70,
                right: 70,
                child: MaterialButton(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  onPressed: () {

                    Navigator.pop(context, {'Latlng': _lastMapPosition});
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
