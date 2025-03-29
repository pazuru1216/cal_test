import 'package:drift/drift.dart';

class CategoryTable extends Table{
  IntColumn get id => integer().autoIncrement()();

  TextColumn get color => text()();

  IntColumn get randomNumber => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().clientDefault(
          ()=>DateTime.now().toUtc()
  )();
}