import 'package:tasks_api/tasks_api.dart';

enum TasksViewFilter { all, activeOnly, completedOnly }

extension TasksViewFilterX on TasksViewFilter {
  bool apply(Task todo) {
    switch (this) {
      case TasksViewFilter.all:
        return true;
      case TasksViewFilter.activeOnly:
        return !todo.isCompleted;
      case TasksViewFilter.completedOnly:
        return todo.isCompleted;
    }
  }

  Iterable<Task> applyAll(Iterable<Task> todos) {
    return todos.where(apply);
  }
}
