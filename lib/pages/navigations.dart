
import 'dart:ffi';

import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mastek_deepblue/pages/Maps.dart';

import 'homepage.dart';

class NaviagtionBar extends StatefulWidget {

  const NaviagtionBar({super.key});

  @override

  State<NaviagtionBar> createState() => _NaviagtionBarState();
}

class _NaviagtionBarState extends State<NaviagtionBar> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(CupertinoIcons.tickets_fill), label: 'My Parking'),
            NavigationDestination(icon: Icon(Icons.account_circle), label: 'Account'),
            NavigationDestination(icon: Icon(Icons.menu), label: 'More'),
          ], // NavigationBar
        ),
      ), // Obx
      body: Obx(
            () {
          final screens = controller.screens;

          if (screens.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return screens[controller.selectedIndex.value];
          }
        },
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  List<Widget> get screens {
    return [
      Homescreen(),
      Container(color: Colors.purple),
      Container(color: Colors.orange),
      Mappage(latLng:LatLng(19.1136141, 73.0070543)),
    ];
  }
}
