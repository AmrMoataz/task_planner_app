import 'package:category_api/category_api.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tasks_api/src/models/json_map.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@JsonEnum()
enum TaskQuadrant {Quandrant1, Quandrant2, Quandrant3, Quandrant4}
@JsonEnum()
enum TaskPriority {High, Medium, Low}

/// {@template task_item}
/// A single `task` item.
///
/// Contains a [title], [description] and [id], in addition to a [isCompleted]
/// flag.
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Task]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@JsonSerializable()
class Task extends Equatable {
  /// {@macro task_item}
  Task({
    required this.title,
    required this.category,
    required this.quadrant,
    required this.priority,
    String? id,
    this.description = '',
    this.isCompleted = false,
    this.due,
  })  : assert(
          id == null || id.isNotEmpty,
          'id must either be null or not empty',
        ),
        id = id ?? const Uuid().v4();

  /// The unique identifier of the `task`.
  ///
  /// Cannot be empty.
  final String id;

  /// The title of the `task`.
  ///
  /// Note that the title may be empty.
  final String title;

  /// The description of the `task`.
  ///
  /// Defaults to an empty string.
  final String description;

  /// Whether the `task` is completed.
  ///
  /// Defaults to `false`.
  final bool isCompleted;

  /// The category of the `task`.
  ///
  /// cannot be empty.
  final Category category;

  /// The quadrant of the `task`.
  ///
  /// cannot be empty.
  final TaskQuadrant quadrant;

  /// The due date of the `task`.
  ///
  /// cannot be empty.
  final DateTime? due;

  /// The priority of the `task`.
  ///
  /// cannot be empty.
  final TaskPriority priority;

  /// Returns a copy of this `task` with the given values updated.
  ///
  /// {@macro task_item}
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    Category? category,
    TaskQuadrant? quadrant,
    DateTime? due,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      quadrant: quadrant ?? this.quadrant,
      due: due ?? this.due,
      priority: priority ?? this.priority,
    );
  }

  /// Deserializes the given [JsonMap] into a [Task].
  static Task fromJson(JsonMap json) => _$TaskFromJson(json);

  /// Converts this [Task] into a [JsonMap].
  JsonMap toJson() => _$TaskToJson(this);

  @override
  List<Object?> get props => [id, title, description, isCompleted, category, quadrant, due, priority];
}
