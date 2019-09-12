import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'globals.dart' as globals;


class FirstPage extends StatefulWidget {
  FirstPage({Key key}) : super(key: key);

  @override
  createState() => _ARPageState();
}

class _ARPageState extends State {
  ARKitController arkitController;

  var location = new Location();
  Map<String, double> userLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ARKitSceneView(onARKitViewCreated: onARKitViewCreated),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    final node = ARKitNode(
        //geometry: ARKitSphere(radius: 0.1), position: vector.Vector3(0, 0, -0.5)
    );
    this.arkitController.add(node);
    this.arkitController.add(_createText());
  }

  ARKitNode _createText() {
    final text = ARKitText(
      text: "(" + double.parse(globals.latitude.toString()).toStringAsFixed(2) + ", " + double.parse(globals.longitude.toString()).toStringAsFixed(2) + ")",
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.orangeAccent),
        )
      ],
    );
    return ARKitNode(
      geometry: text,
      position: vector.Vector3(-0.8, 0, -2.0),
      scale: vector.Vector3(0.02, 0.02, 0.02),
    );
  }
}