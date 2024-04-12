import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../main.dart';

Widget searchListView(
    List responses,
    TextEditingController destinationController) { // Remove isResponseForDestination parameter
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: responses.length,
    itemBuilder: (BuildContext context, int index) {
      return Column(
        children: [
          ListTile(
            onTap: () {
              String text = responses[index]['place'];
              LatLng co = responses[index]['location'];
              destinationController.text = text; // Set text to destination controller
              sharedPreferences.setString(
                  'destination', json.encode(responses[index]));
              Navigator.pop(context, {'text': text, 'co': co});// Store destination in SharedPreferences
              FocusManager.instance.primaryFocus?.unfocus();

            },
            leading: const SizedBox(
              height: double.infinity,
              child: CircleAvatar(child: Icon(Icons.map)),
            ),
            title: Text(responses[index]['name'],
                style: const TextStyle(fontWeight: FontWeight.bold,
                color: Colors.white,
                )),
            subtitle: Text(responses[index]['address'],
                style: const TextStyle(color: Colors.white)

            ),
          ),
          const Divider(),
        ],
      );
    },
  );
}
