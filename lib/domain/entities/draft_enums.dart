/// What kind of change a draft proposes.
enum DraftType {
  /// A brand-new item not present in the live inventory.
  newItem,

  /// A stock-count update for an existing live item.
  stockUpdate,

  /// A brand-new category not present in the live inventory.
  newCategory,
}

/// Lifecycle of a draft. Only [pending] drafts can be resolved.
enum DraftStatus {
  pending,
  approved,
  rejected,
}
