import 'package:flutter/material.dart';

class TextFieldAuth extends StatelessWidget {
  final String hint;
  final Icon myicon;
  final bool ispass;
  final String? Function(String?)? validator;
  final GestureDetector? mysuffixicon;
  final TextEditingController mycontroller;
  const TextFieldAuth(
      {super.key,
      required this.hint,
      required this.mycontroller,
      required this.myicon,
      this.mysuffixicon,
      required this.ispass, required this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: mycontroller,
        obscureText: ispass,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: hint,
          suffixIcon: mysuffixicon,
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
        validator: validator,
      ),
    );
  }
}
