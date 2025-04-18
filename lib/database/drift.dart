import 'dart:io';
import 'package:calendar_test/model/schedule_with_category.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:calendar_test/model/schedule.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:calendar_test/model/category.dart';

///밑에 있는 애노테이션을 기반으로 ~.dart파일을 생성해줌.
part 'drift.g.dart';

/// @ > 에노테이션
/// 생성할 테이블은 이 리스트에 넣어주면 된다.
@DriftDatabase(tables: [
  ScheduleTable,
  CategoryTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  Future<int> createCategory(CategoryTableCompanion data) =>
      into(categoryTable).insert(data);

  Future<List<CategoryTableData>> getCategories() =>
      select(categoryTable).get();

  Future<ScheduleWithCategory> getScheduleById(int id) {
    final query = select(scheduleTable).join([
      innerJoin(
        categoryTable,
        categoryTable.id.equalsExp(
          scheduleTable.colorId,
        ),
      ),
    ])
      ..where(scheduleTable.id.equals(id));

    return query.map((row) {
      final schedule = row.readTable(scheduleTable);
      final category = row.readTable(categoryTable);

      return ScheduleWithCategory(category: category, schedule: schedule);
    }).getSingle();
  }

  Future<int> updateScheduleById(int id, ScheduleTableCompanion data) =>
      (update(scheduleTable)..where((table) => table.id.equals(id)))
          .write(data);

  Future<List<ScheduleTableData>> getSchedules(
    DateTime date,
  ) =>
      (select(scheduleTable)..where((table) => table.date.equals(date))).get();

  ///query 작성
  ///ScheduleTable을 만들면 ScheduleTableData를 drift.g.dart가 자동으로 만들어줌
  ///1번 가져오는 Future은 get
  ///계속해서 바라보다가 변화가 있으면 반영하는 Stream은 watch
  Stream<List<ScheduleWithCategory>> streamSchedules(
    DateTime date,
  ) {
    final query = select(scheduleTable).join([
      innerJoin(
        categoryTable,
        categoryTable.id.equalsExp(
          scheduleTable.colorId,
        ),
      ),
    ])
      ..where(scheduleTable.date.equals(date));

    return query.map((row) {
      final schedule = row.readTable(scheduleTable);
      final category = row.readTable(categoryTable);

      return ScheduleWithCategory(category: category, schedule: schedule);
    }).watch();
  }

  /// 무언가를 생성하면 생성한 값에 대한 id값이 자동적으로 생성된다. 그게 int 값임.
  /// 값을 업데이트하거나 데이터 생성할때 사용되는 ~Companion >> 얘도 자동생성되는 값
  /// 값을 받아올때는 ~Data
  /// into(table명)
  Future<int> createSchedule(ScheduleTableCompanion data) =>
      into(scheduleTable).insert(data);

  /// 삭제한 값의 id를 받아볼 수 있기때문에 타입은 int
  Future<int> removeSchedule(int id) => (delete(scheduleTable)
        ..where(
          (table) => table.id.equals(id),
        ))
      .go();

  /// schema table들을 버젼으로 관리한다.
  @override
  int get schemaVersion => 2;

  @override
  ///migrator : migration에 필요한 모든 기능을 제공해준다.
  /// int from : 설치되어있는 스키마 버전
  /// int to : 업데이트해야할 스키마 버전
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (Migrator m, int from, int to) async {
        if(from<2){
          await m.addColumn(categoryTable, categoryTable.randomNumber);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    /// 핸드폰마다 어플을 설치하면 자체적으로 제공해주는 폴더가 있는데
    /// 그 폴더 위치를 가져오는 getApplicationDocumentsDirectory
    final dbFolder = await getApplicationDocumentsDirectory();

    ///File은 꼭 dart.io에서 불러올것. htmlㄴㄴ
    /// C:\\User\flutter 윈도우 기반
    /// /User/flutter/
    /// /Users/flutter + /name/orange/
    /// /Users/flutter/name/orange/
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      /// 옛날버전의 안드로이드 오류 해결해주는 코드
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    ///sqlite가 임시파일 폴더의 위치를 모를까봐 지정해주는것.
    ///얘가 없어도 실행은 된다.
    final cachebase = await getTemporaryDirectory();

    /// 쓸데없는 캐시를 저장함
    sqlite3.tempDirectory = cachebase.path;

    ///file안에 데이터베이스를 만들어라
    return NativeDatabase.createInBackground(file);
  });
}
