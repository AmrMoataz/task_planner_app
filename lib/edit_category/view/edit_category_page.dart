import 'package:category_api/category_api.dart';
import 'package:category_repository/category_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/edit_category/bloc/edit_category_bloc.dart';
import 'package:task_planner/l10n/l10n.dart';

class EditCategoryPage extends StatelessWidget {
  const EditCategoryPage({super.key});

  static Route<void> route({Category? initialCategory}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider<EditCategoryBloc>(
        create: (context) => EditCategoryBloc(
          initialCategory: initialCategory,
          categoryRepository: context.read<CategoryRepository>(),
        ),
        child: const EditCategoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditCategoryBloc, EditCategoryState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditCategoryStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditCategoryView(),
    );
  }
}

class EditCategoryView extends StatelessWidget {
  const EditCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((EditCategoryBloc bloc) => bloc.state.status);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editCategoryAppBarTitle),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editCategorySaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context
                .read<EditCategoryBloc>()
                .add(const EditCategorySubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NameField(),
                SizedBox(height: 20),
                _ColorPicker(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditCategoryBloc>().state;
    final hintText = state.initialCategory?.name ?? '';

    return TextFormField(
      key: const Key('editCategoryView_title_textFormField'),
      initialValue: state.name,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editCategoryNameLabel,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      onChanged: (value) {
        context
            .read<EditCategoryBloc>()
            .add(EditCategoryNameChanged(name: value));
      },
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditCategoryBloc>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.editCategoryColorLabel),
        const SizedBox(height: 20),
        Wrap(
          spacing: 15,
          children: [
            '#4CAF50', // Green
            '#2196F3', // Blue
            '#FFC107', // Amber
            '#E91E63', // Pink
            '#9C27B0', // Purple
            '#FF5722', // Deep Orange
          ]
              .map((color) => GestureDetector(
                    onTap: () => context
                        .read<EditCategoryBloc>()
                        .add(EditCategoryColorChanged(color: color)),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(int.parse(color.substring(1), radix: 16) |
                            0xFF000000,),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: state.color == color
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.transparent,
                          width: 5,
                        ),
                      ),
                    ),
                  ),)
              .toList(),
        ),
      ],
    );
  }
}
