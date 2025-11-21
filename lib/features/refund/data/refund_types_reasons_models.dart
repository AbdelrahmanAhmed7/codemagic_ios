import 'package:json_annotation/json_annotation.dart';

part 'refund_types_reasons_models.g.dart';

// Refund Types Response
@JsonSerializable(explicitToJson: true)
class RefundTypesResponse {
  final bool success;
  final String? timestamp;
  final String? message;
  final RefundTypesData? data;

  RefundTypesResponse({
    required this.success,
    this.timestamp,
    this.message,
    this.data,
  });

  factory RefundTypesResponse.fromJson(Map<String, dynamic> json) =>
      _$RefundTypesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RefundTypesResponseToJson(this);
}

@JsonSerializable()
class RefundTypesData {
  final List<RefundType> refundTypes;

  RefundTypesData({required this.refundTypes});

  factory RefundTypesData.fromJson(Map<String, dynamic> json) =>
      _$RefundTypesDataFromJson(json);
  Map<String, dynamic> toJson() => _$RefundTypesDataToJson(this);
}

@JsonSerializable()
class RefundType {
  final int id;
  final String name;

  @JsonKey(defaultValue: const [])
  final List<RefundAttachment> attachments;

  RefundType({
    required this.id,
    required this.name,
    required this.attachments,
  });

  factory RefundType.fromJson(Map<String, dynamic> json) =>
      _$RefundTypeFromJson(json);
  Map<String, dynamic> toJson() => _$RefundTypeToJson(this);
}

@JsonSerializable()
class RefundAttachment {
  final String title;
  final bool isRequired;

  RefundAttachment({
    required this.title,
    required this.isRequired,
  });

  factory RefundAttachment.fromJson(Map<String, dynamic> json) =>
      _$RefundAttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$RefundAttachmentToJson(this);
}

// Refund Reasons Response
@JsonSerializable(explicitToJson: true)
class RefundReasonsResponse {
  final bool success;
  final String? timestamp;
  final String? message;
  final RefundReasonsData? data;

  RefundReasonsResponse({
    required this.success,
    this.timestamp,
    this.message,
    this.data,
  });

  factory RefundReasonsResponse.fromJson(Map<String, dynamic> json) =>
      _$RefundReasonsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RefundReasonsResponseToJson(this);
}

@JsonSerializable()
class RefundReasonsData {
  final List<RefundReason> refundReasons;

  RefundReasonsData({required this.refundReasons});

  factory RefundReasonsData.fromJson(Map<String, dynamic> json) =>
      _$RefundReasonsDataFromJson(json);
  Map<String, dynamic> toJson() => _$RefundReasonsDataToJson(this);
}

@JsonSerializable()
class RefundReason {
  final int id;
  final String name;

  RefundReason({
    required this.id,
    required this.name,
  });

  factory RefundReason.fromJson(Map<String, dynamic> json) =>
      _$RefundReasonFromJson(json);
  Map<String, dynamic> toJson() => _$RefundReasonToJson(this);
}
