import 'package:flutter/material.dart';
import 'package:supclubs/widgets/buttton_auth.dart';
import 'package:supclubs/widgets/same_text_semester.dart';
import 'package:supclubs/widgets/text_field_grades.dart';

class IndpTwoSemTwo extends StatelessWidget {
  const IndpTwoSemTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      children: [
        const SameTextSemester(
            title: "* aaaaSystémes de communication haut-débit :"),
        const TextFieldGrades(hint: "(DS) Composants et Systémes Language"),
        const TextFieldGrades(hint: "(EX) Composants et Systémes Language"),
        const TextFieldGrades(hint: "(DS) Transmission numérique"),
        const TextFieldGrades(hint: "(EX) Transmission numérique"),
        const SameTextSemester(title: "* Conception et Développement Mobile :"),
        const TextFieldGrades(hint: "(EX) Unified Modeling Language"),
        const TextFieldGrades(hint: "(EX) Projet Développement Web et Mobile"),
        const TextFieldGrades(
            hint: "(Atelier) Projet Développement Web et Mobile"),
        const TextFieldGrades(hint: "Technologies Web"),
        const SameTextSemester(title: "* Réseaux sans fil et Mobiles :"),
        const TextFieldGrades(
            hint: "(EX) Propagation multitrajets et diversités"),
        const TextFieldGrades(
            hint: "(EX) Fondaments et architectures des réseaux cellulaires "),
        const TextFieldGrades(hint: "(EX) WLAN & Réseaux IP étendus"),
        const SameTextSemester(title: "* Eléments des sciences de données :"),
        const TextFieldGrades(hint: "(DS) Inférence statistiques"),
        const TextFieldGrades(hint: "(EX) Inférence statistiques"),
        const TextFieldGrades(hint: "(Atelier) Atelier d'optimisation"),
        const TextFieldGrades(hint: "(EX) Ingénierie des données"),
        const SameTextSemester(title: "* Entrepreneuriat et Finance:"),
        const TextFieldGrades(hint: "(EX) Comptabilité financiére"),
        const TextFieldGrades(hint: "(Atelier) Comptabilité financiére"),
        const TextFieldGrades(hint: "(EX) Finances d'Entreprise"),
        const TextFieldGrades(hint: "(Atelier) Culture Entrepreneuriale"),
        const SameTextSemester(title: "* Techniques de communications :"),
        const TextFieldGrades(hint: "Français"),
        const TextFieldGrades(hint: "Anglais I"),
        const TextFieldGrades(hint: "(Atelier) Anglais"),
        const TextFieldGrades(
            hint: "(Atelier) Séminaires d'ouverture (Français)"),
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
