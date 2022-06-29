
import 'package:camera/camera.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:freshme/camera/fresh_ml_controller.dart';
import 'package:freshme/splash/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: const Color(0xFF127681),
        ),
        textTheme: GoogleFonts.beVietnamProTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}
