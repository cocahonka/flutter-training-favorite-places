import 'package:favorite_places/scopes/places_scope.dart';
import 'package:favorite_places/widgets/places/place_title_field.dart';
import 'package:flutter/material.dart';

class NewPlaceScreen extends StatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  State<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends State<NewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _enteredTitle;

  void _saveForm() {
    final formState = _formKey.currentState!;
    if (formState.validate()) {
      formState.save();

      PlacesScope.of(context, listen: false).addPlace(title: _enteredTitle);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add new Place',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Column(
              children: [
                PlaceTitleField(onSaved: (value) => _enteredTitle = value!),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ElevatedButton.icon(
                    onPressed: _saveForm,
                    icon: const Icon(Icons.add),
                    label: Text(
                      'Add Place',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
