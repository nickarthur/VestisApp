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
  double rating = 0;

  Map<String, double> userLocation;

  static LatLng _center = LatLng(45.521563, -122.677433);

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Add Location"),
          content:

          new Column(
            children: <Widget>[
                new TextField(
                  autofocus: false,
                  decoration: new InputDecoration(
                      labelText: 'Name', hintText: 'Name'),
                  onChanged: (value) {
                    print(value + " changed!");
                    //teamName = value;
                  },
                ),

                new TextField(
                  autofocus: false,
                  decoration: new InputDecoration(
                      labelText: 'Description', hintText: 'Description'),
                  onChanged: (value) {
                    print(value + " changed!");
                    //teamName = value;
                  },
                ),

                new  Center(

                ),
              //),
            ],
          ),

          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                print("add to database here!");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                    _showDialog();
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