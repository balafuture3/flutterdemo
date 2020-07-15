import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  Position position;
  static LatLng _initialPosition;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 0,
  );

  static CameraPosition _kLake;

  @override
  void initState() {
    setState(() {
      _currentposition();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton /*.extended*/(
        onPressed: _currentposition,
        child: Icon(Icons.my_location),

        // label: Text('My Location'),
        // icon: Icon(Icons.my_location),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _currentposition() async {
    position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      Marker resultMarker = Marker(
        markerId: MarkerId("Marker Name"),
        infoWindow: InfoWindow(
            title: placemark[0].locality,
            snippet: placemark[0].administrativeArea),
        position: LatLng(position.latitude, position.longitude),
      );
      markers.add(resultMarker);
      print('${placemark[0].name}');
      print('${placemark[0].locality}');
      print('${placemark[0].administrativeArea}');
      print('${placemark[0].postalCode}');
    });
    final GoogleMapController controller = await _controller.future;
    _kLake = CameraPosition(
      // bearing: 192.8334901395799,
        target: LatLng(position.latitude, position.longitude),
        zoom: 14);
    print(position.latitude);
    print(position.longitude);
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}