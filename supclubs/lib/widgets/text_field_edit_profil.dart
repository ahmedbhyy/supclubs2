import 'package:flutter/material.dart';

class TextFieldEdit extends StatelessWidget {
  final String hint;
  final String? mytext;
  final Icon myicon;
  final String? Function(String?) validator;
  final bool readonly;
  final int? lines;
  final TextInputType input;
  final String? suffixtext;

  final TextEditingController? mycontroller;
  const TextFieldEdit(
      {super.key,
      required this.hint,
      this.mycontroller,
      required this.myicon,
      required this.readonly,
      this.suffixtext,
      this.mytext,
      this.lines,
      required this.input, required this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: mycontroller,
        maxLines: lines,
        enabled: readonly,
        keyboardType: input,
        validator: validator,
        decoration: InputDecoration(
          labelText: hint,
          prefixText: mytext,
          prefixIcon: myicon,
          prefixIconColor: Colors.grey[800],
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 1, 81, 70),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 236, 213, 4), width: 2),
          ),
        ),
      ),
    );
  }
}
