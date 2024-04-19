import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:supclubs/screens/events_screens/add_event.dart';

import 'package:supclubs/screens/events_screens/event_details.dart';

import 'package:supclubs/widgets/cards/events_card.dart';
import 'package:supclubs/widgets/generalwidgets/commonemptydata.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';

class TabBarView2 extends StatefulWidget {
  final bool isadmin;
  final String userid;
  final String username;
  final String useryear;
  final String userimage;
  const TabBarView2(
      {super.key,
      required this.isadmin,
      required this.userid,
      required this.username,
      required this.useryear,
      required this.userimage});

  @override
  State<TabBarView2> createState() => _TabBarView2State();
}

class _TabBarView2State extends State<TabBarView2> {
  bool isloading = false;
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    isloading = true;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('events').get();
    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.white,
      floatingActionButton: widget.isadmin
          ? Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddEvent(
                        userid: widget.userid,
                      ),
                    ),
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
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              isloading
                  ? const LoadingForData(ver: 3.0, hor: 2.1, loadingsize: 25.0)
                  : data.isEmpty
                      ? const EmptyData(text: "No Events", padd: 3.5)
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return EventsCard(
                              onLongPress: () {
                                return widget.userid == data[index]["userid"]
                                    ? AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.question,
                                        animType: AnimType.rightSlide,
                                        title: 'Confirme Delete',
                                        desc:
                                            'Are you sure to delete this event : ${data[index]["title"]} ?',
                                        descTextStyle:
                                            const TextStyle(fontSize: 18),
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: () async {
                                          await FirebaseFirestore.instance
                                              .collection("events")
                                              .doc(data[index].id)
                                              .delete();
                                          setState(() {
                                            data.removeAt(index);
                                          });
                                        },
                                      ).show()
                                    : null;
                              },
                              title: data[index]["title"],
                              source: data[index]["image"],
                              id: data[index].id,
                              date: data[index]["date"],
                              place: data[index]["place"],
                              time: data[index]["time"],
                              child: EventDetails(
                                image: data[index]["image"],
                                userimage: widget.userimage,
                                userid: data[index]["userid"],
                                currentuserid: widget.userid,
                                username: widget.username,
                                useryear: widget.useryear,
                                eventid: data[index].id,
                                isregister: data[index]["register"],
                                title: data[index]["title"],
                                description: data[index]["description"],
                                date: data[index]["date"],
                                place: data[index]["place"],
                                time: data[index]["time"],
                                eventurl: data[index]["url"],
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
