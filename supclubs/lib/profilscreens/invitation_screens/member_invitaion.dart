import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:supclubs/profilscreens/invitation_screens/invitation_details.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/profilscreens/widget_profil/common_card_invitation.dart';
import 'package:supclubs/widgets/generalwidgets/commonemptydata.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';

class MemberInvitation extends StatefulWidget {
  final String clubid;
  const MemberInvitation({super.key, required this.clubid});

  @override
  State<MemberInvitation> createState() => _MemberInvitationState();
}

class _MemberInvitationState extends State<MemberInvitation> {
  List<QueryDocumentSnapshot> data = [];
  bool isloading = false;

  Future<void> getData(String clubId) async {
    isloading = true;
    setState(() {});
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('invitation')
        .where('clubid', isEqualTo: clubId)
        .orderBy(FieldPath.documentId)
        .get();

    List<QueryDocumentSnapshot> sortedData = querySnapshot.docs;

    sortedData.sort((a, b) => a.id.compareTo(b.id));
    isloading = false;
    setState(() {
      data = sortedData;
    });
  }

  @override
  void initState() {
    getData(widget.clubid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.only(top: 7, right: 5, left: 5),
        children: [
          const AppBarProfil(
            title: "Invitations",
            lottie: "images/lottie_invitation.json",
          ),
          isloading
              ? LoadingForData(ver: 3.0, hor: 2.0, loadingsize: 25.0)
              : data.isEmpty
                  ? EmptyData(text: "There is no invitations !", padd: 3.0)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return InvitationCard(
                          onLongPress: () {},
                          clubname: data[index]["clubname"],
                          userclass: data[index]["useryear"],
                          date: data[index]["date"],
                          emailsender: data[index]["senderemail"],
                          idsender: data[index]["idsender"],
                          sendername: data[index]["sendername"],
                          senderphoto: data[index]["userimage"],
                          statue: data[index]["etat"],
                          child: InvitationDetails(
                            clubname: data[index]["clubname"],
                            date: data[index]["date"],
                            idinvitation: data[index].id,
                            etat: data[index]["etat"],
                            idmember: data[index]["idsender"],
                            senderemail: data[index]["senderemail"],
                            senderyear: data[index]["useryear"],
                            title: data[index]["sendername"],
                            image: data[index]['userimage'],
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
