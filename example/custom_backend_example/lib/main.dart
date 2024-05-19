import 'package:custom_backend_example/app.dart';
import 'package:custom_backend_example/feature_manager.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final featureManager = createFeatureManager();
  runApp(MyApp(featureManager: featureManager));
}
