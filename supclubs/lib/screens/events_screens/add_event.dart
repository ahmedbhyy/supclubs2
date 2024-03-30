import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';
import 'package:supclubs/widgets/text_field_edit_profil.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddEvent extends StatefulWidget {
  final String userid;
  const AddEvent({super.key, required this.userid});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  TextEditingController eventtitle = TextEditingController();
  TextEditingController eventplace = TextEditingController();
  TextEditingController eventdate = TextEditingController();
  TextEditingController eventtime = TextEditingController();
  TextEditingController eventdescription = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController eventurl = TextEditingController();

  var imageFile;
  bool isloading = false;

  String? imageUrl;
  List<String> yesno = ["No", "Yes"];
  String Registraition = "No";
  @override
  void initState() {
    super.initState();
  }

  sendnotificationTopic(
      String title, String description, String imageevent) async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAA-4IaKIM:APA91bH9tmr9HS-Yjojlk9pdu-VskhNUOkJQgDsGCSCDzge80SJm2Qtny6W18tOenem2xe3azvn-cBjvpewsVPV9RaOZcHytYO310cykbCQFS2h-WhjaTCEVoVYWvTaa1iiIgJrSp7a-'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": "/topics/events",
      "notification": {
        "title": title,
        "body": description,
        "image": imageevent,
      },
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return;
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formState,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          children: [
            const AppBarProfil(
              title: "Add Event",
              lottie: "images/lottie_animation4.json",
            ),
            isloading
                ? LoadingForData(ver: 20, hor: 20, loadingsize: 20)
                : CircleAvatar(
                    radius: 100.0,
                    backgroundColor: Colors.blue[500],
                    backgroundImage: imageFile != null
                        ? FileImage(imageFile!)
                        : imageUrl != null
                            ? NetworkImage(imageUrl!) as ImageProvider<Object>?
                            : null,
                    child: InkWell(
                      onTap: () async {
                        await _pickImage();
                      },
                      child: imageFile != null
                          ? Container()
                          : DecoratedBox(
                              decoration: BoxDecoration(
                                image: imageUrl != null
                                    ? DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(imageUrl!),
                                      )
                                    : null,
                              ),
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.amber[800],
                                size: 70,
                              ),
                            ),
                    ),
                  ),
            TextFieldEdit(
              hint: "Event Title",
              mycontroller: eventtitle,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Can't to be empty ";
                }
                return null;
              },
              myicon: const Icon(Icons.title),
              input: TextInputType.text,
              readonly: true,
            ),
            TextFieldEdit(
              hint: "Event Place",
              mycontroller: eventplace,
              validator: (val) {
                if (val == null || val.isEmpty || val.length > 10) {
                  return "Can't to be empty ";
                }
                return null;
              },
              myicon: const Icon(Icons.place),
              input: TextInputType.text,
              readonly: true,
            ),
            TextFieldEdit(
              hint: "Event Url",
              mycontroller: eventurl,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Can't to be empty ";
                }
                return null;
              },
              myicon: const Icon(Icons.link),
              input: TextInputType.text,
              readonly: true,
            ),
            TextFieldEdit(
              hint: "Event Date",
              mycontroller: eventdate,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Can't to be empty ";
                }
                return null;
              },
              myicon: const Icon(Icons.date_range),
              input: TextInputType.datetime,
              readonly: true,
            ),
            TextFieldEdit(
              hint: "Event Time",
              mycontroller: eventtime,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Can't to be empty ";
                }
                return null;
              },
              myicon: const Icon(Icons.timer),
              input: TextInputType.datetime,
              readonly: true,
            ),
            TextFieldEdit(
              hint: "Event Description",
              mycontroller: eventdescription,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Can't to be empty ";
                }
                return null;
              },
              myicon: const Icon(Icons.description_outlined),
              input: TextInputType.text,
              readonly: true,
              lines: 2,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Registraition ?",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                ToggleSwitch(
                  initialLabelIndex: 0,
                  totalSwitches: 2,
                  animationDuration: 500,
                  customTextStyles: [
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                  ],
                  activeFgColor: Colors.white,
                  activeBgColor: [
                    Colors.blue,
                    Colors.amber,
                  ],
                  animate: true,
                  labels: yesno,
                  onToggle: (index) {
                    Registraition = yesno[index!];
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: MaterialButton(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                elevation: 7,
                onPressed: () async {
                  if (formState.currentState!.validate()) {
                    String imageUrl = await uploadImageToStorage();
                    addEventToFirestore(
                      eventtitle.text,
                      eventdate.text,
                      eventplace.text,
                      eventtime.text,
                      eventdescription.text,
                      imageUrl,
                      eventurl.text,
                    );
                    await sendnotificationTopic(
                        eventtitle.text,
                        "${eventdate.text} / ${eventtime.text} (${eventplace.text})",
                        imageUrl);
                  }
                },
                color: const Color.fromARGB(255, 49, 95, 175),
                child: Text(
                  "Add",
                  style: GoogleFonts.aladin(
                    fontSize: 28,
                    fontStyle: FontStyle.italic,
                    color: const Color.fromARGB(255, 228, 170, 11),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        return;
      }
    });
  }

  Future<String> uploadImageToStorage() async {
    if (imageFile != null) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('event_images/${DateTime.now().toString()}');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      // ignore: avoid_print
      await uploadTask.whenComplete(() => print('Image uploaded to storage'));

      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } else {
      return "https://groupgordon.com/wp-content/uploads/2022/04/Messe_Luzern_Corporate_Event.jpg";
    }
  }

  Future<void> addEventToFirestore(String name, String date, String place,
      String time, String description, String imageUrl, String url) async {
    try {
      isloading = true;
      setState(() {});
      await FirebaseFirestore.instance.collection('events').add(
        {
          'title': name,
          'url': url.isEmpty
              ? "https://www.facebook.com/profile.php?id=100089856585334"
              : url,
          'date': date,
          'place': place,
          'userid': widget.userid,
          'time': time,
          'register': Registraition,
          'description': description,
          'image': imageUrl.isEmpty
              ? "https://img.freepik.com/premium-vector/events-big-text-online-corporate-party-meeting-friends-colleagues-video-conference_501813-9.jpg"
              : imageUrl,
        },
      );
      isloading = false;
      setState(() {});
      showDialog("Event Data Saved!", "Event data has been saved successfully.",
          DialogType.success);
    } catch (e) {
      showDialog(
          "Event Data not saved!", "Please try again later.", DialogType.error);
    }
  }

  void showDialog(String title, String desc, DialogType type) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.bottomSlide,
      title: title,
      titleTextStyle: const TextStyle(
        color: Color.fromARGB(255, 228, 170, 11),
        fontSize: 25,
      ),
      desc: desc,
      descTextStyle: const TextStyle(fontSize: 17),
      btnOkColor: Colors.blue[900],
      btnOkText: 'Okay',
      btnOkOnPress: () {
        if (!context.mounted) return;
        Navigator.pop(context, true);
      },
    ).show();
  }
}
