import 'package:flutter/material.dart';

class PlaceTitleField extends StatelessWidget {
  const PlaceTitleField({required this.onSaved, super.key});

  final ValueSetter<String?> onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 100,
      keyboardType: TextInputType.text,
      style: Theme.of(context).textTheme.titleSmall,
      decoration: InputDecoration(
        label: Text(
          'Title',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      validator: (value) {
        final trimmedValue = value?.trim();

        if (trimmedValue == null || trimmedValue.length <= 1) {
          return 'Title must be more than one character';
        }

        return null;
      },
      onSaved: onSaved,
    );
  }
}
