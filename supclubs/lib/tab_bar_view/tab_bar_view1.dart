import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';
import 'package:supclubs/clubs/clubscards.dart';
import 'package:supclubs/clubs/clubs_details.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

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
  late VideoPlayerController _controller;
  bool isloading = false;
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    isloading = true;
    setState(() {});
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('clubs').get();
    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();

    _controller = VideoPlayerController.asset(
      'images/myvideo.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) {});
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                        horizontal: 20, vertical: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            VideoPlayer(_controller),
                            _ControlsOverlay(controller: _controller),
                            VideoProgressIndicator(_controller,
                                allowScrubbing: true),
                          ],
                        ),
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
                          Lottie.asset("images/lottie_missile.json", width: 40),
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

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Center(
                  child: Lottie.asset(
                    "images/lottie_play.json",
                    height: 120,
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
