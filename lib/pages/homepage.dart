import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mastek_deepblue/main.dart';
import 'package:mastek_deepblue/pages/Maps.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mastek_deepblue/pages/searchbar.dart';
import '../utils.dart';

class Homescreen extends StatefulWidget {
  Homescreen({super.key});
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String? searchText;
  LatLng? selectedloc;
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();
  bool isStartDateTimeSelected = false;
  bool isEndDateTimeSelected = false;
  String startDate = '';
  String endDate = '';
  LatLng? _currentloc;

  @override
  void initState() {
    super.initState();
    initializeLocation();
  }

  Future<void> initializeLocation() async {
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permission;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }
    _permission = await _location.hasPermission();
    if (_permission == PermissionStatus.denied) {
      _permission = await _location.requestPermission();
    }
    if (!mounted) return;

    LocationData _locationData = await _location.getLocation();
    setState(() {
      _currentloc = LatLng(_locationData.latitude!, _locationData.longitude!);
    });
    print(_currentloc);

    sharedPreferences.setDouble('latitute', _locationData.latitude!);
    sharedPreferences.setDouble('longitude', _locationData.longitude!);
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print(_currentloc);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            Container(
              height: screenHeight - 100,
              child: Column(
                children: [
                  SizedBox(
                    child: Image.asset(
                      'lib/images/homeimg.jpg',
                      width: screenWidth,
                      height: 470,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 440.0, // Adjust the top position as needed
                left: 16.0, // Adjust the left position as needed
                right: 16.0, // Adjust the right position as needed
                child: Column(
                  children: [
                    Hero(
                      tag: Icons.search,
                      transitionOnUserGestures: true,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            const SizedBox(width: 8.0),
                            Expanded(
                                child: CupertinoTextField(
                              readOnly: true,
                              placeholder:
                                  searchText ?? 'Enter Address or Place',
                              padding: EdgeInsets.all(12),
                              onTap: () async {
                                var result = await Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            Searchinhere(latLng: _currentloc)));

                                if (result != null) {
                                  setState(() {
                                    searchText = result['text'];
                                    selectedloc = result['co'];
                                    print(selectedloc);
                                  });
                                }
                              },

                              placeholderStyle: const TextStyle(
                                  fontWeight: FontWeight
                                      .w500), // Use 'placeholder' for hint text
                              decoration: const BoxDecoration(
                                  // Optional rounded corners
                                  ),
                              // Add other properties as needed, such as:// Adjust keyboard type if necessary
                              autocorrect:
                                  true, // Enable autocorrection if desired
                              maxLines: 1, // Set number of lines (default is 1)
                              onChanged: (text) {
                                // Handle text changes
                              },
                              onSubmitted: (text) {
                                // Handle form submission
                              },
                            )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 75,
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                              bottom: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ))),
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.08,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  if (searchText != null &&
                                      searchText!.isNotEmpty) {
                                    // If searchText is not null or empty, show the date picker
                                    Utils.showSheet(
                                      context,
                                      child: buildDateTimePicker(),
                                      onClicked: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          isStartDateTimeSelected = true;
                                          startDate =
                                              DateFormat('EEE, MMM d hh:mm a')
                                                  .format(startDateTime);
                                        });
                                      },
                                    );
                                  } else {
                                    // If searchText is null or empty, navigate to the search screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Searchinhere(
                                          latLng: _currentloc,
                                        ),
                                      ),
                                    ).then((value) {
                                      // Update the searchText after returning from the search screen
                                      setState(() {
                                        searchText = value as String?;
                                      });
                                    });
                                  }
                                },
                                child: Column(
                                  children: [
                                    if (!isStartDateTimeSelected)
                                      const Column(
                                        children: [
                                          SizedBox(
                                            height: 13,
                                          ),
                                          Text(
                                            "START",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    if (isStartDateTimeSelected)
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            DateFormat('EEE, MMM d')
                                                .format(startDateTime),
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            DateFormat('hh:mm a')
                                                .format(startDateTime),
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            thickness: 2, // Adjust thickness as needed
                            width: 40, // Adjust width as needed
                          ),
                          SizedBox(
                            width: screenWidth * 0.05,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  if (!isStartDateTimeSelected &&
                                      (searchText == null ||
                                          searchText!.isEmpty)) {
                                    // If searchText is null or empty, navigate to the search screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Searchinhere(
                                          latLng: _currentloc,
                                        ),
                                      ),
                                    ).then((value) {
                                      // Update the searchText after returning from the search screen
                                      setState(() {
                                        searchText = value as String?;
                                      });
                                    });
                                  } else if (!isStartDateTimeSelected) {
                                    Utils.showSheet(
                                      context,
                                      child: buildDateTimePicker(),
                                      onClicked: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          isStartDateTimeSelected = true;
                                          startDate =
                                              DateFormat('EEE, MMM d hh:mm a')
                                                  .format(startDateTime);
                                        });
                                      },
                                    );
                                  } else {
                                    // If searchText is not null or empty, show the date picker
                                    Utils.showSheet(
                                      context,
                                      child: buildDateTimePicker(),
                                      onClicked: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          isEndDateTimeSelected = true;
                                          endDate =
                                              DateFormat('EEE, MMM d hh:mm a')
                                                  .format(endDateTime);
                                          if (isEndDateTimeSelected) {
                                            // If end date time is selected, navigate to Mappage with searchText, startDate, and endDate
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Mappage(
                                                  latLng: selectedloc!,
                                                  searchText: searchText,
                                                  startDate: startDate,
                                                  endDate: endDate,
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                      },
                                    );
                                  }
                                },
                                child: Column(
                                  children: [
                                    if (!isEndDateTimeSelected)
                                      const Column(
                                        children: [
                                          SizedBox(
                                            height: 13,
                                          ),
                                          Text(
                                            "END",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    if (isEndDateTimeSelected)
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            DateFormat('EEE, MMM d')
                                                .format(endDateTime),
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            DateFormat('hh:mm a')
                                                .format(endDateTime),
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    SizedBox(
                      width: screenWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: FloatingActionButton(
                          backgroundColor: Color.fromRGBO(221, 227, 225, 0.37),
                          onPressed: () async {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>Mappage(latLng: currentLatlng,)));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Searchinhere(latLng: _currentloc!)));
                          },
                          child: const Text(
                            "SELECT A DESTINATION",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            Positioned(
              top: 530,
              left: 169,
              child: SizedBox(
                width: 40,
                child: Image.asset(
                  'lib/images/arrow1.jpg',
                  width: 50,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget buildDateTimePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
            initialDateTime: DateTime.now(),
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: DateTime(DateTime.now().year, 2, 1),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (dateTime) {
              if (isStartDateTimeSelected) {
                setState(() {
                  startDateTime = dateTime;
                });
              } else if (isEndDateTimeSelected) {
                setState(() {
                  endDateTime = dateTime;
                });
              }
            }),
      );
}

// class DelayedRoute extends PageRouteBuilder {
//   final Widget page;
//   final Duration delay;
//
//   DelayedRoute({required this.page, required this.delay})
//       : super(
//           pageBuilder: (context, animation, secondaryAnimation) => page,
//           transitionsBuilder: (context, animation, secondaryAnimation, child) =>
//               FadeTransition(
//             opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
//               CurvedAnimation(
//                 parent: animation,
//                 curve: Interval(delay.inMilliseconds / 1000, 1.0),
//               ),
//             ),
//             child: child,
//           ),
//         );
// }
