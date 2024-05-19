import 'package:custom_backend_example/feature_manager.dart';
import 'package:custom_backend_example/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';

class MyApp extends StatelessWidget {
  final IFeatureManager featureManager;
  const MyApp({super.key, required this.featureManager});

  @override
  Widget build(BuildContext context) {
    return FeatureManagerProvider(
      manager: featureManager,
      child: FeatureBuilderWithDefault<bool>(
        defaultValue: false,
        featureKey: isDarkModeKey,
        builder: (context, isDarkMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Custom Backend Demo',
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            darkTheme: ThemeData.dark(useMaterial3: true),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
