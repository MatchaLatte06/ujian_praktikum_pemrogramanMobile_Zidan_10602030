import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const CargoFlowApp());
}

class CargoFlowApp extends StatelessWidget {
  const CargoFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CargoFlow Logistics',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}