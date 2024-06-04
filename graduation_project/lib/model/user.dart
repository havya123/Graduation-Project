import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String uid;
  String phoneNumber;
  String email;
  String dob;
  String userName;
  String avatar;
  String? address;
  User({
    required this.uid,
    required this.phoneNumber,
    required this.email,
    required this.dob,
    required this.userName,
    required this.avatar,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'uid': uid,
      'phoneNumber': phoneNumber,
      'email': email,
      'dob': dob,
      'avatar': avatar,
      'address': address,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? "",
      phoneNumber: map['phoneNumber'] ?? "",
      email: map['email'] ?? "",
      dob: map['dob'] ?? "",
      userName: map['userName'] ?? "",
      avatar: map['avatar'] ?? "",
      address: map['address'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
