import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/app_exception.dart';
import '../providers.dart';

final draftActionsControllerProvider =
    NotifierProvider<DraftActionsController, DraftActionsState>(
  DraftActionsController.new,
);

/// Outcome surface for approve/reject actions (busy flag + last error).
class DraftActionsState {
  const DraftActionsState({this.isBusy = false, this.errorMessage});

  final bool isBusy;
  final String? errorMessage;
}

class DraftActionsController extends Notifier<DraftActionsState> {
  @override
  DraftActionsState build() => const DraftActionsState();

  Future<void> approve(int draftId) =>
      _run(() => ref.read(approveDraftProvider).call(draftId));

  Future<void> reject(int draftId) =>
      _run(() => ref.read(rejectDraftProvider).call(draftId));

  Future<void> approveAll(List<int> draftIds) => _run(() async {
        for (final id in draftIds) {
          try {
            await ref.read(approveDraftProvider).call(id);
          } on DomainRuleException {
            // Already resolved via a cascade (e.g. category approved by its
            // item) — safe to skip.
          }
        }
      });

  Future<void> _run(Future<void> Function() action) async {
    state = const DraftActionsState(isBusy: true);
    try {
      await action();
      state = const DraftActionsState();
    } on AppException catch (e) {
      state = DraftActionsState(errorMessage: e.userMessage);
    } catch (_) {
      state = const DraftActionsState(
        errorMessage: 'Could not apply this change. Please try again.',
      );
    }
  }
}
