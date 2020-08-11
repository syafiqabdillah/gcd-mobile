import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:general_crowd_detector_app/comps/LocationWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:general_crowd_detector_app/global/app_colors.dart';
import 'package:general_crowd_detector_app/classes/Location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// List of Locations available
  Future<List<Location>> locationList;
  Timer timer;
  // Shared preferences to store Starred Location's ID
  List<String> starredLocationNames;

  @override
  void initState() {
    super.initState();
    setState(() {
      locationList = fetchLocationData();
      starredLocationNames = [];
    });
    // Refresh data every 15 seconds
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      setState(() {
        locationList = fetchLocationData();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Container for header
            Container(
              width: double.infinity,
              child: Stack(
                children: [
                  /// welcoming message
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Yuk cek tingkat kedapatan lokasi tujuanmu!",
                        style: GoogleFonts.poppins(
                            color: AppColors.darkTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )
                    ],
                  )),
                ],
              ),
            ),

            /// vertical spacing
            SizedBox(height: 16),

            /// Container for menu
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "All",
                    style: GoogleFonts.poppins(
                        color: AppColors.lightGreenColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Starred",
                    style: GoogleFonts.poppins(
                        color: AppColors.veryLightTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            /// vertical spacing
            SizedBox(height: 8),

            /// container for places list
            Expanded(
              child: Container(
                child: FutureBuilder(
                  future: locationList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return LocationWidget(
                                location: snapshot.data[index]);
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Location>> fetchLocationData() async {
    final response = await http.get('http://192.168.2.126:5000/get-locations');
    if (response.statusCode == 200) {
      // print("fetching locations data from API");
      final jsonResponseBody = json.decode(response.body)['data'];
      final locationNames = jsonResponseBody.keys;
      List<Location> listLocation = [];

      for (String locationName in locationNames) {
        List<dynamic> jsonSubLocation = jsonResponseBody[locationName];
        Location newLocation = Location.fromJson(locationName, jsonSubLocation);
        if (starredLocationNames.contains(locationName)) {
          newLocation.isStarred = true;
        }
        listLocation.add(newLocation);
      }
      return listLocation;
    } else {
      throw Exception('Failed to load location data');
    }
  }
}
