import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:graduation_project/model/device_token.dart';
import 'package:graduation_project/model/parcel.dart';
import 'package:graduation_project/model/request.dart';
import 'package:graduation_project/model/request_multi.dart';
import 'package:graduation_project/model/user.dart';

class FirebaseService {
  static late final firebaseApp;
  static final userRef =
      FirebaseFirestore.instance.collection("users").withConverter<User>(
            fromFirestore: (snapshot, _) => User.fromMap(snapshot.data()!),
            toFirestore: (user, _) => user.toMap(),
          );
  static final requestRef =
      FirebaseFirestore.instance.collection("request").withConverter<Request>(
            fromFirestore: (snapshot, _) => Request.fromMap(snapshot.data()!),
            toFirestore: (request, _) => request.toMap(),
          );
  static final requestMultiRef = FirebaseFirestore.instance
      .collection("requestMulti")
      .withConverter<RequestMulti>(
        fromFirestore: (snapshot, _) => RequestMulti.fromMap(snapshot.data()!),
        toFirestore: (request, _) => request.toMap(),
      );
  static final parcelRef =
      FirebaseFirestore.instance.collection("parcel").withConverter<Parcel>(
            fromFirestore: (snapshot, _) => Parcel.fromMap(snapshot.data()!),
            toFirestore: (parcel, _) => parcel.toMap(),
          );
  static final deviceToken = FirebaseFirestore.instance
      .collection('deviceToken')
      .withConverter<DeviceTokenModel>(
        fromFirestore: (snapshot, _) =>
            DeviceTokenModel.fromMap(snapshot.data()!),
        toFirestore: (deviceToken, _) => deviceToken.toMap(),
      );

  static final driverRef = FirebaseDatabase.instanceFor(
          app: firebaseApp,
          databaseURL:
              "https://delivery-5f21b-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref()
      .child("drivers");
}
