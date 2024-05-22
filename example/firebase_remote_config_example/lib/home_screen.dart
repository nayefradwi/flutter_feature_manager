import 'package:flutter/material.dart';
import 'package:flutter_feature_manager/flutter_feature_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen'),
            FeatureBuilder(
              featureKey: 'is_feature_enabled',
              builder: (context, value) {
                if (value == null) return const SizedBox();
                return Text('Feature is enabled: $value');
              },
            )
          ],
        ),
      ),
    );
  }
}
