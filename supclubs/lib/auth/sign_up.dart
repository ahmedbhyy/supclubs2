// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/auth/sign_in.dart';

import 'package:supclubs/widgets/buttton_auth.dart';
import 'package:supclubs/widgets/slides/slide_left.dart';
import 'package:supclubs/widgets/textfield_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  final email = TextEditingController();
  bool isloading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  bool isPasswordHidden2 = true;
  String? validatePassword(String? value) {
    if (value != password.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.green,
                Colors.orange,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Form(
            key: formState,
            child: isloading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 900),
                        child: Lottie.asset("images/lottie_animation3.json",
                            height: 220),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Text(
                          "Ready to join us",
                          style: GoogleFonts.belleza(
                              fontSize: 30,
                              color: const Color(0xff353392),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1100),
                        child: Text(
                          "Please enter your register credentials below",
                          style: GoogleFonts.mulish(
                              fontSize: 15,
                              color: const Color(0xff565656),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: TextFieldAuth(
                          hint: "Email",
                          myicon: const Icon(Icons.email_outlined),
                          mycontroller: email,
                          ispass: false,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Email can't be empty";
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(val)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: TextFieldAuth(
                          myicon: const Icon(Icons.key),
                          hint: "Password",
                          mycontroller: password,
                          ispass: isPasswordHidden,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter a password';
                            } else if (val.length < 8) {
                              return 'Weak password';
                            }
                            return null;
                          },
                          mysuffixicon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                            child: Icon(
                              isPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: TextFieldAuth(
                          myicon: const Icon(Icons.key),
                          hint: "Confirm Password",
                          mycontroller: confirmpassword,
                          validator: validatePassword,
                          ispass: isPasswordHidden2,
                          mysuffixicon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordHidden2 = !isPasswordHidden2;
                              });
                            },
                            child: Icon(
                              isPasswordHidden2
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1500),
                        child: ButtonAuth(
                          myfunction: () async {
                            if (!formState.currentState!.validate()) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'ERROR',
                                desc: 'Passwords do not match',
                              ).show();
                            }
                            if (formState.currentState!.validate()) {
                              isloading = true;
                              setState(() {});
                              try {
                                // ignore: unused_local_variable
                                final credential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                                FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification();
                                isloading = false;
                                setState(() {});
                                AwesomeDialog(
                                  context: context,
                                  dismissOnTouchOutside: false,
                                  dialogType: DialogType.success,
                                  animType: AnimType.rightSlide,
                                  title: 'Verify Your Account',
                                  btnOkOnPress: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed("SignIn");
                                  },
                                  desc:
                                      'An email was send to you. Please verify your Account and sign in',
                                ).show();
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'ERROR',
                                    desc: 'The password provided is too weak.',
                                  ).show();
                                } else if (e.code == 'email-already-in-use') {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'ERROR',
                                    desc:
                                        'The account already exists for that email.',
                                  ).show();
                                }
                              } catch (e) {
                                return;
                              }
                            }
                          },
                          mytitle: "Sign up",
                        ),
                      ),
                      const SizedBox(height: 25),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1600),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already a Member? ",
                              style: GoogleFonts.mulish(
                                fontSize: 17,
                                color: const Color(0xff4D4D4D),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  SlideLeft(
                                    page: const SignIn(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign in",
                                style: GoogleFonts.mulish(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff353392),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1700),
                        child: Image.asset(
                          "images/supcom.png",
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
