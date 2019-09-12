import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'globals.dart' as globals;


class SecondPage extends StatefulWidget {
  SecondPage({Key key}) : super(key: key);

  @override
  createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State {
  var location = new Location();

  Map<String, double> userLocation;

  static LatLng _center = LatLng(45.521563, -122.677433);

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  bool panToLocation = true;

  @override
  Widget build(BuildContext context) {
    _getLocation().then((value) {
      setState(() {
        userLocation = value;

        if(mapController != null && panToLocation == true) {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(userLocation["latitude"].toDouble(), userLocation["longitude"].toDouble()), zoom: 18.0),
            ),
          );
          _center = LatLng(userLocation["latitude"].toDouble(), userLocation["longitude"].toDouble());
          panToLocation = false;
        }
      });
    });

    return Scaffold(
      body:
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            myLocationEnabled : true,
            myLocationButtonEnabled: false,

          ),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom:100),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  foregroundColor: Colors.black54,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.add),
                  onPressed: () {
                    print("add code here!");
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(userLocation["latitude"].toDouble(), userLocation["longitude"].toDouble()), zoom: 18.0
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom:10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  foregroundColor: Colors.black54,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.my_location),
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(userLocation["latitude"].toDouble(), userLocation["longitude"].toDouble()), zoom: 18.0
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        )
//        floatingActionButton: FloatingActionButton(
//            foregroundColor: Colors.black54,
//            backgroundColor: Colors.white,
//            child: Icon(Icons.my_location),
//
    );
  }

  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }

    globals.latitude = currentLocation["latitude"].toString();
    globals.longitude = currentLocation["longitude"].toString();

    return currentLocation;
  }
}