import 'package:drift/drift.dart';

import '../../domain/entities/draft.dart';
import '../../domain/entities/draft_enums.dart';
import '../datasources/draft_data_source.dart';
import 'app_database.dart';
import 'entity_mappers.dart';

class DriftDraftDataSource implements DraftDataSource {
  const DriftDraftDataSource(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Draft>> watchPendingDrafts() {
    final query = _db.select(_db.drafts)
      ..where((t) => t.status.equalsValue(DraftStatus.pending))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().map(
          (rows) => rows.map((r) => r.toEntity()).toList(),
        );
  }

  @override
  Future<List<Draft>> getPendingDrafts() async {
    final rows = await (_db.select(_db.drafts)
          ..where((t) => t.status.equalsValue(DraftStatus.pending)))
        .get();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<Draft?> getDraftById(int id) async {
    final row = await (_db.select(_db.drafts)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<List<Draft>> createDrafts(List<Draft> drafts) async {
    final created = <Draft>[];
    await _db.transaction(() async {
      for (final draft in drafts) {
        final id =
            await _db.into(_db.drafts).insert(draft.toCompanion());
        created.add(draft.copyWith(id: id));
      }
    });
    return created;
  }

  @override
  Future<Draft> updateDraft(Draft draft) async {
    await _db.update(_db.drafts).replace(draft.toCompanion());
    return draft;
  }

  @override
  Future<Draft?> findPendingCategoryDraftByName(String name) async {
    final row = await (_db.select(_db.drafts)
          ..where(
            (t) =>
                t.type.equalsValue(DraftType.newCategory) &
                t.status.equalsValue(DraftStatus.pending) &
                t.categoryName.lower().equals(name.trim().toLowerCase()),
          )
          ..limit(1))
        .getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<List<Draft>> getPendingDraftsByType(DraftType type) async {
    final rows = await (_db.select(_db.drafts)
          ..where(
            (t) =>
                t.type.equalsValue(type) &
                t.status.equalsValue(DraftStatus.pending),
          ))
        .get();
    return rows.map((r) => r.toEntity()).toList();
  }
}
