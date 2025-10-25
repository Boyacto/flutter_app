import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/jar_v2.dart';
import '../models/user_balance.dart';
import '../models/game.dart';
import '../models/account.dart';

/// Local storage service using SharedPreferences
class StorageService {
  static const String _keyLocale = 'locale';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyReduceMotion = 'reduce_motion';

  // OneUp keys
  static const String _keyJarsV2 = 'jars_v2';
  static const String _keyUserBalance = 'user_balance';
  static const String _keyGameState = 'game_state';
  static const String _keyAccounts = 'accounts';

  SharedPreferences? _prefs;

  /// Initialize the storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Ensure prefs is initialized
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // ============================================================================
  // SETTINGS
  // ============================================================================

  /// Save locale
  Future<bool> saveLocale(String locale) async {
    return prefs.setString(_keyLocale, locale);
  }

  /// Load locale
  String loadLocale() {
    return prefs.getString(_keyLocale) ?? 'en_US';
  }

  /// Save theme mode ('light', 'dark', 'system')
  Future<bool> saveThemeMode(String mode) async {
    return prefs.setString(_keyThemeMode, mode);
  }

  /// Load theme mode
  String loadThemeMode() {
    return prefs.getString(_keyThemeMode) ?? 'system';
  }

  /// Save reduce motion preference
  Future<bool> saveReduceMotion(bool value) async {
    return prefs.setBool(_keyReduceMotion, value);
  }

  /// Load reduce motion preference
  bool loadReduceMotion() {
    return prefs.getBool(_keyReduceMotion) ?? false;
  }

  // ============================================================================
  // ONEUP - USER BALANCE
  // ============================================================================

  /// Save user balance
  Future<bool> saveUserBalance(UserBalance balance) async {
    final json = jsonEncode(balance.toJson());
    return prefs.setString(_keyUserBalance, json);
  }

  /// Load user balance
  UserBalance? loadUserBalance() {
    final json = prefs.getString(_keyUserBalance);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return UserBalance.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  // ============================================================================
  // ONEUP - JARS V2
  // ============================================================================

  /// Save jars
  Future<bool> saveJarsV2(List<JarV2> jars) async {
    final jsonList = jars.map((j) => j.toJson()).toList();
    final json = jsonEncode(jsonList);
    return prefs.setString(_keyJarsV2, json);
  }

  /// Load jars
  List<JarV2>? loadJarsV2() {
    final json = prefs.getString(_keyJarsV2);
    if (json == null) return null;

    try {
      final list = jsonDecode(json) as List;
      return list
          .map((item) => JarV2.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }

  // ============================================================================
  // ONEUP - ACCOUNTS
  // ============================================================================

  /// Save accounts
  Future<bool> saveAccounts(List<Account> accounts) async {
    final jsonList = accounts.map((a) => a.toJson()).toList();
    final json = jsonEncode(jsonList);
    return prefs.setString(_keyAccounts, json);
  }

  /// Load accounts
  List<Account>? loadAccounts() {
    final json = prefs.getString(_keyAccounts);
    if (json == null) return null;

    try {
      final list = jsonDecode(json) as List;
      return list
          .map((item) => Account.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }

  // ============================================================================
  // ONEUP - GAME STATE
  // ============================================================================

  /// Save game state
  Future<bool> saveGameState(Game game) async {
    final json = jsonEncode(game.toJson());
    return prefs.setString(_keyGameState, json);
  }

  /// Load game state
  Game? loadGameState() {
    final json = prefs.getString(_keyGameState);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Game.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  // ============================================================================
  // UTILITIES
  // ============================================================================

  /// Clear all data
  Future<bool> clearAll() async {
    return prefs.clear();
  }

  /// Check if this is first launch
  bool isFirstLaunch() {
    return loadJarsV2() == null;
  }
}
