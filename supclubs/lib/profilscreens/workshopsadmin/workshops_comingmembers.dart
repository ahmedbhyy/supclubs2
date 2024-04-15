import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/profilscreens/workshopsadmin/workshops_details_comingmembers.dart';
import 'package:supclubs/widgets/generalwidgets/commonemptydata.dart';
import 'package:supclubs/widgets/generalwidgets/commonloading.dart';
import 'package:supclubs/widgets/slides/slide_right.dart';

class WorkshopsDetailsPresidant extends StatefulWidget {
  final String clubnameuser;
  const WorkshopsDetailsPresidant({super.key, required this.clubnameuser});

  @override
  State<WorkshopsDetailsPresidant> createState() => _WorkshopsDetailsState();
}

class _WorkshopsDetailsState extends State<WorkshopsDetailsPresidant> {
  bool isloading = false;
  List<QueryDocumentSnapshot> allworkshops = [];

  getData() async {
    isloading = true;
    setState(() {});
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('workshops')
        .where('clubname', isEqualTo: widget.clubnameuser)
        .get();
    allworkshops.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        children: [
          const AppBarProfil(
            title: "Workshops Details",
            lottie: "images/lottie_workshop.json",
          ),
          isloading
              ? const LoadingForData(ver: 3.0, hor: 3.0, loadingsize: 20)
              : allworkshops.isEmpty
                  ? const EmptyData(text: "No Workshops", padd: 3.5)
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: allworkshops.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              SlideRight(
                                page: ComingMembers(
                                  workshoptitle: allworkshops[index]["title"],
                                  comingMembersid: allworkshops[index]
                                      ["comingmembers"],
                                  clubname: widget.clubnameuser,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text("${allworkshops[index]["title"]}"),
                            subtitle: Text(
                              "${allworkshops[index]["time"]} / ${allworkshops[index]["date"]}",
                            ),
                            titleTextStyle: const TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 81, 49, 221),
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                            trailing: SizedBox(
                              width: 70.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "${allworkshops[index]['comingmembers'].length}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.blue[600],
                                    ),
                                  ),
                                  Lottie.asset(
                                    "images/lottie_arrow.json",
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            leading: SizedBox(
                              width: 70.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: CachedNetworkImage(
                                  imageUrl: allworkshops[index]["image"],
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
                            ),
                          ),
                        );
                      }),
        ],
      ),
    );
  }
}
