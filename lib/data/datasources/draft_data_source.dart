import '../../domain/entities/draft.dart';
import '../../domain/entities/draft_enums.dart';

/// Storage seam for drafts, mirroring [InventoryDataSource]'s role.
abstract interface class DraftDataSource {
  Stream<List<Draft>> watchPendingDrafts();
  Future<List<Draft>> getPendingDrafts();
  Future<Draft?> getDraftById(int id);
  Future<List<Draft>> createDrafts(List<Draft> drafts);
  Future<Draft> updateDraft(Draft draft);
  Future<Draft?> findPendingCategoryDraftByName(String name);
  Future<List<Draft>> getPendingDraftsByType(DraftType type);
}
