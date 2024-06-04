import 'package:drivers/firebase_service/firebase_service.dart';
import 'package:drivers/model/driver.dart';

class LoginRepo {
  Future<void> createAccount(String uid, String name, String phoneNumber,
      String email, String dob) async {
    Map<String, dynamic> driverData = Driver(
      uid: uid,
      phoneNumber: phoneNumber,
      email: email,
      dob: dob,
      userName: "",
      avatar:
          "https://firebasestorage.googleapis.com/v0/b/delivery-5f21b.appspot.com/o/user%2Favatar%2Fuser.png?alt=media&token=af828096-f5ab-4ae8-a994-67ca7ea6584c",
      active: false,
    ).toMap();

    await FirebaseService.driverRef.child(uid).set(driverData);
  }

  Future<bool> isExist(String uid) async {
    try {
      var value = await FirebaseService.driverRef.child(uid).once();
      return value.snapshot.exists;
    } catch (e) {
      rethrow;
    }
  }

  // Future<bool> isUser(String phoneNumber) async {
  //   var response = await FirebaseService.userRef
  //       .where("phoneNumber", isEqualTo: phoneNumber)
  //       .get();
  //   if (response.docs.isNotEmpty) {
  //     return true;
  //   }
  //   return false;
  // }
}
