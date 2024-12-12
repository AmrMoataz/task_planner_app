// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      title: json['title'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      quadrant: $enumDecode(_$TaskQuadrantEnumMap, json['quadrant']),
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      id: json['id'] as String?,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      due: json['due'] == null ? null : DateTime.parse(json['due'] as String),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'category': instance.category,
      'quadrant': _$TaskQuadrantEnumMap[instance.quadrant]!,
      'due': instance.due?.toIso8601String(),
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
    };

const _$TaskQuadrantEnumMap = {
  TaskQuadrant.Quandrant1: 'Quandrant1',
  TaskQuadrant.Quandrant2: 'Quandrant2',
  TaskQuadrant.Quandrant3: 'Quandrant3',
  TaskQuadrant.Quandrant4: 'Quandrant4',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.High: 'High',
  TaskPriority.Medium: 'Medium',
  TaskPriority.Low: 'Low',
};
