part of 'home_cubit.dart';

enum HomeTab { today, tasks, stats, categories }

final class HomeState extends Equatable {
  const HomeState({this.tab = HomeTab.today});

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
