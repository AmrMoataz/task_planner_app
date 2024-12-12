import 'package:flutter/material.dart';
import 'package:tasks_api/tasks_api.dart';

extension TaskQuadrantIconX on Task {
  IconData get quadrantIcon => switch (quadrant) {
    TaskQuadrant.Quandrant1 => Icons.looks_one_rounded,
    TaskQuadrant.Quandrant2 => Icons.looks_two_rounded,
    TaskQuadrant.Quandrant3 => Icons.looks_3_rounded,
    TaskQuadrant.Quandrant4 => Icons.looks_4_rounded,
  };
}