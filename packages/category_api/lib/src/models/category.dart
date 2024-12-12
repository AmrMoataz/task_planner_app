import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends Equatable {
  Category({
    required this.name,
    required this.color,
    String? id,
  }) : assert(
          id == null || id.isNotEmpty,
          'id must either be null or not empty',
        ),
        id = id ?? const Uuid().v4();

  final String id;
  final String name;
  final String color;

  Category copyWith({
    String? id,
    String? name,
    String? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  /// Deserializes the given [JsonMap] into a [Category].
  static Category fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  /// Converts this [Category] into a [JsonMap].
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  List<Object?> get props => [id, name, color];
}
