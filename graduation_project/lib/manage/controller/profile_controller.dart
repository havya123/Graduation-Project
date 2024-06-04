import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/extension/snackbar.dart';
import 'package:graduation_project/repository/user_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  XFile? avatar;

  @override
  void onInit() {
    if (AppStore.to.userName.isNotEmpty) {
      nameController.text = AppStore.to.userName.value;
    }
    phoneController.text = AppStore.to.phoneNumber.value;
    if (AppStore.to.email.isNotEmpty) {
      emailController.text = AppStore.to.email.value;
    }
    if (AppStore.to.address.isNotEmpty) {
      addressController.text = AppStore.to.address.value;
    }
    super.onInit();
  }

  Future<void> logout() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      prefs.clear();
      AppStore.to.user.value = null;
      MyDialogs.success(msg: "Logout Successfully");
    } catch (e) {}
  }

  Future<void> updateProfile() async {
    try {
      AppStore.to.userName.value = nameController.text;
      AppStore.to.phoneNumber.value = phoneController.text;
      AppStore.to.email.value = emailController.text;
      AppStore.to.address.value = addressController.text;

      await UserRepo().updateProfile(nameController.text, phoneController.text,
          emailController.text, addressController.text);
      await updateAvatar();
    } catch (e) {}
  }

  Future<void> pickImageFromGallery() async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      await Permission.storage.request();
    }
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    avatar = returnImage;
    // countImage.value = listImageSelect.length;
  }

  Future<void> pickImageFromCamera() async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      return Future.error("Storage permission is denied");
    }
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    avatar = returnImage;
    // countImage.value = listImageSelect.length;
  }

  Future<void> updateAvatar() async {
    if (avatar == null) return;
    String newAvatar =
        await UserRepo().uploadImage(AppStore.to.uid.value, avatar!);
    AppStore.to.avatar.value = newAvatar;
  }
}
