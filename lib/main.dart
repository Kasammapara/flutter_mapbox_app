import 'package:flutter/material.dart';
import 'package:mastek_deepblue/pages/homepage.dart';
import 'package:mastek_deepblue/pages/navigations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mastek_deepblue/pages/searchbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  //await dotenv.load(fileName: "assets/config/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:NaviagtionBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}

