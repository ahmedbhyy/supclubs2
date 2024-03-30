import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';

import 'package:supclubs/widgets/generalwidgets/commonemptydata.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';

class ClubMembers extends StatefulWidget {
  final String clubname;
  final String clubid;
  final String clubiduser;
  const ClubMembers(
      {Key? key,
      required this.clubname,
      required this.clubid,
      required this.clubiduser});

  @override
  State<ClubMembers> createState() => _ClubMembersState();
}

class _ClubMembersState extends State<ClubMembers> {
  List<QueryDocumentSnapshot> data1 = [];
  List<QueryDocumentSnapshot> data2 = [];
  List<int> numbers = [0, 1, 2];
  bool isloading = false;
  TextEditingController points = TextEditingController();

  getData2() async {
    isloading = true;
    setState(() {});
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('invitation')
        .where('etat', isEqualTo: "Accepted")
        .where('clubid', isEqualTo: widget.clubid)
        .get();

    data1.addAll(querySnapshot.docs);

    data1.sort((a, b) => b["userpoints"].compareTo(a["userpoints"]));
    if (data1.length >= 2) {
      data2.addAll([data1[0], data1[1], data1[2]]);
    }
    isloading = false;
    setState(() {});
  }

  Future<void> updateUserPoints(int index, double newPoints) async {
    final String docId = data1[index].id;
    await FirebaseFirestore.instance
        .collection('invitation')
        .doc(docId)
        .update({'userpoints': newPoints});

    setState(() {});
  }

  @override
  void initState() {
    getData2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: DefaultTextStyle(
          style: GoogleFonts.abel(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.blue,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText("${widget.clubname} Members"),
            ],
            isRepeatingAnimation: false,
            displayFullTextOnTap: true,
          ),
        ),
        surfaceTintColor: Colors.white,
        actions: [
          Lottie.asset("images/lottie_workshop.json"),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 27,
              color: Color.fromARGB(255, 83, 137, 230),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 252, 252, 252),
      ),
      body: isloading
          ? LoadingForData(ver: 3.0, hor: 2.0, loadingsize: 25.0)
          : data1.isEmpty
              ? EmptyData(text: "No Members", padd: 3.0)
              : Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 4.2,
                          ),
                          child: Image.asset(
                            "images/poduim.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        data2.length >= 2
                            ? Positioned(
                                top: MediaQuery.of(context).size.height / 50.0,
                                right: MediaQuery.of(context).size.width / 2.6,
                                child: rank(
                                  radius: 45.0,
                                  height: 10,
                                  image: data2[0]["userimage"],
                                  name: data2[0]["sendername"],
                                  point: data2[0]["userpoints"],
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height / 8.0,
                                  horizontal:
                                      MediaQuery.of(context).size.width / 4.5,
                                ),
                                child: Text(
                                  "ranking not available ❌",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                        data2.length >= 2
                            ? Positioned(
                                top: MediaQuery.of(context).size.height / 10.0,
                                left: MediaQuery.of(context).size.width / 50.0,
                                child: rank(
                                  radius: 30.0,
                                  height: 10,
                                  image: data2[1]["userimage"],
                                  name: data2[1]["sendername"],
                                  point: data2[1]["userpoints"],
                                ),
                              )
                            : Container(),
                        data2.length >= 2
                            ? Positioned(
                                top: MediaQuery.of(context).size.height / 8.0,
                                right: MediaQuery.of(context).size.width / 10.0,
                                child: rank(
                                  radius: 30.0,
                                  height: 10,
                                  image: data1[2]["userimage"],
                                  name: data1[2]["sendername"],
                                  point: data2[2]["userpoints"],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 213, 221, 227),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data1.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  widget.clubiduser == widget.clubid
                                      ? AwesomeDialog(
                                              context: context,
                                              body: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Add points to ${data1[index]["sendername"]} ? current points : (${data1[index]["userpoints"]})",
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                      hintText: "Add points",
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    controller: points,
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                ],
                                              ),
                                              btnOkColor: Colors.blue[500],
                                              dialogType: DialogType.question,
                                              animType: AnimType.rightSlide,
                                              btnOkText: "Save",
                                              btnOkOnPress: () {
                                                updateUserPoints(
                                                    index,
                                                    data1[index]["userpoints"] +
                                                        int.parse(points.text));
                                              },
                                              btnCancelOnPress: () {})
                                          .show()
                                      : null;
                                },
                                child: ListTile(
                                  title: Text("${data1[index]["sendername"]}"),
                                  subtitle: Text("${data1[index]["useryear"]}"),
                                  titleTextStyle: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 31, 117, 115),
                                    fontStyle: FontStyle.italic,
                                  ),
                                  trailing: SizedBox(
                                    width: 80,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star_border,
                                          size: 18,
                                          color:
                                              Color.fromARGB(255, 168, 125, 4),
                                        ),
                                        Text(
                                          "${data1[index]["userpoints"]}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color: Colors.blue[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  leading: SizedBox(
                                    width: 80,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          maxRadius: 10,
                                          backgroundColor: index >= 0 &&
                                                  index < numbers.length
                                              ? Color.fromARGB(255, 255, 187, 0)
                                              : Color.fromARGB(
                                                  255, 198, 107, 244),
                                          child: Text(
                                            "${index + 1}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.blue[800],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: CachedNetworkImage(
                                            imageUrl: data1[index]["userimage"],
                                            width: 50,
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                Lottie.asset(
                                              "images/lottie_loading2.json",
                                              width: 100,
                                            ),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
    );
  }
}

Column rank({
  required double radius,
  required double height,
  required String image,
  required String name,
  required int point,
}) {
  return Column(
    children: [
      CircleAvatar(
        radius: radius,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundImage: NetworkImage(image),
      ),
      SizedBox(
        height: height,
      ),
      Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.0),
      ),
      Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.star_border,
              color: Color.fromARGB(255, 255, 187, 0),
            ),
            Text(
              "$point",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
