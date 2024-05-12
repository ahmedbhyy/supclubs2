import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:supclubs/auth/sign_in.dart';
import 'package:supclubs/auth/sign_up.dart';

import 'package:supclubs/firebase_options.dart';
import 'package:supclubs/profilscreens/edit_profil.dart';

import 'package:supclubs/screens/Home_page.dart';

import 'package:supclubs/start.dart';
import 'package:supclubs/splashscreens/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   Gemini.init(apiKey: 'AIzaSyAAZ17m1cVs7vrrq32hkuHUWK4xp1d6N4o');

  runApp(const SupClubs());
}

class SupClubs extends StatefulWidget {
  const SupClubs({super.key});

  @override
  State<SupClubs> createState() => _GothomhHackState();
}

class _GothomhHackState extends State<SupClubs> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        return;
      } else {
        return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade700)),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? const StartScreens()
          : const OnBoarding(),
      routes: {
        "SignIn": (context) => const SignIn(),
        "SignUp": (context) => const SignUp(),
        "HomePage": (context) => const HomePage(),
        "onbording": (context) => const OnBoarding(),
        "start": (context) => const StartScreens(),
        "editprofil": (context) => const EditProfil(),
      },
    );
  }
}
