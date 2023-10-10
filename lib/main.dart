import 'package:flutter/material.dart';
import 'package:pr_af_2/screens%20/home_page.dart';

void main() {
  runApp(const MyApp())
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}
