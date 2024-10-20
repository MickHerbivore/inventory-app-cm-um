import 'package:flutter/material.dart';

class InputSearch extends StatelessWidget {
  final String text;
  final TextEditingController? inputController;
  final Function(String) onChanged;

  const InputSearch({
    super.key,
    required this.text,
    this.inputController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200], 
        hintText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: onChanged,
    );
  }
}