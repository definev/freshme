import 'dart:io';

import 'package:animations/animations.dart';
import 'package:camera/camera.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/camera/controller/fresh_ml_controller.dart';
import 'package:freshme/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
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
        appBarStyle: FlexAppBarStyle.material,
        fontFamily: 'BeVietnamPro',
      ).toTheme.copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
                TargetPlatform.fuchsia: FadeThroughPageTransitionsBuilder(),
                TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
                TargetPlatform.macOS: FadeThroughPageTransitionsBuilder(),
                TargetPlatform.windows: FadeThroughPageTransitionsBuilder(),
              },
            ),
            visualDensity: VisualDensity.comfortable,
          ),
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Focus.of(context).unfocus(),
        child: child,
      ),
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

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}
