import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mastek_deepblue/helpers/shared_prefs.dart';
import 'homepage.dart';
import 'navigations.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:location/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Mappage extends StatefulWidget {
  LatLng latLng;
  
   Mappage({super.key,
   required this.latLng, String? searchText,  String? startDate, String? endDate,
   });

  State<Mappage> createState() => _MapState();
}

class _MapState extends State<Mappage> {
  //LatLng latLng = getLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  @override
  void initState(){
    super.initState();
    _initialCameraPosition=CameraPosition(target: widget.latLng ,zoom: 15);

  }
  _addSourceAndLineLayer(int index,bool removeLayer) async {}
  _onMapCreated(MapboxMapController controller) async {this.controller=controller;}
  _onStyleLoadedCallBack() async {}
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
        Stack(
          children:[ SizedBox(
            height: MediaQuery.of(context).size.height*0.95,
            child: MapboxMap(
              accessToken:'sk.eyJ1Ijoia2FzYW0wOSIsImEiOiJjbHN1YzNlem8wc3N2MnBwZ3d3bmVzb2J4In0.ajTM7BiN_ELRPDl4pgm9jQ',
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallBack,
              //myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              minMaxZoomPreference: MinMaxZoomPreference(14, 17),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child:GestureDetector(
                onTap: (){Navigator.pop(context);},
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 80, // Adjust the height as needed
                  child: NaviagtionBar(),
                ),
              ),)]
        )
      ),

    );
  }


}

