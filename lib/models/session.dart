/// Session model for managing Dialogflow CX conversation sessions
class DialogflowSession {
  final String sessionId;
  final String projectId;
  final String locationId;
  final String agentId;
  final DateTime createdAt;
  final Map<String, dynamic> parameters;

  DialogflowSession({
    required this.sessionId,
    required this.projectId,
    required this.locationId,
    required this.agentId,
    required this.createdAt,
    this.parameters = const {},
  });

  /// Get the full session path for Dialogflow CX API
  String get sessionPath {
    return 'projects/$projectId/locations/$locationId/agents/$agentId/sessions/$sessionId';
  }

  DialogflowSession copyWith({
    String? sessionId,
    String? projectId,
    String? locationId,
    String? agentId,
    DateTime? createdAt,
    Map<String, dynamic>? parameters,
  }) {
    return DialogflowSession(
      sessionId: sessionId ?? this.sessionId,
      projectId: projectId ?? this.projectId,
      locationId: locationId ?? this.locationId,
      agentId: agentId ?? this.agentId,
      createdAt: createdAt ?? this.createdAt,
      parameters: parameters ?? this.parameters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'projectId': projectId,
      'locationId': locationId,
      'agentId': agentId,
      'createdAt': createdAt.toIso8601String(),
      'parameters': parameters,
    };
  }

  factory DialogflowSession.fromJson(Map<String, dynamic> json) {
    return DialogflowSession(
      sessionId: json['sessionId'] as String,
      projectId: json['projectId'] as String,
      locationId: json['locationId'] as String,
      agentId: json['agentId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      parameters: json['parameters'] as Map<String, dynamic>? ?? {},
    );
  }
}
