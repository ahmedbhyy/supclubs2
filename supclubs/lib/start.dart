import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:supclubs/profilscreens/widget_profil/alertexit.dart';

import 'package:supclubs/screens/favorites.dart';
import 'package:supclubs/screens/home_page.dart';
import 'package:supclubs/screens/notifications/notifications.dart';

import 'package:supclubs/widgets/generalwidgets/commonloading.dart';

class StartScreens extends StatefulWidget {
  const StartScreens({super.key});

  @override
  State<StartScreens> createState() => _StartScreensState();
}

class _StartScreensState extends State<StartScreens> {
  int _selectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  String username = "Member";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  bool isAdmin = false;
  String? clubiduser;
  String? clubnameuser;
  String? clubimguser;
  String? useryear;
  String? userphone;
  String? token;
  double? appvote;

  @override
  void initState() {
    _user = _auth.currentUser!;
     FirebaseMessaging.instance.subscribeToTopic('events');
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Notifications()));
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showTopNotification(context, "${message.notification!.title}",
            "${message.notification!.body}");
      }
    });

    gettoken();
    super.initState();
  }

  showTopNotification(
    BuildContext context,
    String title,
    String message,
  ) {
    context.showFlash<bool>(
      duration: const Duration(seconds: 5),
      barrierDismissible: true,
      builder: (context, controller) => FlashBar(
        controller: controller,
        forwardAnimationCurve: Curves.easeInCirc,
        reverseAnimationCurve: Curves.bounceIn,
        position: FlashPosition.top,
        indicatorColor: Colors.red,
        icon: Icon(Icons.tips_and_updates_outlined),
        title: Text(title),
        titleTextStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => controller.dismiss(true), child: Text('Ok'))
        ],
      ),
    );
  }

  gettoken() async {
    token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection('users').doc(_user.uid).set(
      {
        'token': token,
      },
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          return await alertexit();
        },
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingForData(ver: 2.4, hor: 2.0, loadingsize: 24);
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error ,Please check your internet connection!'),
              );
            } else {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              username = userData['username'] ?? 'Member';
              isAdmin = userData['admin'] ?? false;
              clubiduser = userData['clubid'] ?? 'normaluser';
              clubnameuser = userData['role'] ?? 'user';
              clubimguser = userData['clubimage'] ?? 'nothing';
              userphone = userData['phone'] ?? 'nothing';
              useryear = userData['year'] ?? 'INDP1';
              appvote = (userData['appvote'] + 0.0) ?? 0.0;
              return _generateWindow(_selectedIndex);
            }
          },
        ),
      ),
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 228, 153, 240),
        buttonBackgroundColor: const Color.fromARGB(255, 227, 231, 215),
        items: [
          CurvedNavigationBarItem(
            child: Lottie.asset("images/lottie_home1.json", height: 30),
            label: 'Home',
            labelStyle: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          CurvedNavigationBarItem(
            child: _selectedIndex == 1
                ? Lottie.asset("images/lottie_icon2.json", height: 30)
                : Lottie.asset("images/lottie_icon2.json", height: 40),
            label: 'Favorites',
            labelStyle: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          CurvedNavigationBarItem(
            child: _selectedIndex == 2
                ? Lottie.asset("images/lottie_notification.json",
                    height: 40, width: 30)
                : Lottie.asset("images/lottie_notification.json", height: 50),
            label: 'Notifications',
            labelStyle: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  _generateWindow(int selectedIndex) {
    if (_selectedIndex == 0) {
      return HomePage(
        username: username,
        userid: _user.uid,
        appvote: appvote,
        clubiduser: clubiduser!,
        clubimguser: clubimguser!,
        isAdmin: isAdmin,
        token: token,
        clubnameuser: clubnameuser!,
        userphone: userphone!,
        useryear: useryear!,
      );
    }
    if (_selectedIndex == 1) {
      return Favorites(
        iduser: _user.uid,
        useremail: _user.email!,
        username: username,
        useryear: useryear!,
        clubiduser: clubiduser!,
      );
    }
    if (_selectedIndex == 2) return const Notifications();
  }
}
