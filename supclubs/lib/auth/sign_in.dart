// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/auth/sign_up.dart';
import 'package:supclubs/profilscreens/widget_profil/alertexit.dart';

import 'package:supclubs/widgets/buttton_auth.dart';
import 'package:supclubs/widgets/slides/slide_right.dart';
import 'package:supclubs/widgets/textfield_auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final password = TextEditingController();

  final email = TextEditingController();
  bool isloading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  Future<UserCredential?> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success &&
          loginResult.accessToken != null) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        Navigator.of(context)
            .pushNamedAndRemoveUntil("start", (route) => false);
        return userCredential;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return Get.rawSnackbar(
            title: "Google Sign in", message: "no account selected ");
      } else {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        isloading = true;
        setState(() {});
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        if (FirebaseAuth.instance.currentUser != null) {
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

          if (userSnapshot.exists) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("start", (route) => false);
          } else {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("editprofil", (route) => false);
          }
        }
      }
    } catch (e) {
      isloading = false;
      setState(() {});
      return Get.rawSnackbar(title: "Error", message: "Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? Center(
              child: LoadingAnimationWidget.inkDrop(
                color: const Color.fromARGB(255, 9, 171, 220),
                size: 70,
              ),
            )
          // ignore: deprecated_member_use
          : WillPopScope(
              onWillPop: () async {
                return await alertexit();
              },
              child: Form(
                key: formState,
                child: SafeArea(
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
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      children: [
                        FadeInUp(
                          duration: const Duration(milliseconds: 900),
                          child: Lottie.asset("images/lottie_animation3.json",
                              height: 220, repeat: false),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: Text(
                            "Welcome Back",
                            style: GoogleFonts.belleza(
                                fontSize: 30,
                                color: const Color(0xff353392),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1100),
                          child: Text(
                            "Please enter your login credentials below",
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
                                return "Can't to be empty ";
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
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 2),
                            child: InkWell(
                              onTap: () async {
                                if (email.text == "" || email.text.isEmpty) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'ERROR',
                                    desc:
                                        'Email is empty. Please write your Email',
                                  ).show();
                                  return;
                                }
                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: email.text);
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    animType: AnimType.rightSlide,
                                    title: 'Reset Password',
                                    desc:
                                        'An email was send to you. Please Reset your password !',
                                  ).show();
                                } catch (e) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'Email not found. Please try again',
                                  ).show();
                                }
                              },
                              child: Text(
                                "Forget Password?",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[900]),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1500),
                          child: ButtonAuth(
                            myfunction: () async {
                              if (formState.currentState!.validate()) {
                                try {
                                  isloading = true;
                                  setState(() {});
                                  final credential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email.text,
                                          password: password.text);
                                  isloading = false;
                                  setState(() {});
                                  if (credential.user!.emailVerified) {
                                    if (credential.user != null) {
                                      DocumentSnapshot userSnapshot =
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(credential.user!.uid)
                                              .get();

                                      if (userSnapshot.exists) {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                "start", (route) => false);
                                      } else {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                "editprofil", (route) => false);
                                      }
                                    }
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.rightSlide,
                                      title: 'Verify Your Account',
                                      desc:
                                          'An email was send to you. Please verify your Account',
                                    ).show();
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'ERROR',
                                      btnOkOnPress: () {
                                        isloading = false;
                                        setState(() {});
                                      },
                                      desc:
                                          'No user found for that email. Please Sign up',
                                    ).show();
                                  } else if (e.code == 'wrong-password') {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'ERROR',
                                      btnOkOnPress: () {
                                        isloading = false;
                                        setState(() {});
                                      },
                                      desc:
                                          'Wrong password provided for that user.',
                                    ).show();
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'ERROR',
                                      desc:
                                          'Something went wrong .Please try again',
                                      btnOkOnPress: () {
                                        isloading = false;
                                        setState(() {});
                                      },
                                    ).show();
                                  }
                                }
                              } else {}
                            },
                            mytitle: "Sign in",
                          ),
                        ),
                        const SizedBox(height: 25),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Text(
                            "Or continue with",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.mulish(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff666666),
                            ),
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1700),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                iconSize: 55,
                                onPressed: () async {
                                  await signInWithFacebook(context);
                                },
                                icon: const Icon(
                                  Icons.facebook,
                                  color: Colors.blue,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await signInWithGoogle();
                                },
                                child: Image.asset(
                                  "images/google.png",
                                  width: 75,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Not Registred? ",
                                style: GoogleFonts.mulish(
                                  fontSize: 15,
                                  color: const Color(0xff4D4D4D),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    SlideRight(
                                      page: const SignUp(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Create an account",
                                  style: GoogleFonts.mulish(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff353392),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
