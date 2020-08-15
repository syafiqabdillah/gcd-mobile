import 'package:general_crowd_detector_app/classes/SubLocation.dart';

class Location {
  String name;
  List<SubLocation> sublocations;

  Location({this.name, this.sublocations});

  factory Location.fromJson(
      String locationName, Map<String, dynamic> locationData) {
    List<SubLocation> subLocationList = [];

    for (Map<String, dynamic> sub in locationData['sublocations']) {
      subLocationList.add(SubLocation.fromJson(sub));
    }

    return Location(name: locationName, sublocations: subLocationList);
  }
}
