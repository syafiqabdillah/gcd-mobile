class SubLocation {
  String name;
  bool isCrowded;

  SubLocation({this.name, this.isCrowded});

  factory SubLocation.fromJson(Map<String, dynamic> json) {
    return SubLocation(
        name: json['sublocation_name'], isCrowded: json['is_crowded']);
  }
}
