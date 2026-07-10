import '../../core/errors/app_exception.dart';
import '../../domain/entities/draft.dart';
import '../../domain/entities/draft_enums.dart';
import '../../domain/repositories/draft_repository.dart';
import '../datasources/draft_data_source.dart';

/// Delegates to whichever [DraftDataSource] is wired in (Drift today),
/// translating storage failures into domain [StorageException]s.
class DraftRepositoryImpl implements DraftRepository {
  const DraftRepositoryImpl(this._dataSource);

  final DraftDataSource _dataSource;

  @override
  Stream<List<Draft>> watchPendingDrafts() =>
      _dataSource.watchPendingDrafts();

  @override
  Future<List<Draft>> getPendingDrafts() =>
      _guard(() => _dataSource.getPendingDrafts(), 'getPendingDrafts');

  @override
  Future<Draft?> getDraftById(int id) =>
      _guard(() => _dataSource.getDraftById(id), 'getDraftById');

  @override
  Future<List<Draft>> createDrafts(List<Draft> drafts) =>
      _guard(() => _dataSource.createDrafts(drafts), 'createDrafts');

  @override
  Future<Draft> updateDraft(Draft draft) =>
      _guard(() => _dataSource.updateDraft(draft), 'updateDraft');

  @override
  Future<Draft?> findPendingCategoryDraftByName(String name) => _guard(
        () => _dataSource.findPendingCategoryDraftByName(name),
        'findPendingCategoryDraftByName',
      );

  @override
  Future<List<Draft>> getPendingDraftsByType(DraftType type) => _guard(
        () => _dataSource.getPendingDraftsByType(type),
        'getPendingDraftsByType',
      );

  Future<T> _guard<T>(Future<T> Function() action, String operation) async {
    try {
      return await action();
    } on AppException {
      rethrow;
    } catch (e) {
      throw StorageException('$operation failed: $e');
    }
  }
}
