import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import '../main.dart';


String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = 'sk.eyJ1Ijoia2FzYW0wOSIsImEiOiJjbHN1YzNlem8wc3N2MnBwZ3d3bmVzb2J4In0.ajTM7BiN_ELRPDl4pgm9jQ';
String searchType = 'place%2Cpostcode%2Caddress';
String searchResultsLimit = '5';
Location _location = Location();
LocationData _locationData = _location.getLocation() as LocationData;
String proximity =
    '${_locationData.longitude}%2C${_locationData.latitude}';
String country = 'in';

Dio _dio = Dio();

Future<LocationData?> _getCurrentLocation() async {
  bool serviceEnabled = await _location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await _location.requestService();
    if (!serviceEnabled) {
      return null; // Handle location service disabled case
    }
  }

  PermissionStatus permission = await _location.hasPermission();
  if (permission == PermissionStatus.denied) {
    permission = await _location.requestPermission();
    if (permission != PermissionStatus.granted) {
      return null; // Handle location permission denied case
    }
  }

  return await _location.getLocation();
}

Future getSearchResultsFromQueryUsingMapbox(String query) async {
  LocationData? _locationData = await _getCurrentLocation();
  if (_locationData == null) {
    // Handle location unavailable case (e.g., display error message)
    return;
  }

  proximity = '${_locationData.longitude}%2C${_locationData.latitude}';

  String url =
      '$baseUrl/$query.json?country=$country&limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$accessToken';
  url = Uri.parse(url).toString();
  print(url);
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    print(e);
  }
}

