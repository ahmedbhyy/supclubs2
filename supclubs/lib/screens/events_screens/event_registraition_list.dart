import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/widgets/generalwidgets/commonemptydata.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';

class MembersEvents extends StatefulWidget {
  final String eventid;
  const MembersEvents({super.key, required this.eventid});

  @override
  State<MembersEvents> createState() => _MembersEventsState();
}

class _MembersEventsState extends State<MembersEvents> {
  bool isloading = false;
  List<QueryDocumentSnapshot> data = [];
  Future<void> geteventlist() async {
    try {
      isloading = true;
      setState(() {});
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventid)
          .get();

      if (eventDoc.exists) {
        QuerySnapshot events = await eventDoc.reference
            .collection('registraition')
            .orderBy(FieldPath.documentId)
            .get();

        data.addAll(events.docs);
        isloading = false;
        setState(() {});
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    geteventlist();
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
            title: "Registraition List",
            lottie: "images/lottie_invitation.json",
          ),
          isloading
              ? LoadingForData(ver: 3.0, hor: 2.0, loadingsize: 25.0)
              : data.isEmpty
                  ? EmptyData(text: "No Registraition", padd: 3.0)
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 5,
                          vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey),
                        child: Text(
                          "Numbers of invitations : ${data.length}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
          data.isNotEmpty
              ? Divider(
                  thickness: 1.5,
                  height: 2,
                  color: Color.fromARGB(255, 154, 191, 222),
                )
              : Container(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              String dateedited = data[index]["date"].substring(0, 16);
              return ListTile(
                title: Text("${data[index]["username"]}"),
                subtitle: Text("${data[index]["year"]}"),
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 31, 117, 115),
                  fontStyle: FontStyle.italic,
                ),
                trailing: Text(
                  "$dateedited",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Colors.blue[600],
                  ),
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    imageUrl: data[index]["image"],
                    width: 55.0,
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
              );
            },
          ),
        ],
      ),
    );
  }
}
