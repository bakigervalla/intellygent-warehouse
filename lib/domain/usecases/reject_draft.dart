import '../../core/errors/app_exception.dart';
import '../entities/draft_enums.dart';
import '../repositories/draft_repository.dart';

/// Marks a pending draft rejected. Rejected drafts never touch the live
/// inventory. Rejecting a newCategory draft leaves dependent newItem drafts
/// pending — on approval they fall back to "Uncategorized".
class RejectDraft {
  const RejectDraft(this._drafts);

  final DraftRepository _drafts;

  Future<void> call(int draftId) async {
    final draft = await _drafts.getDraftById(draftId);
    if (draft == null) {
      throw const DomainRuleException(
        'Draft not found',
        'This draft no longer exists.',
      );
    }
    if (draft.status != DraftStatus.pending) {
      throw DomainRuleException(
        'Draft ${draft.id} already ${draft.status.name}',
        'This draft was already resolved.',
      );
    }
    await _drafts.updateDraft(draft.copyWith(status: DraftStatus.rejected));
  }
}
