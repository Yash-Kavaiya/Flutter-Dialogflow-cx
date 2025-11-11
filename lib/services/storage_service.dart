import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/message.dart';
import '../models/session.dart';

/// Service for local data storage and persistence
class StorageService {
  static const String _messagesKey = 'chat_messages';
  static const String _sessionKey = 'dialogflow_session';
  static const String _userPrefsKey = 'user_preferences';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Initialize storage service
  static Future<StorageService> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  /// Save messages to local storage
  Future<bool> saveMessages(List<Message> messages) async {
    try {
      final jsonList = messages.map((m) => m.toJson()).toList();
      final jsonString = json.encode(jsonList);
      return await _prefs.setString(_messagesKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Load messages from local storage
  Future<List<Message>> loadMessages() async {
    try {
      final jsonString = _prefs.getString(_messagesKey);
      if (jsonString == null) return [];

      final jsonList = json.decode(jsonString) as List;
      return jsonList
          .map((json) => Message.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Save current session
  Future<bool> saveSession(DialogflowSession session) async {
    try {
      final jsonString = json.encode(session.toJson());
      return await _prefs.setString(_sessionKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Load saved session
  Future<DialogflowSession?> loadSession() async {
    try {
      final jsonString = _prefs.getString(_sessionKey);
      if (jsonString == null) return null;

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return DialogflowSession.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  /// Clear all messages
  Future<bool> clearMessages() async {
    return await _prefs.remove(_messagesKey);
  }

  /// Clear session
  Future<bool> clearSession() async {
    return await _prefs.remove(_sessionKey);
  }

  /// Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  /// Save user preference
  Future<bool> savePreference(String key, dynamic value) async {
    final prefs = await _loadUserPreferences();
    prefs[key] = value;
    final jsonString = json.encode(prefs);
    return await _prefs.setString(_userPrefsKey, jsonString);
  }

  /// Load user preference
  Future<dynamic> loadPreference(String key, {dynamic defaultValue}) async {
    final prefs = await _loadUserPreferences();
    return prefs[key] ?? defaultValue;
  }

  /// Load all user preferences
  Future<Map<String, dynamic>> _loadUserPreferences() async {
    try {
      final jsonString = _prefs.getString(_userPrefsKey);
      if (jsonString == null) return {};

      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }
}
