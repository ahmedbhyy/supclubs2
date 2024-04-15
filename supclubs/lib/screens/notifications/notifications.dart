import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/screens/notifications/notifications_details.dart';
import 'package:supclubs/widgets/cards/events_card.dart';
import 'package:supclubs/widgets/generalwidgets/commonemptydata.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isloading = false;

  late User user;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> userData = [];

  Future<void> getUserNotifications() async {
    try {
      isloading = true;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        QuerySnapshot notificationsSnapshot =
            await userDoc.reference.collection('notifications').get();

        userData.clear();

        for (var doc in notificationsSnapshot.docs) {
          Map<String, dynamic> notificationData =
              doc.data() as Map<String, dynamic>;
          notificationData['id'] = doc.id;
          userData.add(notificationData);
        }
        userData.sort((a, b) {
          DateTime dateA = DateTime.parse(a['date']);
          DateTime dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA);
        });
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
    user = _auth.currentUser!;
    getUserNotifications();
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
            title: "Notifications",
            lottie: "images/lottie_notification.json",
          ),
          isloading
              ? const LoadingForData(ver: 2.8, hor: 2.0, loadingsize: 28.0)
              : userData.isEmpty
                  ? const EmptyData(text: "There is no notifications", padd: 3)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userData.length,
                      itemBuilder: (context, index) {
                        return EventsCard(
                          onLongPress: () {
                            return AwesomeDialog(
                              context: context,
                              dialogType: DialogType.question,
                              animType: AnimType.rightSlide,
                              title: 'Confirme Delete',
                              desc:
                                  'Are you sure to delete this notification send from ${userData[index]["clubname"]}? , this will be deleted from your schedule!',
                              descTextStyle: const TextStyle(fontSize: 18),
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('notifications')
                                    .doc(userData[index]['id'])
                                    .delete();

                                setState(() {
                                  userData.removeAt(index);
                                });
                              },
                            ).show();
                          },
                          title: userData[index]["clubname"],
                          source: userData[index]["image"],
                          date: userData[index]["date"],
                          place: userData[index]["place"],
                          time: userData[index]["time"],
                          id: userData[index]['id'],
                          child: NotificationDetails(
                            image: userData[index]["image"],
                            id: userData[index]["id"],
                            title: userData[index]["clubname"],
                            description: userData[index]["details"],
                            date: userData[index]["date"],
                            place: userData[index]["place"],
                            time: userData[index]["time"],
                            titleworkshop: userData[index]["title"],
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
