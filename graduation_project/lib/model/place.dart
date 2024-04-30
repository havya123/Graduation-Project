import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Place {
  String? placeId;
  String name;
  String address;
  double lat;
  double lng;
  Place({
    this.placeId,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placeId': placeId,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      placeId: map['placeId'],
      name: map['name'] as String,
      address: map['address'] as String,
      lat: (map['geometry']['location']['lat'] as num).toDouble(),
      lng: (map['geometry']['location']['lng'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Place.fromJson(String source) =>
      Place.fromMap(json.decode(source) as Map<String, dynamic>);
}
