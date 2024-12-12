import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:category_api/category_api.dart';
import 'package:category_repository/category_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:task_planner/app/view/app.dart';
import 'package:task_planner/app_bloc_observer.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

void bootstrap({required TasksApi tasksApi, required CategoryApi categoryApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString(), stackTrace: stack);
    return true;
  };

  Bloc.observer = const AppBlocObserver();

  final tasksRepository = TasksRepository(tasksApi: tasksApi);
  final categoryRepository = CategoryRepository(categoryApi: categoryApi);

  runApp(App(tasksRepository: tasksRepository, categoryRepository: categoryRepository));
}
