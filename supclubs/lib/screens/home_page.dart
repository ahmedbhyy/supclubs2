import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/profilscreens/profil_screen.dart';
import 'package:supclubs/tab_bar_view/tab_bar_view1.dart';
import 'package:supclubs/tab_bar_view/tab_bar_view2.dart';
import 'package:supclubs/tab_bar_view/tab_bar_view3.dart';
import 'package:supclubs/gemini_chat.dart';
import 'package:supclubs/widgets/slides/slide_right.dart';
import 'package:supclubs/widgets/slides/slide_top.dart';

const colorizeColors = [
  Colors.blue,
  Colors.green,
  Colors.purple,
];

class HomePage extends StatefulWidget {
  final String? username;
  final String? clubiduser;
  final String? clubnameuser;
  final String? clubimguser;
  final String? token;
  final double? appvote;

  final String? useryear;
  final String? userphone;
  final String? userid;
  final bool? isAdmin;
  const HomePage({
    super.key,
    this.username,
    this.clubiduser,
    this.clubnameuser,
    this.clubimguser,
    this.useryear,
    this.userphone,
    this.isAdmin,
    this.token,
    this.appvote,
    this.userid,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _user;
  String _imageFile =
      'https://img.freepik.com/premium-vector/young-happy-man-with-thumbs-up-vector-flat-style-cartoon-illustration_357257-1138.jpg';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;

    fetchProfileImage();
  }

  fetchProfileImage() {
    final store = FirebaseStorage.instance.ref();
    final newprofilpic = FirebaseAuth.instance.currentUser!.uid;
    final pdpref = store.child("profil/$newprofilpic.jpg");

    try {
      pdpref.getDownloadURL().then((value) {
        setState(() {
          _imageFile = value;
        });
      }, onError: (val) {
        _imageFile =
            "https://img.freepik.com/premium-vector/young-happy-man-with-thumbs-up-vector-flat-style-cartoon-illustration_357257-1138.jpg";
      });
    } catch (e) {
      return Get.rawSnackbar(
          title: "Error",
          message:
              "une erreur est survenue lors de l'importation du l'image veuillez réessayer ultérieurement",
          backgroundColor: Colors.red);
    }
  }

  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldkey,
        backgroundColor: Colors.white,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(SlideRight(page:  ChatGemini(image: _imageFile,)));
            },
            backgroundColor: const Color.fromARGB(255, 228, 166, 238),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  SlideTop(
                    page: ProfilScreen(
                      isAdmin: widget.isAdmin!,
                      userid: widget.userid!,
                      appvote: widget.appvote!,
                      clubnameuser: widget.clubnameuser!,
                      clubpresidant: widget.clubiduser!,
                      phone: widget.userphone!,
                      year: widget.useryear!,
                      username: widget.username!,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CachedNetworkImage(
                      imageUrl: _imageFile,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Lottie.asset(
                        "images/lottie_loading2.json",
                        height: 20.0,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person_2_outlined,
                        color: Colors.blue,
                      ),
                    )),
              ),
            ),
          ),
          title: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'Hi, ${widget.username}',
                textStyle: GoogleFonts.abhayaLibre(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 22,
                ),
                colors: colorizeColors,
              ),
            ],
            isRepeatingAnimation: true,
            totalRepeatCount: 50,
            pause: const Duration(milliseconds: 50),
          ),
          actions: [
            Lottie.asset("images/lottie_home.json", repeat: false),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(
                child: Text("Home"),
              ),
              Tab(
                child: Text("Events"),
              ),
              Tab(
                child: Text("schedule"),
              ),
            ],
            unselectedLabelColor: const Color.fromARGB(255, 15, 193, 148),
            labelStyle: GoogleFonts.abel(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 20,
                color: Colors.blue[700]),
          ),
        ),
        body: TabBarView(
          children: [
            TabBarView1(
              userclass: widget.useryear!,
              useremail: _user.email!,
              clubiduser: widget.clubiduser!,
              userid: _user.uid,
              username: widget.username!,
            ),
            TabBarView2(
              isadmin: widget.isAdmin!,
              userimage: _imageFile,
              userid: _user.uid,
              username: widget.username!,
              useryear: widget.useryear!,
            ),
            TabBarView3(
              clubiduser: widget.clubiduser!,
              usertoken: widget.token!,
              clubimguser: widget.clubimguser!,
              clubnameuser: widget.clubnameuser!,
              isAdmin: widget.isAdmin!,
            ),
          ],
        ),
      ),
    );
  }
}
