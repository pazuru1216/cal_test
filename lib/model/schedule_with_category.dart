import 'package:calendar_test/model/category.dart';
import 'package:calendar_test/model/schedule.dart';
import 'package:calendar_test/database/drift.dart';

class ScheduleWithCategory{
  final CategoryTableData category;
  final ScheduleTableData schedule;

  ScheduleWithCategory({
    required this.category,
    required this.schedule,
});
}