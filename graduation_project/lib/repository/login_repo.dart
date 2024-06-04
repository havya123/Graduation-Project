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
              "https://firebasestorage.googleapis.com/v0/b/delivery-5f21b.appspot.com/o/user%2Favatar%2Fuser.png?alt=media&token=af828096-f5ab-4ae8-a994-67ca7ea6584c",
          address: "",
        ));
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
