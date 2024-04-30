import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:graduation_project/manage/firebase_service/firebase_service.dart';
import 'package:graduation_project/model/parcel.dart';
import 'package:image_picker/image_picker.dart';

class ParcelRepo {
  Future<String> createParcel(
    List<XFile?> listXfile,
    int dimension,
    double weight,
  ) async {
    try {
      DocumentReference docRef = FirebaseService.parcelRef.doc();
      await docRef.set(Parcel(
          parcelId: docRef.id,
          listImage: [],
          dimension: dimension,
          weight: weight,
          requestId: "",
          imageConfirm: ''));
      await uploadImage(docRef.id, listXfile);
      return docRef.id;
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<Parcel> getParcelInfor(String parcelId) async {
    var response = await FirebaseService.parcelRef.doc(parcelId).get();

    return response.data() as Parcel;
  }

  Future<void> uploadImage(String parcelId, List<XFile?> listXFile) async {
    List<String> fileName =
        listXFile.map((e) => e!.path.split("/").last).toList();
    List<String> imagesLink = [];
    try {
      for (int i = 0; i < listXFile.length; i++) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('images/parcel/$parcelId/parcelImage/${fileName[i]}');

        await ref.putFile(File(listXFile[i]!.path));

        String downloadURL = await ref.getDownloadURL();
        imagesLink.add(downloadURL);
      }
      await updateImage(parcelId, imagesLink);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateImage(String parcelId, List<String> imageUrl) async {
    try {
      await FirebaseService.parcelRef
          .doc(parcelId)
          .update({'listImage': imageUrl});
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateRequestId(String parcelId, String requestId) async {
    try {
      await FirebaseService.parcelRef
          .doc(parcelId)
          .update({'requestId': requestId});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteParcel(String parcelId) async {
    await FirebaseService.parcelRef.doc(parcelId).delete();
  }

  Future<void> deleteParcelMulti(List<String> listParcelId) async {
    for (var id in listParcelId) {
      await FirebaseService.parcelRef.doc(id).delete();
    }
  }
}
