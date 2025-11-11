import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';
import '../models/message.dart';
import '../models/session.dart';
import '../models/app_config.dart';
import '../services/dialogflow_service.dart';
import '../services/storage_service.dart';

/// Chat state management provider
class ChatProvider with ChangeNotifier {
  final DialogflowService _dialogflowService;
  final StorageService _storageService;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();

  List<Message> _messages = [];
  DialogflowSession? _session;
  bool _isLoading = false;
  bool _isTyping = false;
  String? _error;
  bool _isInitialized = false;
  AppConfig? _config;

  ChatProvider({
    required DialogflowService dialogflowService,
    required StorageService storageService,
  })  : _dialogflowService = dialogflowService,
        _storageService = storageService;

  // Getters
  List<Message> get messages => List.unmodifiable(_messages);
  DialogflowSession? get session => _session;
  bool get isLoading => _isLoading;
  bool get isTyping => _isTyping;
  String? get error => _error;
  bool get isInitialized => _isInitialized;
  AppConfig? get config => _config;

  /// Initialize chat provider
  Future<void> initialize(AppConfig config) async {
    if (_isInitialized) return;

    try {
      _config = config;
      _logger.i('Initializing chat provider...');

      // Load saved session
      _session = await _storageService.loadSession();

      // Create new session if none exists
      if (_session == null) {
        _session = DialogflowSession(
          sessionId: _uuid.v4(),
          projectId: config.projectId,
          locationId: config.locationId,
          agentId: config.agentId,
          createdAt: DateTime.now(),
        );
        await _storageService.saveSession(_session!);
      }

      // Load saved messages
      _messages = await _storageService.loadMessages();

      _isInitialized = true;
      _logger.i('Chat provider initialized successfully');
      notifyListeners();
    } catch (e) {
      _logger.e('Error initializing chat provider: $e');
      _error = 'Failed to initialize chat: $e';
      notifyListeners();
    }
  }

  /// Send a message to Dialogflow CX
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _session == null) return;

    // Clear any previous errors
    _error = null;

    // Create user message
    final userMessage = Message(
      id: _uuid.v4(),
      text: text.trim(),
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    // Add user message to list
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    // Save messages
    await _storageService.saveMessages(_messages);

    try {
      // Show typing indicator
      _isTyping = true;
      notifyListeners();

      // Simulate network delay for better UX
      await Future.delayed(const Duration(milliseconds: 300));

      // Send to Dialogflow CX
      final response = await _dialogflowService.detectIntent(
        session: _session!,
        text: text,
      );

      // Hide typing indicator
      _isTyping = false;

      // Process response and add bot messages
      if (response.queryResult != null) {
        final botMessages = response.queryResult!.toMessages();
        _messages.addAll(botMessages);
      } else {
        // Fallback response if no query result
        _messages.add(
          Message(
            id: _uuid.v4(),
            text: 'I received your message but couldn\'t process it properly.',
            type: MessageType.bot,
            timestamp: DateTime.now(),
          ),
        );
      }

      // Save updated messages
      await _storageService.saveMessages(_messages);

      _logger.i('Message sent successfully');
    } catch (e) {
      _logger.e('Error sending message: $e');
      _error = 'Failed to send message. Please try again.';
      _isTyping = false;

      // Mark user message as error
      final index = _messages.indexWhere((m) => m.id == userMessage.id);
      if (index != -1) {
        _messages[index] = userMessage.copyWith(hasError: true);
      }

      // Add error message
      _messages.add(
        Message(
          id: _uuid.v4(),
          text: 'Sorry, I couldn\'t process your message. Please try again.',
          type: MessageType.bot,
          timestamp: DateTime.now(),
          hasError: true,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Retry sending a failed message
  Future<void> retryMessage(String messageId) async {
    final message = _messages.firstWhere((m) => m.id == messageId);
    if (message.type == MessageType.user) {
      // Remove the failed message and error response
      _messages.removeWhere((m) =>
          m.id == messageId ||
          (m.timestamp.isAfter(message.timestamp) && m.hasError));
      notifyListeners();

      // Retry sending
      await sendMessage(message.text);
    }
  }

  /// Clear all messages
  Future<void> clearMessages() async {
    _messages.clear();
    await _storageService.clearMessages();
    _logger.i('Messages cleared');
    notifyListeners();
  }

  /// Start a new session
  Future<void> newSession(AppConfig config) async {
    await clearMessages();

    _session = DialogflowSession(
      sessionId: _uuid.v4(),
      projectId: config.projectId,
      locationId: config.locationId,
      agentId: config.agentId,
      createdAt: DateTime.now(),
    );

    await _storageService.saveSession(_session!);
    _logger.i('New session created: ${_session!.sessionId}');
    notifyListeners();
  }

  /// Add a welcome message
  void addWelcomeMessage({String? customMessage}) {
    final welcomeText = customMessage ??
        'Hello! I\'m your AI assistant powered by Dialogflow CX. How can I help you today?';

    _messages.add(
      Message(
        id: _uuid.v4(),
        text: welcomeText,
        type: MessageType.bot,
        timestamp: DateTime.now(),
      ),
    );

    _storageService.saveMessages(_messages);
    notifyListeners();
  }

  /// Clear error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _logger.close();
    super.dispose();
  }
}
