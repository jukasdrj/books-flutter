import 'package:freezed_annotation/freezed_annotation.dart';

part 'author_dto.freezed.dart';
part 'author_dto.g.dart';

@freezed
class AuthorDTO with _$AuthorDTO {
  const factory AuthorDTO({
    required String id,
    required String name,
    String? gender,
    String? culturalRegion,
    String? openLibraryId,
    String? wikipediaUrl,
    String? personalName,
    DateTime? birthDate,
    DateTime? deathDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AuthorDTO;

  factory AuthorDTO.fromJson(Map<String, dynamic> json) => _$AuthorDTOFromJson(json);
}
