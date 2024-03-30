import 'package:flutter/material.dart';
import 'package:supclubs/widgets/buttton_auth.dart';
import 'package:supclubs/widgets/same_text_semester.dart';
import 'package:supclubs/widgets/text_field_grades.dart';

class IndpOneSemTwo extends StatelessWidget {
  const IndpOneSemTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      children: [
        const SameTextSemester(
          title: "* Réseaux IP :",
        ),
        const TextFieldGrades(
          hint: "(DS) Routage et Commutation dans les réseaux",
        ),
        const TextFieldGrades(
          hint: "(EX) Routage et Commutation dans les réseaux",
        ),
        const TextFieldGrades(
          hint: "Pratique réseaux",
        ),
        const SameTextSemester(
          title: "* Optimisation et Signal  :",
        ),
        const TextFieldGrades(
          hint: "(DS) Recherche opérationnelle",
        ),
        const TextFieldGrades(
          hint: "(DS) Traitement du signal	",
        ),
        const TextFieldGrades(
          hint: "(EX) Optimisation convexe",
        ),
        const SameTextSemester(
          title: "* Management et projets sociétaux:",
        ),
        const TextFieldGrades(
          hint: "(EX) Management des projets",
        ),
        const TextFieldGrades(
          hint: "(Atelier) Management de projets",
        ),
        const TextFieldGrades(
          hint: "(Atelier) Pacte",
        ),
        const SameTextSemester(
          title: "* Techniques de communications II:",
        ),
        const TextFieldGrades(
          hint: "(DS) Anglais II",
        ),
        const TextFieldGrades(
          hint: "(Atelier) Anglais II",
        ),
        const TextFieldGrades(
          hint: "(Atelier) Séminaires d'ouverture",
        ),
        const TextFieldGrades(
          hint: "(EX) Français II	",
        ),
        const SameTextSemester(
          title: "* Technologies de traitement embarqué de l’information :",
        ),
        const TextFieldGrades(
          hint: "(DS) Processors and Programmable Logic",
        ),
        const TextFieldGrades(
          hint: "(EX) Processors and Programmable Logic",
        ),
        const TextFieldGrades(
          hint: "(DS) Antennes",
        ),
        const TextFieldGrades(
          hint: "(EX) Théorie de l’information et Codage",
        ),
        const SameTextSemester(
          title: "* Bases de données et système:",
        ),
        const TextFieldGrades(
          hint: "(DS) Conception des bases de données relationnelles",
        ),
        const TextFieldGrades(
          hint: "Programmation Orienté Objet (C++)",
        ),
        const TextFieldGrades(
          hint: "(EX) Linux et programmation système",
        ),
        const SizedBox(height: 30),
        ButtonAuth(
          mytitle: "Save",
          myfunction: () {},
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
