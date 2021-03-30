import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(myApp());

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '簡単脳トレ',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
