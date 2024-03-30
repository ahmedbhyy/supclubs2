import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/widgets/generalwidgets/commonemptydata.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';

class ComingMembers extends StatefulWidget {
  final String workshoptitle;
  final List<dynamic> comingMembersid;
  final String clubname;
  const ComingMembers(
      {super.key,
      required this.workshoptitle,
      required this.comingMembersid,
      required this.clubname});

  @override
  State<ComingMembers> createState() => _ComingMembersState();
}

class _ComingMembersState extends State<ComingMembers> {
  bool isloading = false;
  List<QueryDocumentSnapshot> allcomingmembers = [];

  getData() async {
    isloading = true;
    setState(() {});
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('invitation')
        .where('etat', isEqualTo: "Accepted")
        .where('clubname', isEqualTo: widget.clubname)
        .where('idsender', whereIn: widget.comingMembersid)
        .get();
    allcomingmembers.addAll(querySnapshot.docs);
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
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        children: [
          AppBarProfil(
            title: "${widget.workshoptitle}",
            lottie: "images/lottie_workshop.json",
          ),
          isloading
              ? LoadingForData(ver: 3.0, hor: 3.0, loadingsize: 20)
              : allcomingmembers.isEmpty
                  ? EmptyData(
                      text: "No coming Members for ${widget.workshoptitle}",
                      padd: 3.5)
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: allcomingmembers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:
                              Text("${allcomingmembers[index]["sendername"]}"),
                          subtitle: Text(
                            "${allcomingmembers[index]["useryear"]}",
                          ),
                          titleTextStyle: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 81, 49, 221),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                          trailing: Lottie.asset(
                            "images/lottie_invitation.json",
                            repeat: false,
                          ),
                          leading: SizedBox(
                            width: 50.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CachedNetworkImage(
                                imageUrl: allcomingmembers[index]["userimage"],
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Lottie.asset(
                                  "images/lottie_loading2.json",
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      })
        ],
      ),
    );
  }
}
