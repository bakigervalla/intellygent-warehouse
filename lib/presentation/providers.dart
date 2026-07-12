import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/ai/openai_recognition_service.dart';
import '../data/datasources/draft_data_source.dart';
import '../data/datasources/inventory_data_source.dart';
import '../data/local/app_database.dart';
import '../data/local/drift_draft_data_source.dart';
import '../data/local/drift_inventory_data_source.dart';
import '../data/repositories/draft_repository_impl.dart';
import '../data/repositories/inventory_repository_impl.dart';
import '../domain/entities/category.dart';
import '../domain/entities/draft.dart';
import '../domain/entities/item.dart';
import '../domain/repositories/draft_repository.dart';
import '../domain/repositories/inventory_repository.dart';
import '../domain/services/ai_recognition_service.dart';
import '../domain/usecases/approve_draft.dart';
import '../domain/usecases/create_drafts_from_scan.dart';
import '../domain/usecases/recognize_scan.dart';
import '../domain/usecases/reject_draft.dart';
import 'setup/llm_settings_controller.dart';

/// Composition root. Swapping the local store for a remote one, or the AI
/// vendor, means overriding a provider here — nothing else changes.

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final inventoryDataSourceProvider = Provider<InventoryDataSource>(
  (ref) => DriftInventoryDataSource(ref.watch(appDatabaseProvider)),
);

final draftDataSourceProvider = Provider<DraftDataSource>(
  (ref) => DriftDraftDataSource(ref.watch(appDatabaseProvider)),
);

final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (ref) => InventoryRepositoryImpl(ref.watch(inventoryDataSourceProvider)),
);

final draftRepositoryProvider = Provider<DraftRepository>(
  (ref) => DraftRepositoryImpl(ref.watch(draftDataSourceProvider)),
);

final aiRecognitionServiceProvider = Provider<AiRecognitionService>(
  (ref) {
    // Rebuilds whenever the user changes provider/model in Setup. Falls back
    // to the app default until the persisted settings finish loading.
    final settings = ref.watch(llmSettingsProvider).value;
    return OpenAiRecognitionService(settings: settings);
  },
);

final recognizeScanProvider = Provider<RecognizeScan>(
  (ref) => RecognizeScan(ref.watch(aiRecognitionServiceProvider)),
);

final createDraftsFromScanProvider = Provider<CreateDraftsFromScan>(
  (ref) => CreateDraftsFromScan(
    ref.watch(inventoryRepositoryProvider),
    ref.watch(draftRepositoryProvider),
  ),
);

final approveDraftProvider = Provider<ApproveDraft>(
  (ref) => ApproveDraft(
    ref.watch(inventoryRepositoryProvider),
    ref.watch(draftRepositoryProvider),
  ),
);

final rejectDraftProvider = Provider<RejectDraft>(
  (ref) => RejectDraft(ref.watch(draftRepositoryProvider)),
);

final categoriesProvider = StreamProvider<List<Category>>(
  (ref) => ref.watch(inventoryRepositoryProvider).watchCategories(),
);

final itemsProvider = StreamProvider<List<Item>>(
  (ref) => ref.watch(inventoryRepositoryProvider).watchItems(),
);

final pendingDraftsProvider = StreamProvider<List<Draft>>(
  (ref) => ref.watch(draftRepositoryProvider).watchPendingDrafts(),
);
