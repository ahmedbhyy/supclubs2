import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/widgets/buttton_auth.dart';
import 'package:supclubs/widgets/cards/text_field_workshop.dart';

class AddWorkshop extends StatefulWidget {
  final String name;
  const AddWorkshop({super.key, required this.name});

  @override
  State<AddWorkshop> createState() => _AddWorkshopState();
}

class _AddWorkshopState extends State<AddWorkshop> {
  File? selectedFile;
  TextEditingController titleController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    Future<void> pickPDF() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'svg', 'jpg', 'png'],
        );

        if (result != null) {
          selectedFile = File(result.files.single.path!);
          setState(() {});
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.blue[800],
              content: const Text(
                'No file selected',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue[800],
            content: const Text(
              'No file selected',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }

    Future<void> uploadToFirebase() async {
      isloading = true;
      if (selectedFile != null) {
        try {
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('workshops/${DateTime.now()}.pdf');
          UploadTask uploadTask = storageReference.putFile(selectedFile!);
          isloading = false;
          TaskSnapshot snapshot =
              await uploadTask.whenComplete(() => AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.rightSlide,
                    title: 'File saved successfully',
                    titleTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 25,
                    ),
                    desc: 'Your workshops has been added successfully',
                    descTextStyle: const TextStyle(fontSize: 18),
                    btnOkOnPress: () {
                      Navigator.pop(context);
                    },
                  ).show());

          String downloadURL = await snapshot.ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('${widget.name}workshops')
              .add({
            'title': titleController.text,
            'place': placeController.text,
            'date': dateController.text,
            'time': timeController.text,
            'pdf': downloadURL,
            'image':
                "https://www.numerama.com/wp-content/uploads/2022/06/article-pdf.jpg"
          });

          titleController.clear();
          placeController.clear();
          dateController.clear();
          timeController.clear();
        } catch (e) {
          return;
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formState,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          children: [
            const AppBarProfil(
              title: "Add Workshop",
              lottie: "images/lottie_workshop.json",
            ),
            InkWell(
              onTap: () async {
                await pickPDF();
              },
              child: selectedFile != null
                  ? Column(
                      children: [
                        const SizedBox(height: 30),
                        const Icon(
                          Icons.file_copy,
                          size: 50,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "File Selected",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () async {
                                await pickPDF();
                              },
                              child: const Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(children: [
                      Lottie.asset("images/lottie_pdf.json", height: 250),
                      const Text(
                        "Click here",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
            ),
            const SizedBox(height: 40),
            TextFieldWorkshops(
              hint: "Workshop Title",
              mycontroller: titleController,
              input: TextInputType.text,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Can't to be empty ";
                }
                return null;
              },
            ),
            TextFieldWorkshops(
              hint: "Workshop Place",
              mycontroller: placeController,
              input: TextInputType.text,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Can't to be empty ";
                }
                return null;
              },
            ),
            TextFieldWorkshops(
              hint: "Workshop Date",
              mycontroller: dateController,
              input: TextInputType.datetime,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Can't to be empty ";
                }
                return null;
              },
            ),
            TextFieldWorkshops(
              hint: "Workshop Time",
              input: TextInputType.datetime,
              mycontroller: timeController,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Can't to be empty ";
                }
                return null;
              },
            ),
            const SizedBox(height: 50),
            ButtonAuth(
              mytitle: "Send",
              myfunction: () async {
                if (formState.currentState!.validate()) {
                  await uploadToFirebase();
                } else {}
              },
            ),
          ],
        ),
      ),
    );
  }
}
