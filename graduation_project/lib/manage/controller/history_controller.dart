import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/model/request.dart';
import 'package:graduation_project/repository/request_repo.dart';

class HistoryController extends GetxController {
  RxList<Request> listRequestCancel = <Request>[].obs;
  RxList<Request> listRequestWaiting = <Request>[].obs;
  RxList<Request> listRequestTaking = <Request>[].obs;
  RxList<Request> listRequestDelivery = <Request>[].obs;
  RxList<Request> listRequestSuccess = <Request>[].obs;
  RxList<List<Request>> allRequest = <List<Request>>[].obs;
  RxBool loading = true.obs;
  ScrollController titleController = ScrollController();
  final double scrollTo = 60;
  List<String> listType = [
    'Waiting',
    'On Taking',
    'On Delivery',
    'Success',
    'Cancel',
  ];
  RxInt index = 0.obs;
  bool isScroll = false;

  @override
  Future<HistoryController> onInit() async {
    await getListRequestCancel();
    await getListRequestDelivery();
    await getListRequestSuccess();
    await getListRequestTaking();
    await getListRequestWaiting();
    allRequest.value = [
      listRequestWaiting,
      listRequestTaking,
      listRequestDelivery,
      listRequestSuccess,
      listRequestCancel,
    ];
    loading.value = false;
    return this;
  }

  void scrollTitle(int index) {
    if (titleController.hasClients) {
      double newPosition = index * scrollTo;
      print('New Position: $newPosition');
      titleController.animateTo(
        newPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void changeIndex(int newIndex) {
    if (index.value < newIndex && newIndex <= 2) {
      index.value = newIndex;
      scrollTitle(index.value);
      return;
    }

    if (index.value < newIndex && newIndex > 2) {
      index.value = newIndex;
      return;
    }

    if (index.value > newIndex && index.value >= 3) {
      index.value = newIndex;
    } else {
      index.value = newIndex;
      scrollTitle(index.value - 1);
    }
  }

  void swipeLeft() {
    if (index.value == 0) {
      return;
    }
    index.value--;
    if (index.value <= 1) {
      scrollTitle(index.value - 1);
    }
  }

  void swipeRight() {
    if (index.value == 4) {
      return;
    }
    index.value++;
    if (index.value <= 2) {
      scrollTitle(index.value);
    }
  }

  Future<void> getListRequestCancel() async {
    listRequestCancel.value =
        await RequestRepo().getListRequestCancel(AppStore.to.uid);
  }

  Future<void> getListRequestWaiting() async {
    listRequestWaiting.value =
        await RequestRepo().getListRequestWaiting(AppStore.to.uid);
    print(listRequestWaiting);
  }

  Future<void> getListRequestTaking() async {
    listRequestTaking.value =
        await RequestRepo().getListRequestTaking(AppStore.to.uid);
  }

  Future<void> getListRequestDelivery() async {
    listRequestDelivery.value =
        await RequestRepo().getListRequestDelivery(AppStore.to.uid);
  }

  Future<void> getListRequestSuccess() async {
    listRequestSuccess.value =
        await RequestRepo().getListRequestSuccess(AppStore.to.uid);
  }
}
