import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:general_crowd_detector_app/global/app_colors.dart';
import 'package:general_crowd_detector_app/classes/Location.dart';
import 'package:general_crowd_detector_app/classes/SubLocation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// List of Locations available
  List<Location> locationList = [
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
                    "Pinned",
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
//                color: Colors.lightBlue[100],
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  itemCount: locationList.length,
                  itemBuilder: (context, index) {
                    return locationWidget(locationList[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget locationWidget(Location location) {
  return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// location name
          Text(
            location.name,
            style: GoogleFonts.poppins(
                color: AppColors.darkTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),

          // Vertical spacing
          SizedBox(height: 8),

          /// Row sublocation of that place, depicted with circles
          Column(
            children: location.sublocations.map((sub) {
              return subLocationWidget(sub);
            }).toList(),
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 1)));
}

Widget subLocationWidget(SubLocation subLocation) {
  return Row(
    children: [
      /// color of the dot depending on the crowdness
      Container(
        height: 20,
        width: 20,
        margin: EdgeInsets.all(4),
        decoration: new BoxDecoration(
          color: subLocation.isCrowded ? Colors.redAccent : Colors.greenAccent,
          shape: BoxShape.circle,
        ),
      ),

      /// Horizontal spacing
      SizedBox(
        width: 8,
      ),

      /// name of the sublocation
      Text(
        subLocation.name,
        style: GoogleFonts.poppins(
            color: AppColors.veryLightTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      )
    ],
  );
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
        : myList.where((loc) => loc.name.toLowerCase().startsWith(query)).toList();

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
