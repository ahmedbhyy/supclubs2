import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/widgets/slides/slide_right.dart';

class InvitationCard extends StatelessWidget {
  final String clubname;
  final String date;
  final String idsender;
  final String emailsender;
  final String senderphoto;
  final String sendername;
  final String statue;
  final String userclass;
  final Widget child;
  final Function() onLongPress;

  const InvitationCard({
    Key? key,
    required this.clubname,
    required this.senderphoto,
    required this.child,
    required this.date,
    required this.emailsender,
    required this.idsender,
    required this.sendername,
    required this.statue,
    required this.userclass,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(SlideRight(page: child));
      },
      onLongPress: onLongPress,
      child: Card(
        color: Colors.blue[50],
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(
                sendername,
                style: GoogleFonts.abel(
                  fontSize: 22,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: senderphoto,
                  width: 60.0,
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
              trailing: Lottie.asset("images/lottie_arrow.json", width: 35),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userclass,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    statue,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
