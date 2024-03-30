import 'package:flutter/material.dart';
import 'package:supclubs/widgets/timeline_tile/event_card_road.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLine extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String text;
  final String text1;
  final String description;
  final bool ispresidant;
   final void Function() onPressed;
  const MyTimeLine(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      required this.text,
      required this.text1,
      required this.description, required this.ispresidant, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
          color: isPast ? Colors.deepPurple : Colors.deepPurple.shade100),
      indicatorStyle: IndicatorStyle(
        width: 45,
        color: isPast ? Colors.deepPurple.shade800 : Colors.deepPurple.shade100,
        iconStyle: IconStyle(
          iconData: Icons.done,
          color: isPast ? Colors.white : Colors.deepPurple.shade100,
        ),
      ),
      endChild: MyCardRoad(
        isPast: isPast,
        ispresidant: ispresidant,
          onPressed:onPressed ,
        child: text,
        child1: text1,
        description: description,
      ),
    );
  }
}
