/// Application configuration model
class AppConfig {
  final String projectId;
  final String locationId;
  final String agentId;
  final String languageCode;
  final String? credentialsPath;
  final bool enableLogging;
  final int requestTimeout;

  const AppConfig({
    required this.projectId,
    required this.locationId,
    required this.agentId,
    this.languageCode = 'en',
    this.credentialsPath,
    this.enableLogging = true,
    this.requestTimeout = 30000,
  });

  AppConfig copyWith({
    String? projectId,
    String? locationId,
    String? agentId,
    String? languageCode,
    String? credentialsPath,
    bool? enableLogging,
    int? requestTimeout,
  }) {
    return AppConfig(
      projectId: projectId ?? this.projectId,
      locationId: locationId ?? this.locationId,
      agentId: agentId ?? this.agentId,
      languageCode: languageCode ?? this.languageCode,
      credentialsPath: credentialsPath ?? this.credentialsPath,
      enableLogging: enableLogging ?? this.enableLogging,
      requestTimeout: requestTimeout ?? this.requestTimeout,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'locationId': locationId,
      'agentId': agentId,
      'languageCode': languageCode,
      'credentialsPath': credentialsPath,
      'enableLogging': enableLogging,
      'requestTimeout': requestTimeout,
    };
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      projectId: json['projectId'] as String,
      locationId: json['locationId'] as String,
      agentId: json['agentId'] as String,
      languageCode: json['languageCode'] as String? ?? 'en',
      credentialsPath: json['credentialsPath'] as String?,
      enableLogging: json['enableLogging'] as bool? ?? true,
      requestTimeout: json['requestTimeout'] as int? ?? 30000,
    );
  }
}
