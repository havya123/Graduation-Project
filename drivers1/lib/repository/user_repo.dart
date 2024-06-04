import 'dart:io';

import 'package:drivers/firebase_service/firebase_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../model/driver.dart';

class DriverRepo {
  Future<Driver?> getUser(String uid) async {
    try {
      DatabaseReference databaseReference =
          FirebaseService.driverRef.child(uid);

      // Listen for the once event
      DatabaseEvent event = await databaseReference.once();

      // Access the snapshot property of the event
      DataSnapshot dataSnapshot = event.snapshot;

      // Check if dataSnapshot.value is a Map
      if (dataSnapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> userData =
            dataSnapshot.value as Map<dynamic, dynamic>;

        // Convert Map<dynamic, dynamic> to Map<String, dynamic>
        Map<String, dynamic> userDataStringKey =
            userData.map((key, value) => MapEntry(key.toString(), value));

        return Driver.fromMap(userDataStringKey);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  isOnline(String uid, bool active) {
    DatabaseReference ref = FirebaseService.driverRef.child(uid);
    ref.update({"active": active});
    ref.onValue.listen((event) {});
  }

  ifOffLine(String uid, bool active) {
    DatabaseReference? ref = FirebaseService.driverRef.child(uid);
    ref.update({"active": active});
    ref.onValue.listen((event) {});
  }

  Future<String> uploadImage(String userId, XFile xFile) async {
    String fileName = xFile.path.split("/").last;
    String imagesLink = "";
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/parcel/$userId/parcelImage/$fileName');

      await ref.putFile(File(xFile.path));

      String downloadURL = await ref.getDownloadURL();
      imagesLink = downloadURL;
      await updateAvatar(userId, imagesLink);
      return downloadURL;
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<void> updateAvatar(String driverId, String avatar) async {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    databaseReference.child('driver/$driverId').update({
      'avatar': avatar,
    }).then((_) {
      print('Data updated successfully!');
    }).catchError((error) {
      print('Failed to update data: $error');
    });
  }

  Future<void> updateProfile(String driverId, String name, String phoneNumber,
      String email, String address) async {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    databaseReference.child('drivers/$driverId').update({
      'userName': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address
    });
  }

  // Future<void> updateStatus(String uid, bool active) async {
  //   var response =
  //       await FirebaseService.driverRef.where('uid', isEqualTo: uid).get();
  //   if (response.docs.isNotEmpty) {
  //     await FirebaseService.driverRef
  //         .doc(response.docs.first.id)
  //         .update({'active': active});
  //   }
  // }
}
