import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AutoCompletePrediction {
  String? description;
  StructuredFormatting? structuredFormatting;
  String? placeId;
  String? references;
  AutoCompletePrediction({
    this.description,
    this.structuredFormatting,
    this.placeId,
    this.references,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'structuredFormatting': structuredFormatting?.toMap(),
      'placeId': placeId,
      'references': references,
    };
  }

  factory AutoCompletePrediction.fromMap(Map<String, dynamic> map) {
    return AutoCompletePrediction(
        description: map['description'] as String?,
        placeId: map['place_id'] as String?,
        references: map['reference'] as String?,
        structuredFormatting: map['structured_formatting'] != null
            ? StructuredFormatting.fromMap(map['structured_formatting'])
            : null);
  }

  String toJson() => json.encode(toMap());

  factory AutoCompletePrediction.fromJson(Map<String, dynamic> source) =>
      AutoCompletePrediction.fromMap(source);
}

class StructuredFormatting {
  String? mainText;
  String? secondaryText;
  StructuredFormatting({
    this.mainText,
    this.secondaryText,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mainText': mainText,
      'secondaryText': secondaryText,
    };
  }

  factory StructuredFormatting.fromMap(Map<String, dynamic> map) {
    return StructuredFormatting(
      mainText: map['mainText'] as String?,
      secondaryText: map['secondaryText'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory StructuredFormatting.fromJson(String source) =>
      StructuredFormatting.fromMap(json.decode(source) as Map<String, dynamic>);
}
