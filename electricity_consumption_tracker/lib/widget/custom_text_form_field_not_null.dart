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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), label: Text(_txtLabel)),
      validator: (value) => value == null || value.isEmpty
          ? '$_txtLabel nesmí být prázdný'
          : null,
    );
  }
}
