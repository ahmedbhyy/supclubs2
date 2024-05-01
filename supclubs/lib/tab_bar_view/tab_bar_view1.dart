import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';
import 'package:supclubs/clubs/clubscards.dart';
import 'package:supclubs/clubs/clubs_details.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';
import 'package:url_launcher/url_launcher.dart';

class TabBarView1 extends StatefulWidget {
  final String username;

  final String clubiduser;
  final String userid;
  final String useremail;
  final String userclass;
  const TabBarView1({
    super.key,
    required this.username,
    required this.userid,
    required this.useremail,
    required this.userclass,
    required this.clubiduser,
  });

  @override
  State<TabBarView1> createState() => _TabBarView1State();
}

class _TabBarView1State extends State<TabBarView1> {
  bool isloading = false;
  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> data1 = [];

  getData() async {
    isloading = true;
    setState(() {});
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('clubs').get();
    data.addAll(querySnapshot.docs);
    QuerySnapshot querySnapshot1 =
        await FirebaseFirestore.instance.collection('events').get();
    data1.addAll(querySnapshot1.docs);
    isloading = false;
    setState(() {});
  }

  late Timer _timer;
  int _currentImageIndex = 0;

  @override
  void initState() {
    getData();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      setState(() {
        if (data1.isEmpty) {
          _currentImageIndex = (_currentImageIndex + 1) % 1;
        } else {
          _currentImageIndex = (_currentImageIndex + 1) % data1.length;
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: !isloading
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            key: UniqueKey(),
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              imageUrl: data1[_currentImageIndex]["image"],
                              width: MediaQuery.of(context).size.width / 1.1,
                              height: MediaQuery.of(context).size.height / 4,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Lottie.asset(
                                "images/lottie_loading2.json",
                                height: 150.0,
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 4.5,
                            right: MediaQuery.of(context).size.width / 2.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...List.generate(
                                  data1.length,
                                  (index) => AnimatedContainer(
                                    margin: const EdgeInsets.only(right: 5.0),
                                    duration: const Duration(milliseconds: 900),
                                    width: _currentImageIndex == index ? 20 : 5,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 240, 210, 222),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -20.0,
                            right: 5.0,
                            child: Image.asset(
                              "images/event.png",
                              height: 40.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Clubs",
                            style: GoogleFonts.aclonica(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: const Color.fromARGB(255, 17, 178, 206),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Lottie.asset("images/lottie_missile.json",
                              width: 40, repeat: false),
                        ],
                      ),
                      Row(
                        children: [
                          Lottie.asset("images/lottie_location.json",
                              width: 35),
                          InkWell(
                            onTap: () {
                              _launchUrl();
                            },
                            child: Text(
                              "Sup'com",
                              style: GoogleFonts.aclonica(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: const Color.fromARGB(255, 7, 83, 236),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  GridView.builder(
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
                          userid: widget.userid,
                          bureauleaders: data[index]["leaders"],
                          bureauimages: data[index]["images"],
                          clubiduser: widget.clubiduser,
                          username: widget.username,
                          useryear: widget.userclass,
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
              )
            : const LoadingForData(ver: 6.0, hor: 3.0, loadingsize: 25.0),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse("https://www.supcom.tn/"))) {
      throw Exception('Could not launch this url!');
    }
  }
}
