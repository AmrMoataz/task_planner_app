import 'package:category_repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_planner/home/view/home_page.dart';
import 'package:task_planner/theme/theme.dart';
import 'package:tasks_repository/tasks_repository.dart';

class App extends StatelessWidget {
  const App({required this.tasksRepository, required this.categoryRepository, super.key});

  final TasksRepository tasksRepository;
  final CategoryRepository categoryRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: categoryRepository),
        RepositoryProvider.value(value: tasksRepository),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterTasksTheme.light,
      darkTheme: FlutterTasksTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
