import 'package:shared_preferences/shared_preferences.dart';

class CurrentBusinessService {
  final SharedPreferences _prefs;
  static const String _businessIdKey = 'current_business_id';

  CurrentBusinessService(this._prefs);

  /// Get the current business ID, defaulting to 1 (the default business)
  int get currentBusinessId {
    return _prefs.getInt(_businessIdKey) ?? 1;
  }

  /// Set the current business ID
  Future<void> setCurrentBusinessId(int id) async {
    await _prefs.setInt(_businessIdKey, id);
  }
}
