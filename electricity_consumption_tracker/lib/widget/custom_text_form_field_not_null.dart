import 'package:flutter/material.dart';

class CustomTextFormFieldNotNull extends StatelessWidget {
  const CustomTextFormFieldNotNull(
      {Key? key,
      required TextEditingController controller,
      required String txtLabel})
      : _controller = controller,
        _txtLabel = txtLabel,
        super(key: key);

  final TextEditingController _controller;
  final String _txtLabel;

  /// This function returns a TextFormField widget for entering numbers with validation checks for
  /// non-empty, numeric, and non-negative values.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in the `build` method of a Flutter widget
  /// represents the location of the widget within the widget tree. It provides access to various
  /// properties and services higher up in the widget hierarchy.
  ///
  /// Returns:
  ///   The `build` method is returning a `TextFormField` widget with specific configurations. The
  /// `validator` property of the `TextFormField` is set to a function that checks the input value. If
  /// the value is empty, not a number, or a negative number, it returns an error message specific to the
  /// input field label. If none of these conditions are met, it returns `null`, indicating
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(_txtLabel),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$_txtLabel nesmí být prázdný';
        }
        final double? number = double.tryParse(value);
        if (number == null) {
          return '$_txtLabel musí být číslo';
        }
        if (number < 0) {
          return '$_txtLabel nesmí být záporný';
        }
        return null;
      },
    );
  }
}
