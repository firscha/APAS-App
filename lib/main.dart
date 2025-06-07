import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/credit_app.dart';
import 'screens/cam_page.dart';
import 'screens/fish_feeder.dart';
import 'screens/sensor_control.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // 🔥 Inisialisasi Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FireFlutter',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'ArialRounded', // ✅ Ganti ke nama yang sudah didaftarkan di pubspec.yaml
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuPage(),
        '/credit': (context) => const CreditAppPage(),
        '/cam': (context) => const PlantMonitoringPage(),
        '/fish': (context) => const FishFeederScreen(),
        '/sensor': (context) => const SensorControlPage(),
      },
    );
  }
}