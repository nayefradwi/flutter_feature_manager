import 'package:custom_backend_example/feature_manager.dart';
import 'package:custom_backend_example/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final featureManager = createFeatureManager();
  runApp(
    MyApp(
      featureManager: featureManager,
    ),
  );
}

class MyApp extends StatelessWidget {
  final IFeatureManager featureManager;
  const MyApp({super.key, required this.featureManager});

  @override
  Widget build(BuildContext context) {
    return FeatureManagerProvider(
      manager: featureManager,
      child: MaterialApp(
        title: 'Custom Backend Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
