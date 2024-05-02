import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';

class ClubsBureau extends StatefulWidget {
  final String clubname;
  final String clubimage;
  final List bureauimages;
  final List leadersinfo;
  final List leadersimages;
  const ClubsBureau(
      {super.key,
      required this.clubname,
      required this.bureauimages,
      required this.leadersinfo,
      required this.clubimage,
      required this.leadersimages});

  @override
  State<ClubsBureau> createState() => _ClubsBureauState();
}

class _ClubsBureauState extends State<ClubsBureau> {
  int _currentImageIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      setState(() {
        _currentImageIndex =
            (_currentImageIndex + 1) % widget.bureauimages.length;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        children: [
          AppBarProfil(
            title:
                "${widget.clubname == "Team sup'com" ? "Team" : widget.clubname} Leaders",
            lottie: "images/lottie_animation5.json",
          ),
          SizedBox(
            height: 270.0,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Stack(
                  children: [
                    ClipRRect(
                      key: UniqueKey(),
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        imageUrl: widget.bureauimages[_currentImageIndex],
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: MediaQuery.of(context).size.height / 3.4,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Lottie.asset(
                          "images/lottie_loading2.json",
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 4.0,
                      right: MediaQuery.of(context).size.width / 2.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                            widget.bureauimages.length,
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
                  ],
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.leadersinfo.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${widget.leadersinfo[index]}"),
                titleTextStyle: const TextStyle(
                    fontSize: 17.0,
                    color: Color.fromARGB(255, 31, 117, 115),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    imageUrl: widget.leadersimages[index],
                    fit: BoxFit.fill,
                    width: 50.0,
                    height: 50.0,
                    placeholder: (context, url) => Lottie.asset(
                      "images/lottie_loading2.json",
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
                trailing: widget.clubname != "MLS"
                    ? Image.asset(
                        widget.clubimage,
                        width: 40.0,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          "images/mls.png",
                          width: 45.0,
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
