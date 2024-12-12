import 'package:tasks_api/tasks_api.dart';

final class OverviewCategory {
  const OverviewCategory({
    required this.id,
    required this.name,
    required this.color,
    this.tasks = const [],
  });

  final String id;
  final String name;
  final String color;
  final List<Task> tasks;
}