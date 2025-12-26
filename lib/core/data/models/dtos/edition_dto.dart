import 'package:freezed_annotation/freezed_annotation.dart';

part 'edition_dto.freezed.dart';
part 'edition_dto.g.dart';

@freezed
class EditionDTO with _$EditionDTO {
  const factory EditionDTO({
    required String id,
    required String workId,
    String? isbn,
    String? isbn10,
    String? isbn13,
    String? publisher,
    int? publishedYear,
    String? coverImageURL,
    String? format,
    int? pageCount,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EditionDTO;

  factory EditionDTO.fromJson(Map<String, dynamic> json) => _$EditionDTOFromJson(json);
}
