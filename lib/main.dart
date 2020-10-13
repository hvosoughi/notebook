import 'package:flutter/material.dart';
import 'package:notebook/screens/word_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notebook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WordListScreen(),
    );
  }
}
