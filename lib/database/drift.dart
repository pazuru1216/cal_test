import 'dart:ffi';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:calendar_test/model/schedule.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

///밑에 있는 애노테이션을 기반으로 ~.dart파일을 생성해줌.
part 'drift.g.dart';

/// @ > 에노테이션
@DriftDatabase(
  /// 생성할 테이블은 이 리스트에 넣어주면 된다.
  tables: [ScheduleTable]
)
class AppDatabase extends _$AppDatabase{
  AppDatabase() : super(_openConnection());

  ///query 작성
  ///ScheduleTable을 만들면 ScheduleTableData를 drift.g.dart가 자동으로 만들어
  Future<List<ScheduleTableData>> getSchedules() => select(scheduleTable).get();

  /// 무언가를 생성하면 생성한 값에 대한 id값이 자동적으로 생성된다. 그게 int 값임.
  /// 값을 업데이트하거나 데이터 생성할때 사용되는 ~Companion >> 얘도 자동생성되는 값
  /// 값을 받아올때는 ~Data
  /// into(table명)
  Future<int> createSchedule(ScheduleTableCompanion data) => into(scheduleTable).insert(data);


  @override
  /// schema table들을 버젼으로 관리한다.
  int get schemaVersion => 1;
}

LazyDatabase _openConnection(){
  return LazyDatabase(() async{
    /// 핸드폰마다 어플을 설치하면 자체적으로 제공해주는 폴더가 있는데
    /// 그 폴더 위치를 가져오는 getApplicationDocumentsDirectory
    final dbFolder = await getApplicationDocumentsDirectory();
    ///File은 꼭 dart.io에서 불러올것. htmlㄴㄴ
    /// C:\\User\flutter 윈도우 기반
    /// /User/flutter/
    /// /Users/flutter + /name/orange/
    /// /Users/flutter/name/orange/
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if(Platform.isAndroid){
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