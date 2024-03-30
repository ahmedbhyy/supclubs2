import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/profilscreens/widget_profil/common_circle.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSupcom extends StatefulWidget {
  const AboutSupcom({
    super.key,
  });

  @override
  _AboutSupcomState createState() => _AboutSupcomState();
}

class _AboutSupcomState extends State<AboutSupcom> {
  int _currentImageIndex = 0;
  late Timer _timer;
  List<String> _imagePaths = [
    "images/SUPCOM.jpg",
    "images/supcom (1).jpg",
    "images/supcom2.jpg",
  ];

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _imagePaths.length;
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
          horizontal: 15,
          vertical: 5,
        ),
        children: [
          const AppBarProfil(
            title: "Sup'Com",
            lottie: "images/lottie_supcom.json",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Stack(
                children: [
                  ClipRRect(
                    key: UniqueKey(),
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      _imagePaths[_currentImageIndex],
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: MediaQuery.of(context).size.height / 3.5,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height / 4.0,
                      right: MediaQuery.of(context).size.width / 2.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                            _imagePaths.length,
                            (index) => AnimatedContainer(
                              margin: const EdgeInsets.only(right: 5.0),
                              duration: const Duration(milliseconds: 900),
                              width: _currentImageIndex == index ? 20 : 5,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 240, 210, 222),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Text(
            "Couronné par une solide réputation et une longue tradition d'excellence, L'École Supérieure des Communications de Tunis (SUP'COM) offre un environnement d'apprentissage dynamique et stimulant pour les étudiants désireux de se plonger dans le monde passionnant des technologies de communication.",
            textAlign: TextAlign.center,
            style: GoogleFonts.abel(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _launchUrl(
                        "https://www.facebook.com/supcom.universite.carthage");
                  },
                  child: const CircleSupcom(
                    lottie: "images/lottie_fb.json",
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    _launchUrl(
                        "https://fr.wikipedia.org/wiki/%C3%89cole_sup%C3%A9rieure_des_communications_de_Tunis");
                  },
                  child: const CircleSupcom(
                    lottie: "images/lottie_info.json",
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    _launchUrl("https://www.supcom.tn/");
                  },
                  child: const CircleSupcom(
                    lottie: "images/lottie_web2.json",
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    _launchUrl(
                        "https://www.google.com/maps/place/%C3%89cole+Sup%C3%A9rieure+des+communications+de+Tunis/@36.8918623,10.1877739,17z/data=!4m6!3m5!1s0x12e2cb6fc49b7883:0x84da64ea383c01d2!8m2!3d36.8918623!4d10.1877739!16s%2Fm%2F0h7pkxw?entry=ttu");
                  },
                  child: const CircleSupcom(
                    lottie: "images/lottie_location.json",
                  ),
                ),
              ],
            ),
          ),
          Lottie.asset(
            "images/lottie_supcom1.json",
            height: 140,
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch fb url');
    }
  }
}
