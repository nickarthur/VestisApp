import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math' as math;
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
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ARKitSceneView(onARKitViewCreated: onARKitViewCreated),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;

    double userBearing = double.parse(globals.userDirection);
    double targetBearing = double.parse(globals.directionToDest);
    double distanceToTarget = double.parse(globals.directionToDest);

    if(userBearing > targetBearing) {
      targetBearing = targetBearing + 360;
    }

    double deltaDegree = (targetBearing - userBearing)%360;


    print(deltaDegree);

    double xpos = math.cos(deltaDegree*math.pi/180.0)*2; // vector horiz comp
    double zpos = math.sin(deltaDegree*math.pi/180.0)*2; // vector vertical comp

    ARKitMaterial material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.physicallyBased,
      diffuse: ARKitMaterialProperty(
        color: Colors.greenAccent,
      ),
    );

    final destNode = ARKitNode(
        geometry: ARKitSphere(
          materials: [material],
          radius: 0.1,
        ),
        position: vector.Vector3(xpos, 0, -zpos)
    );


//    material = ARKitMaterial(
//      lightingModelName: ARKitLightingModel.physicallyBased,
//      diffuse: ARKitMaterialProperty(
//        color: Colors.red,
//      ),
//    );
//
//
//    final xnode = ARKitNode(
//        geometry: ARKitSphere(
//          materials: [material],
//          radius: 0.1,
//        ),
//        position: vector.Vector3(1, 0, 0)
//    );
//
//    material = ARKitMaterial(
//      lightingModelName: ARKitLightingModel.physicallyBased,
//      diffuse: ARKitMaterialProperty(
//        color: Colors.yellow,
//      ),
//    );
//
//    final ynode = ARKitNode(
//        geometry: ARKitSphere(
//          materials: [material],
//          radius: 0.1,
//        ),
//        position: vector.Vector3(0, 1, 0)
//    );
//
//    material = ARKitMaterial(
//      lightingModelName: ARKitLightingModel.physicallyBased,
//      diffuse: ARKitMaterialProperty(
//        color: Colors.blue,
//      ),
//    );
//
//    final znode = ARKitNode(
//        geometry: ARKitSphere(
//          materials: [material],
//          radius: 0.1,
//        ),
//        position: vector.Vector3(0, 0, 1)
//    );
//
//    this.arkitController.add(xnode);
//    this.arkitController.add(ynode);
//    this.arkitController.add(znode);

    //final anchor = ARKitAnchor("node1", "identifier", vector.Matrix4.zero());

    this.arkitController.add(destNode);
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