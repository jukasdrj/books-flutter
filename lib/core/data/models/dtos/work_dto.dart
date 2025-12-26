import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_dto.freezed.dart';
part 'work_dto.g.dart';

@freezed
class WorkDTO with _$WorkDTO {
  const factory WorkDTO({
    required String id,
    required String title,
    String? author, // Denormalized author field
    @Default([]) List<String> authorIds,
    @Default([]) List<String> subjectTags,
    @Default(false) bool synthetic,
    String? reviewStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WorkDTO;

  factory WorkDTO.fromJson(Map<String, dynamic> json) => _$WorkDTOFromJson(json);
}
