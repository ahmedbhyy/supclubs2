import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:supclubs/clubs/clubs_details.dart';
import 'package:supclubs/clubs/clubscards.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/widgets/generalwidgets/commonemptydata.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';

class Favorites extends StatefulWidget {
  final String username;

  final String iduser;
  final String useremail;
  final String useryear;
  final String clubiduser;
  const Favorites({
    super.key,
    required this.username,
    required this.iduser,
    required this.useremail,
    required this.useryear,
    required this.clubiduser,
  });

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool isloading = false;
  List<QueryDocumentSnapshot> data = [];

  late User _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> getData() async {
    try {
      isloading = true;
      String currentUserId = _user.uid;

      QuerySnapshot clubsSnapshot =
          await FirebaseFirestore.instance.collection('clubs').get();

      for (QueryDocumentSnapshot clubDoc in clubsSnapshot.docs) {
        CollectionReference membersCollection =
            clubDoc.reference.collection('members');

        QuerySnapshot userInMembersSnapshot = await membersCollection
            .where('idmember', isEqualTo: currentUserId)
            .get();

        if (userInMembersSnapshot.docs.isNotEmpty) {
          Map<String, dynamic> clubData =
              clubDoc.data() as Map<String, dynamic>;

          clubData['clubId'] = clubDoc.id;

          data.add(clubDoc);
        }
      }

      setState(() {
        isloading = false;
      });
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    _user = _auth.currentUser!;

    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          const AppBarProfil(
            title: "Favorite Clubs",
            lottie: "images/lottie_icon2.json",
          ),
          isloading
              ? const LoadingForData(ver: 2.8, hor: 2.2, loadingsize: 28.0)
              : data.isEmpty
                  ? const EmptyData(text: "No favorites clubs !", padd: 3.0)
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ClubsCard(
                          title: data[index]["name"],
                          source: "images/${data[index]["image"]}.png",
                          child: ClubsDetails(
                            useremail: widget.useremail,
                            bureauleaders: data[index]["leaders"],
                            bureauimages: data[index]["images"],
                            userid: widget.iduser,
                            clubiduser: widget.clubiduser,
                            leadersimages:  data[index]["imageleaders"],
                            username: widget.username,
                            useryear: widget.useryear,
                            clubid: data[index].id,
                            description: data[index]["description"],
                            imagepath3: "images/${data[index]["image1"]}.png",
                            name: data[index]["name"],
                            urlfb: Uri.parse(data[index]["urlfb"]),
                            urlinstagram: Uri.parse(data[index]["urling"]),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
