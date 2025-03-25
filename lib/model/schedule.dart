import 'package:calendar_test/model/category.dart';
import 'package:drift/drift.dart';

class ScheduleTable extends Table {
  /// 1) 식별 가능한 ID, 자동적으로 1씩 증가하게 만들었다.
  IntColumn get id => integer().autoIncrement()();

  /// 2) 시작 시간
  IntColumn get startTime => integer()();

  /// 3) 종료 시간
  IntColumn get endTime => integer()();

  /// 4) 일정 내용
  TextColumn get content => text()();

  /// 5) 날짜
  DateTimeColumn get date => dateTime()();

  /// 6) 카테고리
  // TextColumn get color => text()();
  IntColumn get colorId => integer().references(
        CategoryTable,
        #id,
      )();

  /// 7) 일정 생성날짜시간
  /// 입력이 될때마다 생성된 시간이 자동으로 저장됨.
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}
