import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:supclubs/clubs/workshop_add.dart';
import 'package:supclubs/clubs/workshop_details.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';

import 'package:supclubs/widgets/cards/events_card.dart';
import 'package:supclubs/widgets/generalwidgets/commonemptydata.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';
import 'package:supclubs/widgets/slides/slide_right.dart';

class ClubWorkshops extends StatefulWidget {
  final String name;
  final String ispresidant;
  final String id;
  final int membersnumber;
  const ClubWorkshops(
      {super.key,
      required this.name,
      required this.id,
      required this.ispresidant, required this.membersnumber});

  @override
  State<ClubWorkshops> createState() => _ClubWorkshopsState();
}

class _ClubWorkshopsState extends State<ClubWorkshops> {
  List<QueryDocumentSnapshot> data = [];

  bool isloading = false;

  getData() async {
    isloading = true;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('${widget.name}workshops')
        .get();
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
      floatingActionButton: widget.ispresidant == widget.id
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  SlideRight(
                    page: AddWorkshop(name: widget.name),
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
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        children: [
          AppBarProfil(
            title:
                "${widget.name == "Team sup'com" ? "Team" : widget.name} Workshops",
            lottie: "images/lottie_workshop.json",
          ),
          isloading
              ? const LoadingForData(ver: 3.0, hor: 2.0, loadingsize: 25.0)
              : data.isEmpty
                  ? const EmptyData(text: "No Workshops !", padd: 2.7)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return EventsCard(
                          onLongPress: () {
                            return widget.ispresidant == widget.id
                                ? AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.question,
                                    animType: AnimType.rightSlide,
                                    title: 'Confirme Delete',
                                    desc:
                                        'Are you sure to delete this Workshop ${data[index]["title"]} ?',
                                    descTextStyle:
                                        const TextStyle(fontSize: 18),
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () async {
                                      await FirebaseFirestore.instance
                                          .collection('${widget.name}workshops')
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
                          date: data[index]["date"],
                          place: data[index]["place"],
                          time: data[index]["time"],
                          id: data[index].id,
                          child: WorkshopDetail(
                            myurl: data[index]["pdf"],
                            date: data[index]["date"],
                            membersnumber: widget.membersnumber,
                            workshopvote: (data[index]["vote"] + 0.0),
                            place: data[index]["place"],
                            workshopid: data[index].id,
                            clubname: widget.name,
                            time: data[index]["time"],
                            title: data[index]["title"],
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
