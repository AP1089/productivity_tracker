import 'package:click_up/navigation/bottom_navigation_container.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BottomNavigationContainer());
  }
}
