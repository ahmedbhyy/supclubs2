import 'package:flutter/material.dart';

class TextFieldWorkshops extends StatelessWidget {
  final String hint;
  final String? Function(String?) validator;
  final TextInputType? input;

  final TextEditingController? mycontroller;
  const TextFieldWorkshops({
    super.key,
    required this.hint,
    this.mycontroller,
    required this.validator,
    required this.input,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: mycontroller,
        maxLines: 1,
        validator: validator,
        keyboardType: input,
        decoration: InputDecoration(
          labelText: hint,
          prefixIcon: const Icon(Icons.description_outlined),
          prefixIconColor: Colors.grey[800],
          labelStyle: const TextStyle(
              color: Color.fromARGB(255, 1, 81, 70), fontSize: 17),
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
