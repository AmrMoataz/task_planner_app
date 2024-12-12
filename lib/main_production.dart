import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:local_storage_category_api/local_storage_category_api.dart';
import 'package:local_storage_tasks_api/local_storage_tasks_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_planner/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tasksApi = LocalStorageTasksApi(
    plugin: await SharedPreferences.getInstance(),
  );

   final categoryApi = LocalStorageCategoryApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(tasksApi: tasksApi, categoryApi: categoryApi);
}
