import 'package:flutter/material.dart';

class CustomTextFormFieldOptional extends StatelessWidget {
  const CustomTextFormFieldOptional(
      {Key? key,
      required TextEditingController controller,
      required String txtLabelOptional})
      : _controller = controller,
        _txtLabelOptional = txtLabelOptional,
        super(key: key);

  final TextEditingController _controller;
  final String _txtLabelOptional;

  /// This function returns a TextFormField widget for entering numbers with validation for non-negative
  /// values.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in the `build` method of a Flutter widget
  /// represents the location of the widget within the widget tree. It provides access to various
  /// properties and methods related to the widget's location and configuration in the UI hierarchy.
  ///
  /// Returns:
  ///   The `build` method is returning a `TextFormField` widget with a controller, keyboardType,
  /// decoration, and validator. The validator function checks if the input value is not empty, then tries
  /// to parse it as a double. If the parsing is successful, it checks if the number is negative and
  /// returns an error message accordingly. If the input value is empty or can't be parsed as a double,
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(_txtLabelOptional),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final double? number = double.tryParse(value);
          if (number == null) {
            return '$_txtLabelOptional musí být číslo';
          }
          if (number < 0) {
            return '$_txtLabelOptional nesmí být záporný';
          }
        }
        return null;
      },
    );
  }
}
