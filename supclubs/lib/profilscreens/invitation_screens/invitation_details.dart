import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/widgets/buttton_auth.dart';

class InvitationDetails extends StatefulWidget {
  final String title;

  final String date;
  final String senderemail;
  final String senderyear;
  final String image;
  final String etat;
  final String idmember;
  final String idinvitation;
  final String clubname;
  const InvitationDetails({
    super.key,
    required this.title,
    required this.date,
    required this.senderemail,
    required this.senderyear,
    required this.image,
    required this.idmember,
    required this.etat,
    required this.idinvitation,
    required this.clubname,
  });

  @override
  State<InvitationDetails> createState() => _InvitationDetailsState();
}

class _InvitationDetailsState extends State<InvitationDetails> {
  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    String currentUserId = getCurrentUserId();
    var emoji = parser.get('thumbsup');

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          AppBarProfil(
              title: widget.title, lottie: "images/lottie_invitation.json"),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              imageUrl: widget.image,
              height: 200.0,
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
          const SizedBox(height: 20),
          Text(
            "Username :",
            style: GoogleFonts.abel(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.blue,
            ),
          ),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Email :",
            style: GoogleFonts.abel(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.blue,
            ),
          ),
          Text(
            widget.senderemail,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Class :",
            style: GoogleFonts.abel(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.blue,
            ),
          ),
          Text(
            widget.senderyear,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Invitation Date :",
            style: GoogleFonts.abel(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.blue,
            ),
          ),
          Text(
            widget.date.split(' ')[0],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Etat :",
            style: GoogleFonts.abel(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.blue,
            ),
          ),
          Text(
            widget.etat,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 50),
          widget.etat == "En attente"
              ? ButtonAuth(
                  mytitle: "Accept Invitation ${emoji.code}",
                  myfunction: () async {
                    await uploadToFirebase(currentUserId);
                    await uploadToFirebase1();
                  })
              : Container(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> uploadToFirebase(String userId) async {
    try {
      DocumentReference userDocument =
          FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot userSnapshot = await userDocument.get();
      if (userSnapshot.exists) {
        String clubId = userSnapshot['clubid'];

        if (clubId != '') {
          DocumentReference clubDocument =
              FirebaseFirestore.instance.collection('clubs').doc(clubId);

          await clubDocument.collection('members').add({
            'idmember': widget.idmember,
            'membername': widget.title,
          });

          // ignore: use_build_context_synchronously
          return AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Member added successfully',
            titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 25,
            ),
            desc: 'we added ${widget.title} to your members list',
            descTextStyle: const TextStyle(fontSize: 18),
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        } else {}
      } else {}
    } catch (e) {
      return;
    }
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;

    return user != null ? user.uid : '';
  }

  Future<void> uploadToFirebase1() async {
    try {
      DocumentReference invitationDocument = FirebaseFirestore.instance
          .collection('invitation')
          .doc(widget.idinvitation);

      await invitationDocument.update({
        'etat': 'Accepted',
      });
    } catch (e) {
      return;
    }
  }
}
