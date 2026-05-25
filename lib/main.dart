import 'package:flutter/material.dart';
import 'package:ecoscan/screens/home_screen.dart';
import 'package:ecoscan/screens/onboarding_screen.dart';

// 1. Ubah void main() menjadi async
void main() async {
  // 2. Wajib tambahkan ini agar inisialisasi kamera & fitur native laptop/HP tidak stuck
  WidgetsFlutterBinding.ensureInitialized();
  
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), // Style Material 3 yang direkomendasikan
        // Kita set font family default ke Sans Serif agar mirip desain Figma lo
        fontFamily: 'Bricolage-Grotesque', 
        useMaterial3: true, // Pake style Material 3 yang lebih modern
      ),
      home: const OnboardingScreen(), // Arahkan ke class yang ada di home_screen.dart
    );
  }
}