import 'package:flutter/material.dart';
import 'package:supclubs/widgets/buttton_auth.dart';
import 'package:supclubs/widgets/same_text_semester.dart';
import 'package:supclubs/widgets/text_field_grades.dart';

class IndpOneSemOne extends StatelessWidget {
  const IndpOneSemOne({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      children: [
        const SameTextSemester(
          title: "* Algorithmique et programmation :",
        ),
        const TextFieldGrades(
          hint: "(DS) Algorithmique et structures de données Avancées",
        ),
        const TextFieldGrades(
          hint: "(EX) Algorithmique et structures de données Avancées",
        ),
        const TextFieldGrades(
          hint: "(EX) Architecture et Système d'exploitation",
        ),
        const TextFieldGrades(
          hint: "Atelier de programmation C",
        ),
        const SameTextSemester(
          title: "* Circuits et Systèmes électroniques et hyperfréquences :",
        ),
        const TextFieldGrades(
          hint: "(EX) Circuits et Fonctions Analogiques/ Numériques",
        ),
        const TextFieldGrades(
          hint: "(Atelier) Circuits et Fonctions Analogiques/ Numériques",
        ),
        const TextFieldGrades(
          hint: "(DS) Hyperfréquences",
        ),
        const TextFieldGrades(
          hint:
              "Projet de circuits et systèmes électroniques et hyperfréquence",
        ),
        const SameTextSemester(
          title: "* Entreprenariat: Management des affaires:",
        ),
        const TextFieldGrades(
          hint: "(EX) Droit des Affaires",
        ),
        const TextFieldGrades(
          hint: "(DS) Macroéconomie",
        ),
        const TextFieldGrades(
          hint: "(Atelier) Macroéconomie",
        ),
        const TextFieldGrades(
          hint: "(DS) Management de l’Entreprise",
        ),
        const TextFieldGrades(
          hint: "(Atelier) Management de l’Entreprise",
        ),
        const SameTextSemester(
          title: "* Fondements des réseaux:",
        ),
        const TextFieldGrades(
          hint:
              "(DS) Architectures et Fonctions des Réseaux de Télécommunication",
        ),
        const TextFieldGrades(
          hint: "(DS) Introduction aux Technologies du monde digital",
        ),
        const TextFieldGrades(
          hint: "(DS) Réseaux Locaux et IP",
        ),
        const SameTextSemester(
          title: "* Mathématiques et Probabilités:",
        ),
        const TextFieldGrades(
          hint: "(DS) Mathématiques pour les TIC",
        ),
        const TextFieldGrades(
          hint: "(DS) Probabilités et processus aléatoires",
        ),
        const TextFieldGrades(
          hint: "(EX) Probabilités et processus aléatoires",
        ),
        const TextFieldGrades(
          hint: "(EX) Théorie du signal",
        ),
        const SameTextSemester(
          title: "* Techniques de communications I:",
        ),
        const TextFieldGrades(
          hint: "(DS) Français I",
        ),
        const TextFieldGrades(
          hint: "(Atelier) Français I",
        ),
        const TextFieldGrades(
          hint: "(EX) Anglais I",
        ),
        const TextFieldGrades(
          hint: "(Atelier) Anglais I",
        ),
        const TextFieldGrades(
          hint: "(Atelier) Séminaires d'ouverture",
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
