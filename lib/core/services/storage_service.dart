import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/jar.dart';
import '../models/event.dart';

/// Local storage service using SharedPreferences
class StorageService {
  static const String _keyJar = 'jar';
  static const String _keyEvents = 'events';
  static const String _keyLocale = 'locale';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyReduceMotion = 'reduce_motion';

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
  // JAR
  // ============================================================================

  /// Save jar
  Future<bool> saveJar(Jar jar) async {
    final json = jsonEncode(jar.toMap());
    return prefs.setString(_keyJar, json);
  }

  /// Load jar
  Jar? loadJar() {
    final json = prefs.getString(_keyJar);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Jar.fromMap(map);
    } catch (e) {
      return null;
    }
  }

  /// Clear jar
  Future<bool> clearJar() async {
    return prefs.remove(_keyJar);
  }

  // ============================================================================
  // EVENTS
  // ============================================================================

  /// Save events
  Future<bool> saveEvents(List<Event> events) async {
    final jsonList = events.map((e) => e.toMap()).toList();
    final json = jsonEncode(jsonList);
    return prefs.setString(_keyEvents, json);
  }

  /// Load events
  List<Event> loadEvents() {
    final json = prefs.getString(_keyEvents);
    if (json == null) return [];

    try {
      final list = jsonDecode(json) as List;
      return list
          .map((item) => Event.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Add event
  Future<bool> addEvent(Event event) async {
    final events = loadEvents();
    events.insert(0, event); // Add to beginning
    return saveEvents(events);
  }

  /// Clear events
  Future<bool> clearEvents() async {
    return prefs.remove(_keyEvents);
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
  // UTILITIES
  // ============================================================================

  /// Clear all data
  Future<bool> clearAll() async {
    return prefs.clear();
  }

  /// Check if this is first launch
  bool isFirstLaunch() {
    return loadJar() == null;
  }
}
