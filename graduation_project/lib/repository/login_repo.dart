import 'package:graduation_project/manage/firebase_service/firebase_service.dart';
import 'package:graduation_project/model/user.dart';

class LoginRepo {
  Future<void> createAccount(String uid, String name, String phoneNumber,
      String email, String dob) async {
    await FirebaseService.userRef.doc().set(User(
        uid: uid,
        phoneNumber: phoneNumber,
        email: email,
        dob: dob,
        userName: "",
        avatar:
            "https://png.pngtree.com/element_our/20200610/ourmid/pngtree-character-default-avatar-image_2237203.jpg",
        active: "online"));
  }

  Future<bool> isExist(String phoneNumber) async {
    var response = await FirebaseService.userRef
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();
    if (response.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<User> getUser(String uid) async {
    var response =
        await FirebaseService.userRef.where('uid', isEqualTo: uid).get();
    return response.docs.first.data();
  }
}
