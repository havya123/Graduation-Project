import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DriverActiveNearby {
  String? driverId;
  double? lat;
  double? lng;
  DriverActiveNearby({
    this.driverId,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'driverId': driverId,
      'lat': lat,
      'lng': lng,
    };
  }

  factory DriverActiveNearby.fromMap(Map<String, dynamic> map) {
    return DriverActiveNearby(
      driverId: map['driverId'] != null ? map['driverId'] as String : null,
      lat: map['lat'] != null ? map['lat'] as double : null,
      lng: map['lng'] != null ? map['lng'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverActiveNearby.fromJson(String source) =>
      DriverActiveNearby.fromMap(json.decode(source) as Map<String, dynamic>);
}
