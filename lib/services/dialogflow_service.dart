import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/app_config.dart';
import '../models/dialogflow_response.dart';
import '../models/session.dart';

/// Service for interacting with Dialogflow CX API
class DialogflowService {
  final AppConfig config;
  final Logger logger;
  String? _accessToken;
  DateTime? _tokenExpiry;

  DialogflowService({
    required this.config,
    Logger? logger,
  }) : logger = logger ?? Logger();

  /// Base URL for Dialogflow CX API
  String get _baseUrl =>
      'https://${config.locationId}-dialogflow.googleapis.com/v3';

  /// Detect intent from user text input
  Future<DialogflowResponse> detectIntent({
    required DialogflowSession session,
    required String text,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/${session.sessionPath}:detectIntent',
      );

      final requestBody = {
        'queryInput': {
          'text': {
            'text': text,
          },
          'languageCode': config.languageCode,
        },
        if (parameters != null)
          'queryParams': {
            'parameters': parameters,
          },
      };

      logger.d('Sending detectIntent request: $requestBody');

      final response = await http
          .post(
            url,
            headers: await _getHeaders(),
            body: json.encode(requestBody),
          )
          .timeout(Duration(milliseconds: config.requestTimeout));

      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;
        return DialogflowResponse.fromJson(jsonResponse);
      } else {
        throw DialogflowException(
          'Failed to detect intent: ${response.statusCode} - ${response.body}',
        );
      }
    } on TimeoutException {
      throw DialogflowException('Request timeout. Please try again.');
    } catch (e) {
      logger.e('Error detecting intent: $e');
      rethrow;
    }
  }

  /// Stream detect intent for real-time responses
  Stream<DialogflowResponse> streamDetectIntent({
    required DialogflowSession session,
    required String text,
    Map<String, dynamic>? parameters,
  }) async* {
    try {
      final response = await detectIntent(
        session: session,
        text: text,
        parameters: parameters,
      );
      yield response;
    } catch (e) {
      logger.e('Error in stream detect intent: $e');
      rethrow;
    }
  }

  /// Get authentication headers
  Future<Map<String, String>> _getHeaders() async {
    // In production, implement proper OAuth2 authentication
    // For now, we'll use a mock implementation
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _getAccessToken()}',
    };
  }

  /// Get or refresh access token
  Future<String> _getAccessToken() async {
    // Check if token is still valid
    if (_accessToken != null &&
        _tokenExpiry != null &&
        _tokenExpiry!.isAfter(DateTime.now())) {
      return _accessToken!;
    }

    // In production, implement proper OAuth2 flow
    // This is a placeholder that should be replaced with actual authentication
    // using googleapis_auth or similar package

    // For demo purposes, return a mock token
    // TODO: Implement proper authentication with service account credentials
    _accessToken = 'MOCK_ACCESS_TOKEN_REPLACE_WITH_REAL_TOKEN';
    _tokenExpiry = DateTime.now().add(const Duration(hours: 1));

    logger.w('Using mock access token. Implement proper OAuth2 authentication!');

    return _accessToken!;
  }

  /// Validate session
  Future<bool> validateSession(DialogflowSession session) async {
    try {
      // In production, implement session validation logic
      logger.d('Validating session: ${session.sessionId}');
      return true;
    } catch (e) {
      logger.e('Error validating session: $e');
      return false;
    }
  }

  /// Clear cached token (useful for logout)
  void clearToken() {
    _accessToken = null;
    _tokenExpiry = null;
  }
}

/// Custom exception for Dialogflow errors
class DialogflowException implements Exception {
  final String message;
  final dynamic originalError;

  DialogflowException(this.message, [this.originalError]);

  @override
  String toString() => 'DialogflowException: $message';
}
