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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), label: Text(_txtLabelOptional)),
    );
  }
}
