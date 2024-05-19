import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feature_manager/src/domain/feature.dart';

class FeatureListItemField extends StatelessWidget {
  final dynamic value;
  final void Function(dynamic newValue) onChanged;
  const FeatureListItemField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final type = Feature.getTypeOfValue(value);
    if (type == bool) {
      return _FeatureCheckBox(
        bool.tryParse(value.toString()) ?? defaultBool,
        onChanged: onChanged,
      );
    }
    if (type == int || type == double) {
      return _FeatureTextField(
        value.toString(),
        keyboardType: TextInputType.number,
        allowDecimals: type == double,
        onChanged: onChanged,
      );
    }
    return _FeatureTextField(value.toString(), onChanged: onChanged);
  }
}

class _FeatureTextField extends StatefulWidget {
  final String value;
  final TextInputType? keyboardType;
  final bool allowDecimals;
  final void Function(String newValue) onChanged;
  const _FeatureTextField(
    this.value, {
    required this.onChanged,
    this.keyboardType,
    this.allowDecimals = false,
  });

  @override
  State<_FeatureTextField> createState() => _FeatureTextFieldState();
}

class _FeatureTextFieldState extends State<_FeatureTextField> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType,
      controller: controller,
      onChanged: (value) {
        widget.onChanged(value);
      },
      inputFormatters: [
        if (widget.keyboardType == TextInputType.number &&
            !widget.allowDecimals)
          FilteringTextInputFormatter.digitsOnly,
        if (widget.allowDecimals)
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _FeatureCheckBox extends StatelessWidget {
  final bool value;
  final void Function(bool newValue) onChanged;
  const _FeatureCheckBox(this.value, {required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Enabled:'),
        Checkbox(
          value: value,
          onChanged: (value) => onChanged(value ?? false),
        ),
      ],
    );
  }
}
