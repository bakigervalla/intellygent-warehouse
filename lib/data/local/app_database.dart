import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/entities/draft_enums.dart';

part 'app_database.g.dart';

@DataClassName('CategoryRow')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('ItemRow')
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get quantity => integer()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('DraftRow')
class Drafts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => intEnum<DraftType>()();
  IntColumn get status => intEnum<DraftStatus>()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get itemId => integer().nullable()();
  TextColumn get itemName => text().nullable()();
  IntColumn get categoryId => integer().nullable()();
  TextColumn get categoryName => text().nullable()();
  IntColumn get newCategoryDraftId => integer().nullable()();
  IntColumn get proposedCount => integer().nullable()();
  IntColumn get previousCount => integer().nullable()();
  RealColumn get confidence => real().nullable()();
}

@DriftDatabase(tables: [Categories, Items, Drafts])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          driftDatabase(
            name: 'intellygent_warehouse',
            web: DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.js'),
            ),
          ),
        );

  /// For unit tests with an in-memory executor.
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 1;
}
