import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:async';
import 'dart:math';
import 'globals.dart' as globals;
import 'package:latlong/latlong.dart' as LatLongCalc;
import 'package:flutter_compass/flutter_compass.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key key}) : super(key: key);

  @override
  createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State {
  static LatLng _center = LatLng(45.521563, -122.677433);

  var location = new Location();

  final LatLongCalc.Distance distance = new LatLongCalc.Distance();

  GoogleMapController mapController;

  Map<String, double> userLocation;

  double rating = 0;

  double _direction = 0.0;

  bool panToLocation = true;

  double destLat = 37.136706;

  double destLong = -121.659072;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  @override
  void initState() {
    super.initState();

    _add();   // add a test marker
    print("added marker!");
  }

  @override
  Widget build(BuildContext context) {
    FlutterCompass.events.listen((double direction) {     // update user direction
      setState(() {
        _direction = direction;
      });
    });

    _getLocation().then((value) {                         // update user position
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

        double myLat = double.parse(globals.latitude);
        double myLong = double.parse(globals.longitude);

        //print("myPos " + myLat.toString() + ", " + myLong.toString());


        // for finding distance
        final double meter = distance(                  // use latlong.net to test
        new LatLongCalc.LatLng(myLat,myLong),
          new LatLongCalc.LatLng(destLat,destLong)
        );

        globals.distanceToDest = meter.toString();

        //print("Distance is " + meter.toString());


        // for finding bearing
//        myLat = 39.099912;          // test values (should be 96.51 degrees if correctly calculated)
//        myLong = -94.581213;
//        destLat = 38.627089;
//        destLong = -90.200203;

        double conversion = pi/180.0;

        double x = cos(destLat*conversion) * sin((destLong-myLong)*conversion);

        double temp1 = cos(myLat*conversion) * sin(destLat*conversion);
        double temp2 = sin(myLat*conversion) * cos(destLat*conversion) * cos((myLong-destLong)*conversion);

        double y = temp1-temp2;

        double bearingRadians = atan2(x, y);

        double bearingDegrees = bearingRadians*180.0/pi;

        //print(bearingDegrees);      // angle in terms of my location to the northern hemisphere, then rotating clockwise to the destination point

        //print(_direction);      // direction user is facing!
        globals.userDirection = _direction.toString();
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
            markers: Set<Marker>.of(markers.values)
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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

  void _add() {
    var markerIdVal = "someuniqueid";
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
          37.136706,// + sin(_markerIdCounter * pi / 6.0) / 20.0,
          -121.659072// + cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
      infoWindow: InfoWindow(title: 'Title', snippet: 'Description'),
      //icon: BitmapDescriptor,
      onTap: () {
        //_onMarkerTapped(markerId);
        print("marker tapped!");
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
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
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: new RatingBar(
                    initialRating: 3,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print("Rating:" + rating.toString());
                    },
                  )
              )

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
}