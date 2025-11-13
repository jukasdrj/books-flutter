import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_dto.freezed.dart';
part 'work_dto.g.dart';

/// WorkDTO - Canonical API response for Works
/// Matches backend TypeScript interface from Canonical-Data-Contracts-PRD.md
@freezed
class WorkDTO with _$WorkDTO {
  const factory WorkDTO({
    required String id,  // Work ID from API
    required String title,
    String? subtitle,  // Optional subtitle from canonical spec
    @Default([]) List<String> authorIds,  // Author IDs from backend
    @Default([]) List<String> subjectTags,
    @Default(false) bool synthetic,
    String? primaryProvider,
    List<String>? contributors,
    List<String>? googleBooksVolumeIDs,
    String? openLibraryWorkID,
  }) = _WorkDTO;

  factory WorkDTO.fromJson(Map<String, dynamic> json) => _$WorkDTOFromJson(json);
}

/// EditionDTO - Canonical API response for Editions
@freezed
class EditionDTO with _$EditionDTO {
  const factory EditionDTO({
    String? isbn,
    @Default([]) List<String> isbns,
    String? title,
    String? publisher,
    int? publishedYear,
    String? coverImageURL,
    @Default('unknown') String format,
    int? pageCount,
    String? primaryProvider,
    String? googleBooksVolumeID,
    String? openLibraryEditionID,
  }) = _EditionDTO;

  factory EditionDTO.fromJson(Map<String, dynamic> json) => _$EditionDTOFromJson(json);
}

/// AuthorDTO - Canonical API response for Authors
@freezed
class AuthorDTO with _$AuthorDTO {
  const factory AuthorDTO({
    required String id,  // Backend-provided author ID for relationship mapping
    required String name,
    @Default('unknown') String gender,
    String? culturalRegion,
    String? openLibraryAuthorID,
    String? googleBooksAuthorID,
  }) = _AuthorDTO;

  factory AuthorDTO.fromJson(Map<String, dynamic> json) => _$AuthorDTOFromJson(json);
}

/// SearchResponseData - Combined data from search endpoints
@freezed
class SearchResponseData with _$SearchResponseData {
  const factory SearchResponseData({
    @Default([]) List<WorkDTO> works,
    @Default([]) List<EditionDTO> editions,
    @Default([]) List<AuthorDTO> authors,
  }) = _SearchResponseData;

  factory SearchResponseData.fromJson(Map<String, dynamic> json) =>
    _$SearchResponseDataFromJson(json);
}

/// MetaData - Response metadata
@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    required String timestamp,
    required int processingTime,
    required String provider,
    required bool cached,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
}

/// ErrorDetails - Structured error information
@freezed
class ErrorDetails with _$ErrorDetails {
  const factory ErrorDetails({
    required String message,
    required String code,
    Map<String, dynamic>? details,
  }) = _ErrorDetails;

  factory ErrorDetails.fromJson(Map<String, dynamic> json) =>
    _$ErrorDetailsFromJson(json);
}

/// ResponseEnvelope - Generic API response wrapper
/// Matches backend TypeScript ResponseEnvelope from responses.ts
@Freezed(genericArgumentFactories: true)
class ResponseEnvelope<T> with _$ResponseEnvelope<T> {
  const factory ResponseEnvelope({
    required bool success,
    T? data,
    ErrorDetails? error,
    required MetaData meta,
  }) = _ResponseEnvelope<T>;

  factory ResponseEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ResponseEnvelopeFromJson(json, fromJsonT);
}
