import 'package:flutter/material.dart';
import 'package:general_crowd_detector_app/classes/Location.dart';
import 'package:general_crowd_detector_app/comps/SubLocationWidget.dart';
import 'package:general_crowd_detector_app/global/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationWidget extends StatefulWidget {
  final Location location;

  const LocationWidget({Key key, this.location}) : super(key: key);

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  List<String> starredLocationNames = [];

  @override
  Widget build(BuildContext context) {
    getStarredLocationNames();

    return Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// location name
                Text(
                  widget.location.name,
                  style: GoogleFonts.poppins(
                      color: AppColors.darkTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),

                // Vertical spacing
                SizedBox(height: 8),

                /// Row sublocation of that place, depicted with circles
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.location.sublocations.map((sub) {
                    return subLocationWidget(sub);
                  }).toList(),
                )
              ],
            ),

            /// Button favourite
            Container(
              child: IconButton(
                icon: Icon(
                  Icons.star,
                  size: 30,
                  color: starredLocationNames.contains(widget.location.name)
                      ? Colors.amber
                      : Colors.grey,
                ),
                onPressed: () {
                  starredLocationNames.contains(widget.location.name)
                      ? removeStar(widget.location.name)
                      : addStar(widget.location.name);
                },
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 1)));
  }

  getStarredLocationNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      starredLocationNames = prefs.getStringList("starredLocationNames");
    });
  }

  removeStar(String locationName) async {
    print("removing $locationName from child");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currentStarredLocationNames =
        prefs.getStringList("starredLocationNames");
    currentStarredLocationNames.remove(locationName);
    setState(() {
      prefs.setStringList("starredLocationNames", currentStarredLocationNames);
    });
  }

  addStar(String locationName) async {
    print("adding $locationName from child");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currentStarredLocationNames =
        prefs.getStringList("starredLocationNames");
    currentStarredLocationNames.add(locationName);
    setState(() {
      prefs.setStringList("starredLocationNames", currentStarredLocationNames);
    });
  }
}
