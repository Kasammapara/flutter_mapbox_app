import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mastek_deepblue/pages/search_listview.dart';

import '../helpers/mapbox_handler.dart';
import '../main.dart';

class Searchinhere extends StatefulWidget {

  final LatLng? latLng;

   Searchinhere({super.key,
   required this.latLng});

  @override
  State<Searchinhere> createState() => _SearchinhereState();
}

class _SearchinhereState extends State<Searchinhere> {
  final TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  bool isEmptyResponse = true;
  bool hasResponded = false;

  String noRequest = 'Please enter an address, a place or a location to search';
  String noResponse = 'No results found for the search';

  List responses = [];

  // Define setters to be used by children widgets
  set responsesState(List responses) {
    setState(() {
      this.responses = responses;
      hasResponded = true;
      isEmptyResponse = responses.isEmpty;
    });
    Future.delayed(
      const Duration(milliseconds: 500),
          () => setState(() {
        isLoading = false;
      }),
    );
  }

  set isLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }
  bool _isReadOnly = true;
  bool _isAutoFocus = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 2), () {
      setState(() {
        _isReadOnly = false;
        _isAutoFocus = true;
      });
    });
  }
  Timer? searchOnStoppedTyping;
  String query = '';

  String getSearchText() {
    if (mounted) {
      // Get the search text from the SearchListView widget
      // You need to implement the logic to retrieve the text from responses
      return responses.toString();
    }
    return ''; // Return empty string if widget is not mounted
  }
  _onChangeHandler(value) {
    // Set isLoading = true in parent
    isLoading = true;

    // Make sure that requests are not made
    // until 1 second after the typing stops
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping?.cancel());
    }
    setState(() => searchOnStoppedTyping =
        Timer(const Duration(seconds: 1), () => _searchHandler(value)));
  }

  _searchHandler(String value) async {
    // Get response using Mapbox Search API
    List response = await getParsedResponseForQuery(value);
    print(response);
    // Set responses and isDestination in parent
    responsesState = response;
    setState(() => query = value);

  }
  _useCurrentLocation()async{
    LatLng? currentLocation = widget.latLng;
    print(currentLocation);
    // Get the response of reverse geocoding and do 2 things:
    // 1. Store encoded response in shared preferences
    // 2. Set the text editing controller to the address
    var response = await getParsedReverseGeocoding(currentLocation!);
    //sharedPreferences.setString('source', json.encode(response));
    String place = response['place'];
    print(place);
    textEditingController.text = place;
    _onChangeHandler(place);

}



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,

        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Select Destination",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body:SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Hero(
                    tag: Icons.search,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: CupertinoTextField(
                              controller: textEditingController,
                              readOnly: _isReadOnly,
                              autofocus: _isAutoFocus,
                              padding: EdgeInsets.all(12),
                              placeholder: 'Enter Address or Place',
                              placeholderStyle: TextStyle(fontWeight: FontWeight.w500),// Use 'placeholder' for hint text
                              decoration: BoxDecoration(
                                // Optional rounded corners
                              ),
                              // Add other properties as needed, such as:
                              keyboardType: TextInputType.text, // Adjust keyboard type if necessary
                              autocorrect: true, // Enable autocorrection if desired
                              maxLines: 1, // Set number of lines (default is 1)
                              onChanged:  _onChangeHandler,
                              onSubmitted: (text) {
                                Navigator.pop(context, text);
                              },
                            )
                          ),
                          IconButton(
                            icon: Icon(Icons.my_location), // Location icon
                            onPressed:_useCurrentLocation
        
                          ),
                          SizedBox(width: 8.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              isLoading? const LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue)):Container(),
              isEmptyResponse
                  ? SafeArea(
                    child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: Text(hasResponded ? noResponse : noRequest,
                          style: TextStyle(color: Colors.white),
                        ))),
                  )
                  : Container(),
                searchListView(responses, textEditingController),
            ],
          ),
        ),
      ),
    );
  }
}
