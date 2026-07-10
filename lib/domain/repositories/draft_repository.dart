import '../entities/draft.dart';
import '../entities/draft_enums.dart';

/// Draft (proposed change) access. Drafts are the only path through which
/// the live inventory ever changes.
abstract interface class DraftRepository {
  Stream<List<Draft>> watchPendingDrafts();

  Future<List<Draft>> getPendingDrafts();

  Future<Draft?> getDraftById(int id);

  /// Persists a batch of new drafts, returns them with ids assigned.
  Future<List<Draft>> createDrafts(List<Draft> drafts);

  Future<Draft> updateDraft(Draft draft);

  /// Pending newCategory drafts matching [name] case-insensitively.
  Future<Draft?> findPendingCategoryDraftByName(String name);

  /// All pending drafts of a given type.
  Future<List<Draft>> getPendingDraftsByType(DraftType type);
}
