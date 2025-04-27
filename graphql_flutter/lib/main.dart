import 'package:flutter/material.dart';
import 'package:graphql_flutter/country_screen/country_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GraphQl Example',
      home: CountryScreen(),
    );
  }
}
