import 'package:flutter/material.dart';
import 'package:ecoscan/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:ecoscan/providers/history_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const EcoScanApp(),
    ),
  );
}

class EcoScanApp extends StatelessWidget {
  const EcoScanApp({super.key});

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
      home: const OnboardingScreen(),
    );
  }
}