import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config_example/app.dart';
import 'package:firebase_remote_config_example/feature_manager.dart';
import 'package:firebase_remote_config_example/firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final fm = createFeatureManager();
  runApp(MyApp(featureManager: fm));
}
