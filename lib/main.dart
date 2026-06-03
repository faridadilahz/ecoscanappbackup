import 'package:flutter/material.dart';
import 'package:ecoscan/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:ecoscan/screens/home_screen.dart';
import 'package:ecoscan/providers/history_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HistoryProvider())],
      child: EcoScanApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class EcoScanApp extends StatelessWidget {
  final bool seenOnboarding;
  const EcoScanApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        fontFamily: 'Bricolage-Grotesque',
        useMaterial3: true,
      ),
      home: seenOnboarding ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
