// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:graduation_project/model/auto_complete_prediction.dart';

class PlaceAutoComplete {
  String? status;
  List<AutoCompletePrediction>? prediction;
  PlaceAutoComplete({
    this.status,
    this.prediction,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'predictions': prediction?.map((p) => p.toMap()).toList(),
    };
  }

  factory PlaceAutoComplete.fromJson(Map<String, dynamic> json) {
    return PlaceAutoComplete(
      status: json['status'] as String?,
      prediction: json['predictions'] != null
          ? json['predictions']
              .map<AutoCompletePrediction>((jsonAutoComplete) =>
                  AutoCompletePrediction.fromJson(jsonAutoComplete))
              .toList()
          : null,
    );
  }

  static PlaceAutoComplete parseAutoComplete(String responseBody) {
    print(responseBody);
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceAutoComplete.fromJson(parsed);
  }
}
