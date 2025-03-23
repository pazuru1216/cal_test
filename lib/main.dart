import 'package:calendar_test/const/color.dart';
import 'package:calendar_test/database/drift.dart';
import 'package:calendar_test/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = AppDatabase();
  GetIt.I.registerSingleton<AppDatabase>(database);

  final resp = await database.getSchedules();
  print('-----------------------------');
  print(resp);

  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}