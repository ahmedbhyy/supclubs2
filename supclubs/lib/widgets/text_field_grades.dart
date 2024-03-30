import 'package:flutter/material.dart';

class TextFieldGrades extends StatelessWidget {
  final String hint;

  final String? suffixtext;

  final TextEditingController? mycontroller;
  const TextFieldGrades({
    super.key,
    required this.hint,
    this.mycontroller,
    this.suffixtext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: mycontroller,
        maxLines: 1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: hint,
          suffixText: "/20",
          prefixIcon: const Icon(Icons.grade),
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
