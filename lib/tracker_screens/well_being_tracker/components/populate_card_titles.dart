import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/sleep_mood_cards.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/sections/mood_section.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/sections/sleep_screen.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class PopulateCardTiles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PopulateCardTiles();
}

class _PopulateCardTiles extends State<PopulateCardTiles> {

  String currentMood = "Set Mood";

  String bedtime = "N/A", wakeup = "N/A", sleepingTime = "N/A";

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMoodLocalData();
    getSleepLocalData();
  }

  getSleepLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String current = await ss.getItem("sleepCurrent_$formatDate") ?? "";

    if(current.isEmpty) return;

    List<String> list = current.split("/");

    setState(() {
      bedtime = list[0];
      wakeup = list[1];
      sleepingTime = list[2];
    });
  }

  getMoodLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String current = await ss.getItem("moodCurrent_$formatDate") ?? "Set Mood";

    setState(() {
      currentMood = current;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SleepMoodCard(
            title: 'Sleep',
            icon: 'assets/well_being/arc.svg',
            title2: "",
            title3: "$bedtime - $wakeup",
            title4: sleepingTime,
            press: () async {
              await Navigator.pushNamed(context, SleepScreen.routeName);
              getSleepLocalData();
            },
            color: Color(MyColors.primaryColor)),
        SizedBox(width: SizeConfig.screenWidth * 0.03),
        SleepMoodCard(
            title: 'Mood',
            icon: currentMood == "Set Mood" ? "assets/well_being/meh.svg" : 'assets/well_being/${currentMood.toLowerCase()}.svg',
            title2: '',
            title3: 'Current Mood',
            title4: currentMood,
            press: () async {
              await Navigator.pushNamed(context, MoodSection.routeName);
              getMoodLocalData();
            },
            color: Color(MyColors.stroke1Color)),
      ],
    );
  }
}