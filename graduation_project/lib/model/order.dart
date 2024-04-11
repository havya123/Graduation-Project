import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Order {
  String userSent;
  String userReceive;
  String phoneSent;
  String phoneReceive;
  String pickAddress;
  String destinationAddress;
  List<String> listImage;
  String dimension;
  String weight;
  Order({
    required this.userSent,
    required this.userReceive,
    required this.phoneSent,
    required this.phoneReceive,
    required this.pickAddress,
    required this.destinationAddress,
    required this.listImage,
    required this.dimension,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userSent': userSent,
      'userReceive': userReceive,
      'phoneSent': phoneSent,
      'phoneReceive': phoneReceive,
      'pickAddress': pickAddress,
      'destinationAddress': destinationAddress,
      'listImage': listImage,
      'dimension': dimension,
      'weight': weight,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      userSent: map['userSent'] as String,
      userReceive: map['userReceive'] as String,
      phoneSent: map['phoneSent'] as String,
      phoneReceive: map['phoneReceive'] as String,
      pickAddress: map['pickAddress'] as String,
      destinationAddress: map['destinationAddress'] as String,
      listImage: List<String>.from(map['listImage'] as List<String>),
      dimension: map['dimension'] as String,
      weight: map['weight'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
