import 'package:flutter/material.dart';
import 'package:ecoscan/screens/home_screen.dart';
import 'package:ecoscan/screens/onboarding_screen.dart';

void main() {
  runApp(const EcoScanApp());
}

class EcoScanApp extends StatelessWidget {
  const EcoScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoScan',
      debugShowCheckedModeBanner: false, // Ngilangin banner "debug" di pojok kanan
      theme: ThemeData(
        primarySwatch: Colors.green,
        // Kita set font family default ke Sans Serif agar mirip desain Figma lo
        fontFamily: 'Bricolage-Grotesque', 
        useMaterial3: true, // Pake style Material 3 yang lebih modern
      ),
      home: const OnboardingScreen(), // Arahkan ke class yang ada di home_screen.dart
    );
  }
}