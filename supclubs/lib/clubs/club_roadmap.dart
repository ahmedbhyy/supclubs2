import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/widgets/generalwidgets/commonemptydata.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';
import 'package:supclubs/widgets/timeline_tile/time_line.dart';

class ClubRoadMap extends StatefulWidget {
  final String clubname;
  final String clubid;
  final String clubiduser;
  const ClubRoadMap(
      {super.key,
      required this.clubname,
      required this.clubid,
      required this.clubiduser});

  @override
  State<ClubRoadMap> createState() => _ClubRoadMapState();
}

class _ClubRoadMapState extends State<ClubRoadMap> {
  bool isloading = false;
  List<QueryDocumentSnapshot> data = [];

  Future<void> getData() async {
    try {
      DocumentReference clubDocument =
          FirebaseFirestore.instance.collection('clubs').doc(widget.clubid);

      QuerySnapshot membersSnapshot = await clubDocument
          .collection('roadmap')
          .orderBy(FieldPath.documentId)
          .get();

      data.addAll(membersSnapshot.docs);

      setState(() {});
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        children: [
          AppBarProfil(
            title: widget.clubname,
            lottie: "images/lottie_grades.json",
          ),
          isloading
              ? LoadingForData(ver: 3.0, hor: 2.0, loadingsize: 25.0)
              : data.isEmpty
                  ? EmptyData(text: "Program not available", padd: 3.0)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return MyTimeLine(
                          isFirst: data[index]['isfirst'],
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.question,
                              animType: AnimType.rightSlide,
                              title: 'Is Past ?',
                              titleTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 25,
                              ),
                              desc:
                                  'Confirm if ${data[index]["name"]} is past ?',
                              descTextStyle: const TextStyle(fontSize: 18),
                              btnCancelOnPress: () {},
                              btnOkText: "Confirm",
                              btnOkOnPress: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('clubs')
                                      .doc(widget.clubid)
                                      .collection('roadmap')
                                      .doc(data[index].id)
                                      .update({'ispast': true});
                                  setState(() {});
                                } catch (e) {
                                  return;
                                }
                              },
                            ).show();
                          },
                          isLast: data[index]['islast'],
                          ispresidant: widget.clubid == widget.clubiduser,
                          isPast: data[index]['ispast'],
                          text: data[index]['name'],
                          text1: data[index]['date'],
                          description: data[index]['description'],
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
