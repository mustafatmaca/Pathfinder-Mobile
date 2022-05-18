class City {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  const City(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
        id: json['id'],
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude']);
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'latitude': latitude, 'longitude': longitude};
}
