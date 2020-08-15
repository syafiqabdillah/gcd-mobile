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
  bool showAll = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      locationList = fetchLocationData();
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showAll = true;
                        locationList = fetchLocationData();
                      });
                    },
                    child: Text(
                      "All",
                      style: GoogleFonts.poppins(
                          color: showAll
                              ? AppColors.lightGreenColor
                              : AppColors.lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showAll = false;
                        locationList = fetchLocationData();
                      });
                    },
                    child: Text(
                      "Starred",
                      style: GoogleFonts.poppins(
                          color: !showAll
                              ? AppColors.lightGreenColor
                              : AppColors.lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),

            /// vertical spacing
            SizedBox(height: 8),

            /// container for location list
            Expanded(
              child: Container(
                child: FutureBuilder(
                  future: locationList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return LocationWidget(
                                  location: snapshot.data[index]);
                            });
                      } else {
                        return Center(
                            child: Text(
                          "Data kosong :/",
                          style: GoogleFonts.poppins(
                              color: AppColors.lightTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ));
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              "Terjadi gangguan jaringan. Coba beberapa saat lagi."));
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
    final response = await http
        .get('http://192.168.2.125:5000/get-crowd-density-information')
        .catchError((e) {
      throw Exception("Tidak bisa terhubung ke server");
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currentStarredLocationNames =
        prefs.getStringList("starredLocationNames");

    if (response.statusCode == 200) {
      // print("fetching locations data from API");
      final jsonResponseBody = json.decode(response.body)['data'];
      final locationNames = jsonResponseBody.keys;
      List<Location> listLocation = [];

      for (String locationName in locationNames) {
        if (!showAll) {
          // show only starred location
          if (currentStarredLocationNames.contains(locationName)) {
            Map<String, dynamic> locationData = jsonResponseBody[locationName];
            Location newLocation =
                Location.fromJson(locationName, locationData);
            listLocation.add(newLocation);
          }
        } else {
          Map<String, dynamic> locationData = jsonResponseBody[locationName];
          Location newLocation = Location.fromJson(locationName, locationData);
          listLocation.add(newLocation);
        }
      }
      return listLocation;
    } else {
      throw Exception('Failed to load location data');
    }
  }
}
