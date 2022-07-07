import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/camera/fresh_ml_controller.dart';
import 'package:freshme/splash/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    cameras = await availableCameras();
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: FlexColorScheme.light(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF127681),
          secondary: Color(0xFFfac70d),
        ),
        appBarStyle: FlexAppBarStyle.surface,
        textTheme: GoogleFonts.beVietnamProTextTheme(),
      ).toTheme,
      scrollBehavior: FreshmeScrollBehavior(),
      home: const SplashScreen(),
    );
  }
}

class FreshmeScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}
