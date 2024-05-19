import 'package:flutter/material.dart';

class FeatureListItemField extends StatelessWidget {
  final dynamic value;
  const FeatureListItemField({required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    if (value is String) return _StringFeatureField(value as String);
    return const SizedBox();
  }
}

class _StringFeatureField extends StatefulWidget {
  final String value;
  const _StringFeatureField(this.value);

  @override
  State<_StringFeatureField> createState() => _StringFeatureFieldState();
}

class _StringFeatureFieldState extends State<_StringFeatureField> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
    );
  }
}
