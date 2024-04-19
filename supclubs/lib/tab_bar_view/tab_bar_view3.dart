import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:supclubs/widgets/buttton_auth.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';
import 'package:supclubs/widgets/text_field_edit_profil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TabBarView3 extends StatefulWidget {
  final bool isAdmin;
  final String clubiduser;
  final String usertoken;
  final String clubnameuser;
  final String clubimguser;
  const TabBarView3(
      {super.key,
      required this.clubiduser,
      required this.clubnameuser,
      required this.clubimguser,
      required this.isAdmin,
      required this.usertoken});

  @override
  State<TabBarView3> createState() => _TabBarView3State();
}

class _TabBarView3State extends State<TabBarView3> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController date = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  bool isloading = false;
  List<String> clubsnames = [
    "GDSC",
    "Team sup'com",
    "Junior",
    "Sup'Bike",
    "NATEG",
    "Sup'Music",
    "MLS",
    "SCS Club",
    "IEEE",
    "ACM"
  ];

  List<Map<String, dynamic>> userData = [];

  Future<void> getUserNotifications() async {
    try {
      isloading = true;
      setState(() {});
      DateTime currentDate = DateTime.now();

      DateTime threeDaysAgo = currentDate.subtract(const Duration(days: 5));
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        QuerySnapshot notificationsSnapshot =
            await userDoc.reference.collection('notifications').get();

        userData.clear();

        for (var doc in notificationsSnapshot.docs) {
          DateTime docDate = DateTime.parse(doc['date']);
          if (docDate.isAfter(threeDaysAgo) ||
              docDate.isAtSameMomentAs(threeDaysAgo)) {
            userData.add(doc.data() as Map<String, dynamic>);
          }
        }

        isloading = false;
        setState(() {});
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  List<String> data = [];
  List<String> data1 = [];

  Future<void> getData() async {
    try {
      DocumentSnapshot clubDocument = await FirebaseFirestore.instance
          .collection('clubs')
          .doc(widget.clubiduser)
          .get();

      if (clubDocument.exists) {
        QuerySnapshot membersSnapshot =
            await clubDocument.reference.collection('members').get();

        data.clear();

        for (var doc in membersSnapshot.docs) {
          data.add(doc['idmember']);
        }

        setState(() {});
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  Future<void> addWorkshopToNotifications() async {
    try {
      isloading = true;
      setState(() {});
      if (data.isNotEmpty) {
        QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, whereIn: data)
            .get();

        for (var userDoc in usersSnapshot.docs) {
          data1.add(userDoc['token']);
          DocumentReference userDocRef =
              FirebaseFirestore.instance.collection('users').doc(userDoc.id);

          await userDocRef.collection('notifications').add({
            'title': title.text,
            'details': description.text,
            'time': formattedTime ?? _formatTimeOfDay(selectedTime),
            'clubname': widget.clubnameuser,
            'date': date.text,
            'image': widget.clubimguser,
            'place': place.text,
          });
        }
        addworkshopsToFirestore();
        isloading = false;

        setState(() {});
        showDialoge(
            "Workshops",
            "we have added this workshop to your members schedule",
            DialogType.success);
        funcsendnotification(
            title.text, date.text, "$formattedTime", place.text);
      } else {
        showDialoge("Error", "Please try again later", DialogType.error);
      }
    } catch (e) {
      showDialoge("Error", "Please try again later", DialogType.error);
    }
  }

  funcsendnotification(
      String title1, String date1, String ftime, String place1) async {
    for (int i = 0; i < data1.length; i++) {
      await sendnotification("${widget.clubnameuser} : $title1",
          "$date1 / $ftime , ($place1)", widget.clubimguser, data1[i]);
    }
  }

  Future<void> addworkshopsToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('workshops').add(
        {
          'title': title.text,
          'details': description.text,
          'time': formattedTime ?? _formatTimeOfDay(selectedTime),
          'clubname': widget.clubnameuser,
          'date': date.text,
          'image': widget.clubimguser,
          'place': place.text,
          'comingmembers': [],
        },
      );
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    getData();
    getUserNotifications();
    super.initState();
  }

  String? formattedTime;
  TimeOfDay selectedTime = TimeOfDay.now();
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedS = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (pickedS != null && pickedS != selectedTime) {
      setState(() {
        selectedTime = pickedS;
      });
      formattedTime = _formatTimeOfDay(selectedTime);
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final time = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.white,
      floatingActionButton: widget.isAdmin
          ? Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Form(
                key: formState,
                child: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 500,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                const Text(
                                  '-Add a Workshop-',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.redAccent,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextFieldEdit(
                                  hint: "Workshop title",
                                  myicon:
                                      const Icon(Icons.description_outlined),
                                  readonly: true,
                                  input: TextInputType.text,
                                  mycontroller: title,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Can't to be empty ";
                                    }
                                    return null;
                                  },
                                ),
                                TextFieldEdit(
                                  hint: "Workshop details",
                                  mycontroller: description,
                                  myicon:
                                      const Icon(Icons.description_outlined),
                                  readonly: true,
                                  input: TextInputType.text,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Can't to be empty ";
                                    }
                                    return null;
                                  },
                                ),
                                TextFieldEdit(
                                  hint: "Workshop place",
                                  mycontroller: place,
                                  myicon: const Icon(Icons.place_outlined),
                                  readonly: true,
                                  input: TextInputType.text,
                                  validator: (val) {
                                    if (val == null ||
                                        val.isEmpty ||
                                        val.length > 8) {
                                      return "Can't to be empty ";
                                    }
                                    return null;
                                  },
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2100),
                                          );
                                          if (pickedDate != null) {
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate);
                                            date.text = formattedDate;
                                          }
                                        },
                                        child: TextFieldEdit(
                                          hint: "Date (YYYY-MM-DD)",
                                          myicon: const Icon(
                                              Icons.date_range_outlined),
                                          readonly: false,
                                          mycontroller: date,
                                          input: TextInputType.datetime,
                                          validator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return "Can't to be empty ";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _selectTime(context);
                                        },
                                        iconSize: 30,
                                        icon: const Icon(
                                          Icons.timer,
                                          color:
                                              Color.fromARGB(255, 8, 90, 184),
                                        ))
                                  ],
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: 300,
                                  child: ButtonAuth(
                                      mytitle: "Add",
                                      myfunction: () {
                                        if (formState.currentState!
                                            .validate()) {
                                          addWorkshopToNotifications();
                                        }
                                      }),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  elevation: 6,
                  backgroundColor: Colors.blue[600],
                  child: const Icon(
                    Icons.add,
                    color: Colors.greenAccent,
                    size: 30,
                  ),
                ),
              ),
            )
          : null,
      body: isloading
          ? const LoadingForData(ver: 2.8, hor: 2.1, loadingsize: 25.0)
          : SfCalendar(
              showCurrentTimeIndicator: false,
              timeSlotViewSettings:
                  const TimeSlotViewSettings(startHour: 7, timeFormat: 'HH.mm'),
              view: CalendarView.week,
              onTap: (calendarTapDetails) {
                if (calendarTapDetails.appointments != null &&
                    calendarTapDetails.appointments!.isNotEmpty) {
                  DateTime tappedTime = calendarTapDetails.date!;
                  for (int i = 0; i < meetings.length; i++) {
                    if (meetings[i].from == tappedTime ||
                        meetings[i].to == tappedTime ||
                        (meetings[i].from.isBefore(tappedTime) &&
                            meetings[i].to.isAfter(tappedTime))) {
                      String description = meetings[i].description;
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: meetings[i].eventName,
                        titleTextStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 221, 5, 30),
                        ),
                        desc: description,
                        descTextStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        btnOkText: widget.clubnameuser == meetings[i].eventName
                            ? "Resend a notification to remind members"
                            : "Confirm if you will be there",
                        btnOkOnPress: () async {
                          if (widget.clubnameuser == meetings[i].eventName) {
                            String startTime1 =
                                DateFormat('HH:mm').format(meetings[i].from);
                            await funcsendnotification(
                                "${widget.clubnameuser} (Remind): $startTime1",
                                meetings[i].description,
                                "Remind",
                                "Be there!");

                            showDialoge(
                                "Remind",
                                "we have send a remind notification to your members",
                                DialogType.success);
                          } else {
                            String timeworkshop = DateFormat('yyyy-MM-dd')
                                .format(meetings[i].from);
                            updatecomingmembers(
                                meetings[i].eventName, timeworkshop);
                          }
                        },
                        btnOkColor: Colors.blue[900],
                      ).show();
                      break;
                    }
                  }
                }
              },
              appointmentTextStyle: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(255, 191, 29, 203)),
              firstDayOfWeek: 1,
              todayHighlightColor: Colors.blue[900],
              dataSource: MeetingDataSource(_getDataSource()),
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
            ),
    );
  }

  Future<void> updatecomingmembers(String clubnom, String date) async {
    try {
      QuerySnapshot workshopsSnapshot = await FirebaseFirestore.instance
          .collection('workshops')
          .where('date', isEqualTo: date)
          .where('clubname', isEqualTo: clubnom)
          .get();

      if (workshopsSnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = workshopsSnapshot.docs.first;

        List<dynamic> comingMembers =
            List.from(docSnapshot['comingmembers'] ?? []);
        if (!comingMembers.contains(user!.uid)) {
          comingMembers.add(user!.uid);
          await FirebaseFirestore.instance
              .collection('workshops')
              .doc(docSnapshot.id)
              .update({'comingmembers': comingMembers});
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Thank you for your confirmation ❤️",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.blue,
            ),
          );
          setState(() {});
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "You have already confirm !!",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.blue,
            ),
          );
        }

        setState(() {});
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  final List<Meeting> meetings = <Meeting>[];
  List<Meeting> _getDataSource() {
    if (userData.isNotEmpty) {
      for (int i = 0; i < userData.length; i++) {
        String timeString = userData[i]["time"];
        String dateString = userData[i]["date"];

        String dateTimeString = "$dateString $timeString:00";
        dateTimeString = dateTimeString.replaceAll('/', '-');

        final DateTime dateTime = DateTime.parse(dateTimeString);
        final DateTime startTime = dateTime;
        final DateTime endTime = startTime.add(const Duration(hours: 2));

        meetings.add(
          Meeting(
            "${userData[i]["clubname"]}",
            "${userData[i]["details"]}\n Place : ${userData[i]["place"]}",
            startTime,
            endTime,
            userData[i]["clubname"] == clubsnames[0]
                ? const Color.fromARGB(255, 227, 227, 47)
                : userData[i]["clubname"] == clubsnames[1]
                    ? Colors.blue[600]
                    : userData[i]["clubname"] == clubsnames[2]
                        ? Colors.blue[400]
                        : userData[i]["clubname"] == clubsnames[3]
                            ? Colors.green[700]
                            : userData[i]["clubname"] == clubsnames[4]
                                ? Colors.red
                                : userData[i]["clubname"] == clubsnames[5]
                                    ? Colors.orange
                                    : userData[i]["clubname"] == clubsnames[6]
                                        ? const Color.fromARGB(
                                            255, 25, 153, 200)
                                        : userData[i]["clubname"] ==
                                                clubsnames[7]
                                            ? const Color.fromARGB(
                                                255, 167, 65, 34)
                                            : userData[i]["clubname"] ==
                                                    clubsnames[8]
                                                ? Colors.blue[800]
                                                : userData[i]["clubname"] ==
                                                        clubsnames[9]
                                                    ? const Color.fromARGB(
                                                        255, 122, 122, 22)
                                                    : Colors.green,
          ),
        );
      }
    }

    return meetings;
  }

  void showDialoge(String title, String desc, DialogType type) {
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
      btnOkOnPress: () {},
    ).show();
  }

  sendnotification(
      String title, String description, String imageclub, String token) async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAA-4IaKIM:APA91bH9tmr9HS-Yjojlk9pdu-VskhNUOkJQgDsGCSCDzge80SJm2Qtny6W18tOenem2xe3azvn-cBjvpewsVPV9RaOZcHytYO310cykbCQFS2h-WhjaTCEVoVYWvTaa1iiIgJrSp7a-'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": token,
      "notification": {
        "title": title,
        "body": description,
        "image": imageclub,
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
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Meeting {
  Meeting(
    this.eventName,
    this.description,
    this.from,
    this.to,
    this.background,
  );
  String eventName;
  String description;
  DateTime from;
  DateTime to;
  Color? background;
}
