import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/app_config.dart';

/// Session persistence key. Stores the epoch-ms at which the unlocked session
/// expires; absent/past means locked. Only a timestamp is stored — never the
/// password itself.
const String _sessionKey = 'ts_session_expiry';

/// Unlocked state for the static-password gate. `true` when the app is usable
/// (either no gate is configured, or a valid session exists / was just minted).
class AuthController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    if (!AppConfig.requiresLogin) return true;
    final prefs = await SharedPreferences.getInstance();
    final expiry = prefs.getInt(_sessionKey) ?? 0;
    return DateTime.now().millisecondsSinceEpoch < expiry;
  }

  /// Validates [password] against the configured static password. On success,
  /// mints a session lasting [AppConfig.sessionDays] and unlocks. Returns
  /// whether the password matched.
  Future<bool> submit(String password) async {
    if (password != AppConfig.appPassword) return false;
    final expiry = DateTime.now()
        .add(Duration(days: AppConfig.sessionDays))
        .millisecondsSinceEpoch;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionKey, expiry);
    state = const AsyncData(true);
    return true;
  }

  /// Clears the session and re-locks the app.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    state = const AsyncData(false);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, bool>(AuthController.new);
