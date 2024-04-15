import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lottie/lottie.dart';
import 'package:supclubs/profilscreens/widget_profil/alertexit.dart';

import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:intl/intl.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';

import 'package:supclubs/widgets/text_field_edit_profil.dart';
import 'package:toggle_switch/toggle_switch.dart';

const List<String> list = <String>['INDP1', 'INDP2', 'INDP3', 'OTHER'];

class EditProfil extends StatefulWidget {
  const EditProfil({
    super.key,
  });

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final TextEditingController username = TextEditingController();
  final TextEditingController phone = TextEditingController();

  String dropdownValue = list[0];
  bool _isLoading = false;
  bool issaved = false;
  String _imageFile = '';
  final ImagePicker _picker = ImagePicker();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  late User _user;

  final useremail = FirebaseAuth.instance.currentUser!.email;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? creationTime;
  String? date;
  String? token;
  bool isexist = false;

  final formatter = DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    _user = _auth.currentUser!;
    UserMetadata metadata = _user.metadata;
    creationTime = metadata.creationTime!;
    fetchUserData();
    date = formatter.format(creationTime!);
    fetchProfileImage();
    indexlist();

    super.initState();
  }

  void fetchProfileImage() {
    final store = FirebaseStorage.instance.ref();
    final newprofilpic = FirebaseAuth.instance.currentUser!.uid;
    final pdpref = store.child("profil/$newprofilpic.jpg");
    try {
      pdpref.getDownloadURL().then((value) {
        setState(() {
          _imageFile = value;
        });
      }, onError: (val) {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "une erreur est survenue lors de l'importation du l'image veuillez réessayer ultérieurement")));
    }
  }

  Future<void> fetchUserData() async {
    try {
      _isLoading = true;
      setState(() {});
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(_user.uid).get();
      var userData = docSnapshot.data();

      if (docSnapshot.exists) {
        if (userData is Map<String, dynamic>) {
          setState(() {
            username.text = userData['username'] ?? "";
            phone.text = userData['phone'] ?? "";
            dropdownValue = userData['year'] ?? list[0];
            _isLoading = false;
            isexist = true;
          });
        }
      }
      _isLoading = false;
      setState(() {});
    } catch (e) {
      return;
    }
  }

  indexlist() {
    for (int i = 0; i < list.length; i++) {
      if (list[i] == dropdownValue) {
        return i;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    phone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          if (!isexist) {
            return await alertexit();
          } else {
            return true;
          }
        },
        child: Form(
          key: formState,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            children: [
              const AppBarProfil(
                title: "Edit profil",
                lottie: "images/lottie_home.json",
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const LoadingForData(ver: 3, hor: 2.2, loadingsize: 30)
                  : Column(
                      children: [
                        imageProfile(),
                        const SizedBox(height: 20),
                        TextFieldEdit(
                          hint: "Username",
                          input: TextInputType.name,
                          mycontroller: username,
                          readonly: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Can't to be empty ";
                            }
                            return null;
                          },
                          myicon: Icon(
                            Icons.person_2_outlined,
                            color: Colors.blue[900],
                          ),
                        ),
                        TextFieldEdit(
                          hint: "$useremail",
                          input: TextInputType.emailAddress,
                          suffixtext: "email",
                          readonly: false,
                          validator: (val) {
                            return null;
                          },
                          myicon: Icon(
                            Icons.email_outlined,
                            color: Colors.blue[900],
                          ),
                        ),
                        TextFieldEdit(
                          hint: "Phone number",
                          readonly: true,
                          mytext: "+216 ",
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Can't to be empty ";
                            } else if (val.length != 8) {
                              return "Your Phone number should be equal to 8 numbers! ";
                            }
                            return null;
                          },
                          input: TextInputType.phone,
                          mycontroller: phone,
                          myicon: Icon(
                            Icons.phone_android_outlined,
                            color: Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 30),
                        ToggleSwitch(
                          initialLabelIndex: indexlist(),
                          totalSwitches: 4,
                          animationDuration: 500,
                          customTextStyles: const [
                            TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                          ],
                          activeFgColor: Colors.white,
                          activeBgColor: const [
                            Colors.blue,
                            Colors.amber,
                          ],
                          animate: true,
                          labels: list,
                          onToggle: (index) {
                            dropdownValue = list[index!];
                          },
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 250,
                          child: MaterialButton(
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            elevation: 7,
                            onPressed: () async {
                              if (formState.currentState!.validate()) {
                                saveUserData();
                              } else {}
                            },
                            color: const Color.fromARGB(255, 49, 95, 175),
                            child: Text(
                              "Save",
                              style: GoogleFonts.aladin(
                                  fontSize: 28,
                                  fontStyle: FontStyle.italic,
                                  color:
                                      const Color.fromARGB(255, 228, 170, 11)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Joined ",
                              style: GoogleFonts.aladin(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: const Color.fromARGB(255, 38, 28, 1)),
                            ),
                            Text(
                              "$date",
                              style: GoogleFonts.aladin(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: const Color.fromARGB(255, 3, 95, 223)),
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveUserData() async {
    try {
      String nomuser = username.text;
      String number = phone.text;
      String year1 = dropdownValue;
      DocumentSnapshot userDataSnapshot =
          await _firestore.collection('users').doc(_user.uid).get();
      if (userDataSnapshot.exists) {
        await _firestore.collection('users').doc(_user.uid).set({
          'username': nomuser,
          'phone': number,
          'year': year1,
        }, SetOptions(merge: true));
      } else {
        await _firestore.collection('users').doc(_user.uid).set({
          'username': nomuser,
          'phone': number,
          'year': year1,
          'role': "user",
          'clubid': 'normaluser',
          'admin': false,
          'clubimage': 'nothing',
          'appvote': 0.0,
        }, SetOptions(merge: true));
      }

      setState(() {
        AwesomeDialog(
          context: context,
          dismissOnTouchOutside: false,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'User Data Saved!',
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 228, 170, 11),
            fontSize: 25,
          ),
          desc: 'Your data has been saved succeffully',
          descTextStyle: const TextStyle(fontSize: 17),
          btnOkColor: Colors.blue[900],
          btnOkText: 'Okay',
          btnOkOnPress: () {
            if (userDataSnapshot.exists) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("start", (route) => false);
            }
          },
        ).show();
      });
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error Please Try again!"),
        ),
      );
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.camera,
                color: Colors.blue[800],
              ),
              onPressed: () async {
                await takePhoto2(ImageSource.camera);
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image, color: Colors.blue[800]),
              onPressed: () async {
                await takePhoto2(ImageSource.gallery);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage:
              _imageFile.isNotEmpty ? NetworkImage(_imageFile) : null,
          backgroundColor: Colors.white,
          child: _imageFile.isNotEmpty
              ? null
              : Lottie.asset("images/lottie_edit.json", height: 200),
        ),
        Positioned(
          bottom: 15.0,
          right: 5.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: const Icon(
              Icons.camera_alt,
              color: Color.fromARGB(255, 125, 129, 144),
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );

    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile.path;
        Navigator.pop(context);
      }
    });
  }

  Future<void> takePhoto2(ImageSource source) async {
    final newprofilpic = FirebaseAuth.instance.currentUser!.uid;

    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 20,
    );

    if (pickedFile != null) {
      String path = pickedFile.path;
      File file = File(path);
      final store = FirebaseStorage.instance.ref();
      final pdpref = store.child("profil/$newprofilpic.jpg");

      try {
        await pdpref.putFile(file);
        String url = await pdpref.getDownloadURL();
        setState(() {
          _imageFile = url;
        });
      } catch (e) {
        return;
      }
    }
  }
}
