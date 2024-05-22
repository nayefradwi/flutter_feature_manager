import 'package:firebase_remote_config_example/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final IFeatureManager featureManager;
  const MyApp({super.key, required this.featureManager});

  @override
  Widget build(BuildContext context) {
    return FeatureManagerProvider(
      manager: featureManager,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(useMaterial3: true),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
