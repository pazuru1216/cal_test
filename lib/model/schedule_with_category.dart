import 'package:calendar_test/model/category.dart';
import 'package:calendar_test/model/schedule.dart';

class ScheduleWithCategory{
  final CategoryTable category;
  final ScheduleTable schedule;

  ScheduleWithCategory({
    required this.category,
    required this.schedule,
});
}