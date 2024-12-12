import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/category_overview/view/category_overview_page.dart';
import 'package:task_planner/edit_task/view/view.dart';
import 'package:task_planner/home/cubit/home_cubit.dart';
import 'package:task_planner/stats/view/view.dart';
import 'package:task_planner/tasks_overview/view/view.dart';
import 'package:task_planner/todays_tasks/view/todays_tasks_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);
    final pageController = PageController(initialPage: selectedTab.index);

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => context.read<HomeCubit>().setTab(HomeTab.values[index]),
        children: const [TodaysTasksOverviewPage(), TasksOverviewPage(), StatsPage(), CategoryOverviewPage()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        key: const Key('homeView_addTask_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(EditTaskPage.route()),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.today,
              icon: const Icon(Icons.today_rounded),
              pageController: pageController,
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.tasks,
              icon: const Icon(Icons.view_list_rounded),
              pageController: pageController,
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.stats,
              icon: const Icon(Icons.bar_chart_rounded),
              pageController: pageController,
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.categories,
              icon: const Icon(Icons.category_rounded),
              pageController: pageController,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
    required this.pageController,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => pageController.jumpToPage(value.index),
      iconSize: 32,
      color:
          groupValue != value ? null : Theme.of(context).colorScheme.secondaryContainer,
      icon: icon,
    );
  }
}
