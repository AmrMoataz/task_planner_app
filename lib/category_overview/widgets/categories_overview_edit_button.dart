import 'package:flutter/material.dart';
import 'package:task_planner/edit_category/view/edit_category_page.dart';
import 'package:task_planner/l10n/l10n.dart';

class CategoriesOverviewEditButton extends StatelessWidget {
  const CategoriesOverviewEditButton({super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return IconButton(
      icon: const Icon(Icons.add_rounded),
      onPressed: () => Navigator.of(context).push(EditCategoryPage.route()),
      tooltip: l10n.categoriesOverviewEditButtonTooltip,
    );
  }
}