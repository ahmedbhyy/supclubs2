import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class MyCardRoad extends StatelessWidget {
  final bool isPast;
  final String child;
  final String description;
  final String child1;
  final bool ispresidant;
  final void Function() onPressed;
  const MyCardRoad(
      {super.key,
      required this.isPast,
      required this.child,
      required this.child1,
      required this.description,
      required this.onPressed,
      required this.ispresidant});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: child,
          titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800]),
          desc: description,
          descTextStyle: const TextStyle(fontSize: 15),
          btnOkOnPress: () {},
          btnOkColor: Colors.blue[600],
        ).show();
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPast ? Colors.deepPurple[300] : Colors.deepPurple[100],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.elliptical(20, 20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              child,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 19,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                Text(
                  child1,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 17,
                    color: Color.fromARGB(255, 64, 14, 157),
                  ),
                ),
                ispresidant
                    ? IconButton(
                        onPressed: onPressed,
                        iconSize: 27.0,
                        icon: Icon(
                          Icons.verified_outlined,
                          color: isPast
                              ? const Color.fromARGB(255, 0, 253, 118)
                              : const Color.fromARGB(255, 236, 233, 243),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
