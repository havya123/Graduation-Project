import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation_project/manage/firebase_service/firebase_service.dart';
import 'package:graduation_project/model/place.dart';
import 'package:graduation_project/model/request.dart';
import 'package:graduation_project/model/request_multi.dart';
import 'package:intl/intl.dart';

class RequestRepo {
  Future<String> createRequest(
      String userId,
      String senderPhone,
      String receiverPhone,
      Map<String, dynamic> senderAddress,
      Map<String, dynamic> receiverAddress,
      String type,
      String parcelId,
      String paymentMethod,
      String payer,
      double cost,
      String statusRequest) async {
    try {
      DateTime now = DateTime.now();

      String formattedDate = DateFormat('dd/MM/yyyy, HH:mm').format(now);
      DocumentReference docRef = FirebaseService.requestRef.doc();
      await docRef.set(
        Request(
            requestId: docRef.id,
            userId: userId,
            senderAddress: senderAddress,
            receiverAddress: receiverAddress,
            type: type,
            parcelId: parcelId,
            paymentMethod: paymentMethod,
            payer: payer,
            cost: cost,
            statusRequest: statusRequest,
            driverId: "",
            receiverPhone: receiverPhone,
            senderPhone: senderPhone,
            created: formattedDate),
      );

      return docRef.id;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateRequestId(String requestId) async {
    await FirebaseService.requestRef
        .doc(requestId)
        .update({'requestId': requestId});
  }

  Future<Request?> getRequest(String requestId) async {
    var response = await FirebaseService.requestRef.doc(requestId).get();
    if (response.exists) {
      return response.data();
    }
    return null;
  }

  Future<RequestMulti?> getRequestMulti(String requestId) async {
    var response = await FirebaseService.requestMultiRef.doc(requestId).get();
    if (response.exists) {
      return response.data();
    }
    return null;
  }

  Future<List<Request>> getAllRequest(String userId) async {
    List<Request> listRequest = [];
    var response = await FirebaseService.requestRef
        .where('userId', isEqualTo: userId)
        .get();
    if (response.docs.isNotEmpty) {
      for (var request in response.docs) {
        listRequest.add(request.data());
      }
    }
    return listRequest;
  }

  Future<List<Request>> getListRequestWaiting(String userId) async {
    List<Request> listRequest = [];
    var response = await FirebaseService.requestRef
        .where('userId', isEqualTo: userId)
        .where('statusRequest', isEqualTo: 'waiting')
        .get();
    if (response.docs.isEmpty) {
      return listRequest;
    }
    for (var request in response.docs) {
      listRequest.add(request.data());
    }
    return listRequest;
  }

  Future<List<Request>> getListRequestCancel(String userId) async {
    List<Request> listRequest = [];
    var response = await FirebaseService.requestRef
        .where('userId', isEqualTo: userId)
        .where('statusRequest', isEqualTo: 'cancel')
        .get();
    if (response.docs.isEmpty) {
      return listRequest;
    }
    for (var request in response.docs) {
      listRequest.add(request.data());
    }
    return listRequest;
  }

  Future<List<Request>> getListRequestTaking(String userId) async {
    List<Request> listRequest = [];
    var response = await FirebaseService.requestRef
        .where('userId', isEqualTo: userId)
        .where('statusRequest', isEqualTo: 'on taking')
        .get();
    if (response.docs.isEmpty) {
      return listRequest;
    }
    for (var request in response.docs) {
      listRequest.add(request.data());
    }
    return listRequest;
  }

  Future<List<Request>> getListRequestDelivery(String userId) async {
    List<Request> listRequest = [];
    var response = await FirebaseService.requestRef
        .where('userId', isEqualTo: userId)
        .where('statusRequest', isEqualTo: 'on delivery')
        .get();
    if (response.docs.isEmpty) {
      return listRequest;
    }
    for (var request in response.docs) {
      listRequest.add(request.data());
    }
    return listRequest;
  }

  Future<List<Request>> getListRequestSuccess(String userId) async {
    List<Request> listRequest = [];
    var response = await FirebaseService.requestRef
        .where('userId', isEqualTo: userId)
        .where('statusRequest', isEqualTo: 'success')
        .get();
    if (response.docs.isEmpty) {
      return listRequest;
    }
    for (var request in response.docs) {
      listRequest.add(request.data());
    }
    return listRequest;
  }

  Future<void> updateStatus(String requestId, String newStatus) async {
    await FirebaseService.requestRef
        .doc(requestId)
        .update({'statusRequest': newStatus});
  }

  Future<String> createRequestMulti(
      String userId,
      String senderPhone,
      Map<String, dynamic> senderAddress,
      List<Map<String, dynamic>> receiverAddress,
      List<String> parcelId,
      String paymentMethod,
      String payer,
      double cost,
      String statusRequest) async {
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('dd/MM/yyyy, HH:mm').format(now);
    DocumentReference docRef = FirebaseService.requestMultiRef.doc();

    await docRef.set(
      RequestMulti(
          requestId: docRef.id,
          userId: userId,
          senderAddress: senderAddress,
          receiverAddress: receiverAddress,
          parcelId: parcelId,
          paymentMethod: paymentMethod,
          payer: payer,
          cost: cost,
          statusRequest: statusRequest,
          driverId: "",
          senderPhone: senderPhone,
          created: formattedDate),
    );
    return docRef.id;
  }

  Future<List<RequestMulti>> getListRequestMultWaiting(String userId) async {
    List<RequestMulti> listRequest = [];
    var response = await FirebaseService.requestMultiRef
        .where('userId', isEqualTo: userId)
        .where('statusRequest', isEqualTo: 'waiting')
        .get();
    if (response.docs.isEmpty) {
      return listRequest;
    }
    for (var request in response.docs) {
      listRequest.add(request.data());
    }
    return listRequest;
  }

  Future<List<RequestMulti>> getListRequestMultiCancel(String userId) async {
    List<RequestMulti> listRequest = [];
    var response = await FirebaseService.requestMultiRef
        .where('userId', isEqualTo: userId)
        .where('statusRequest', isEqualTo: 'cancel')
        .get();
    if (response.docs.isEmpty) {
      return listRequest;
    }
    for (var request in response.docs) {
      listRequest.add(request.data());
    }
    return listRequest;
  }

  Future<List<RequestMulti>> getListRequestMultiTaking(String userId) async {
    List<RequestMulti> listRequest = [];
    var response = await FirebaseService.requestMultiRef
        .where('userId', isEqualTo: userId)
        .where('statusRequest', isEqualTo: 'on taking')
        .get();
    if (response.docs.isEmpty) {
      return listRequest;
    }
    for (var request in response.docs) {
      listRequest.add(request.data());
    }
    return listRequest;
  }

  Future<List<RequestMulti>> getListRequestMultiDelivery(String userId) async {
    List<RequestMulti> listRequest = [];
    var response = await FirebaseService.requestMultiRef
        .where('userId', isEqualTo: userId)
        .where('statusRequest', isEqualTo: 'on delivery')
        .get();
    if (response.docs.isEmpty) {
      return listRequest;
    }
    for (var request in response.docs) {
      listRequest.add(request.data());
    }
    return listRequest;
  }

  Future<List<RequestMulti>> getListRequestMultiSuccess(String userId) async {
    List<RequestMulti> listRequest = [];
    var response = await FirebaseService.requestMultiRef
        .where('userId', isEqualTo: userId)
        .where('statusRequest', isEqualTo: 'success')
        .get();
    if (response.docs.isEmpty) {
      return listRequest;
    }
    for (var request in response.docs) {
      listRequest.add(request.data());
    }
    return listRequest;
  }

  Future<void> updateStatusMulti(String requestId, String newStatus) async {
    await FirebaseService.requestMultiRef
        .doc(requestId)
        .update({'statusRequest': newStatus});
  }

  Future<void> deleteRequest(String requestId) async {
    await FirebaseService.requestRef.doc(requestId).delete();
  }

  Future<void> deleteRequestMulti(String requestId) async {
    await FirebaseService.requestMultiRef.doc(requestId).delete();
  }
}
