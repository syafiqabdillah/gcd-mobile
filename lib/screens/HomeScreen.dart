import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:general_crowd_detector_app/comps/LocationWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:general_crowd_detector_app/global/app_colors.dart';
import 'package:general_crowd_detector_app/classes/Location.dart';
import 'package:general_crowd_detector_app/classes/SubLocation.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// List of Locations available
  Future<List<Location>> locationList;

  @override
  void initState() {
    super.initState();
    locationList = fetchLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: LocationSearch());
            },
            color: AppColors.darkTextColor,
          )
        ],
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
                            return locationWidget(snapshot.data[index]);
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
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
    final response = await http.get('http://192.168.2.128:5000/get-locations');
    if (response.statusCode == 200) {
      final jsonResponseBody = json.decode(response.body)['data'];
      final locationNames = jsonResponseBody.keys;
      List<Location> listLocation = [];

      for (String locationName in locationNames) {
        List<dynamic> jsonSubLocation = jsonResponseBody[locationName];
        listLocation.add(Location.fromJson(locationName, jsonSubLocation));
      }
      return listLocation;
    } else {
      throw Exception('Failed to load location data');
    }
  }
}

class LocationSearch extends SearchDelegate<Location> {
  @override
  List<Widget> buildActions(BuildContext context) {
    /// action for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    /// leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    /// show result based on the selection
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var myList = [
      Location(name: "Margocity Depok", sublocations: [
        SubLocation(name: "Pintu Utara", isCrowded: true),
        SubLocation(name: "Pintu Selatan", isCrowded: false),
        SubLocation(name: "Lobby", isCrowded: true),
      ]),
      Location(name: "ITC Mall Depok", sublocations: [
        SubLocation(name: "Pintu Timur", isCrowded: false),
        SubLocation(name: "Lobby", isCrowded: false)
      ]),
      Location(name: "Stasiun UI Depok", sublocations: [
        SubLocation(name: "Peron 1", isCrowded: false),
        SubLocation(name: "Peron 2", isCrowded: true)
      ])
    ];

    /// show suggestion
    final List<Location> suggestionList = query.isEmpty
        ? myList
        : myList
            .where((loc) => loc.name.toLowerCase().startsWith(query))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].name.substring(0, query.length),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: suggestionList[index].name.substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
