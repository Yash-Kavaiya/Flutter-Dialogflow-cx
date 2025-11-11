import 'message.dart';

/// Model for Dialogflow CX API response
class DialogflowResponse {
  final String responseId;
  final QueryResult? queryResult;
  final String? webhookStatus;

  DialogflowResponse({
    required this.responseId,
    this.queryResult,
    this.webhookStatus,
  });

  factory DialogflowResponse.fromJson(Map<String, dynamic> json) {
    return DialogflowResponse(
      responseId: json['responseId'] as String? ?? '',
      queryResult: json['queryResult'] != null
          ? QueryResult.fromJson(json['queryResult'] as Map<String, dynamic>)
          : null,
      webhookStatus: json['webhookStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responseId': responseId,
      'queryResult': queryResult?.toJson(),
      'webhookStatus': webhookStatus,
    };
  }
}

/// Query result from Dialogflow CX
class QueryResult {
  final String? text;
  final String? languageCode;
  final List<ResponseMessage> responseMessages;
  final Map<String, dynamic> parameters;
  final QueryIntent? intent;
  final double intentDetectionConfidence;
  final Map<String, dynamic>? diagnosticInfo;

  QueryResult({
    this.text,
    this.languageCode,
    this.responseMessages = const [],
    this.parameters = const {},
    this.intent,
    this.intentDetectionConfidence = 0.0,
    this.diagnosticInfo,
  });

  factory QueryResult.fromJson(Map<String, dynamic> json) {
    return QueryResult(
      text: json['text'] as String?,
      languageCode: json['languageCode'] as String?,
      responseMessages: json['responseMessages'] != null
          ? (json['responseMessages'] as List)
              .map((x) => ResponseMessage.fromJson(x as Map<String, dynamic>))
              .toList()
          : [],
      parameters:
          json['parameters'] as Map<String, dynamic>? ?? {},
      intent: json['intent'] != null
          ? QueryIntent.fromJson(json['intent'] as Map<String, dynamic>)
          : null,
      intentDetectionConfidence:
          (json['intentDetectionConfidence'] as num?)?.toDouble() ?? 0.0,
      diagnosticInfo: json['diagnosticInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'languageCode': languageCode,
      'responseMessages': responseMessages.map((x) => x.toJson()).toList(),
      'parameters': parameters,
      'intent': intent?.toJson(),
      'intentDetectionConfidence': intentDetectionConfidence,
      'diagnosticInfo': diagnosticInfo,
    };
  }

  /// Convert to Message list for UI display
  List<Message> toMessages() {
    final messages = <Message>[];
    final timestamp = DateTime.now();

    for (final responseMsg in responseMessages) {
      if (responseMsg.text != null) {
        messages.add(
          Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: responseMsg.text!.text.join(' '),
            type: MessageType.bot,
            contentType: MessageContentType.text,
            timestamp: timestamp,
          ),
        );
      } else if (responseMsg.payload != null) {
        // Handle custom payloads
        messages.add(
          Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: responseMsg.payload.toString(),
            type: MessageType.bot,
            contentType: MessageContentType.customPayload,
            timestamp: timestamp,
            metadata: responseMsg.payload,
          ),
        );
      }
    }

    return messages;
  }
}

/// Response message from Dialogflow CX
class ResponseMessage {
  final TextMessage? text;
  final Map<String, dynamic>? payload;
  final LiveAgentHandoff? liveAgentHandoff;
  final ConversationSuccess? conversationSuccess;
  final OutputAudioText? outputAudioText;
  final MixedAudio? mixedAudio;

  ResponseMessage({
    this.text,
    this.payload,
    this.liveAgentHandoff,
    this.conversationSuccess,
    this.outputAudioText,
    this.mixedAudio,
  });

  factory ResponseMessage.fromJson(Map<String, dynamic> json) {
    return ResponseMessage(
      text: json['text'] != null
          ? TextMessage.fromJson(json['text'] as Map<String, dynamic>)
          : null,
      payload: json['payload'] as Map<String, dynamic>?,
      liveAgentHandoff: json['liveAgentHandoff'] != null
          ? LiveAgentHandoff.fromJson(
              json['liveAgentHandoff'] as Map<String, dynamic>,
            )
          : null,
      conversationSuccess: json['conversationSuccess'] != null
          ? ConversationSuccess.fromJson(
              json['conversationSuccess'] as Map<String, dynamic>,
            )
          : null,
      outputAudioText: json['outputAudioText'] != null
          ? OutputAudioText.fromJson(
              json['outputAudioText'] as Map<String, dynamic>,
            )
          : null,
      mixedAudio: json['mixedAudio'] != null
          ? MixedAudio.fromJson(json['mixedAudio'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text?.toJson(),
      'payload': payload,
      'liveAgentHandoff': liveAgentHandoff?.toJson(),
      'conversationSuccess': conversationSuccess?.toJson(),
      'outputAudioText': outputAudioText?.toJson(),
      'mixedAudio': mixedAudio?.toJson(),
    };
  }
}

/// Text message from Dialogflow CX
class TextMessage {
  final List<String> text;
  final bool allowPlaybackInterruption;

  TextMessage({
    required this.text,
    this.allowPlaybackInterruption = false,
  });

  factory TextMessage.fromJson(Map<String, dynamic> json) {
    return TextMessage(
      text: (json['text'] as List?)?.map((e) => e.toString()).toList() ?? [],
      allowPlaybackInterruption:
          json['allowPlaybackInterruption'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'allowPlaybackInterruption': allowPlaybackInterruption,
    };
  }
}

/// Intent information
class QueryIntent {
  final String name;
  final String displayName;

  QueryIntent({
    required this.name,
    required this.displayName,
  });

  factory QueryIntent.fromJson(Map<String, dynamic> json) {
    return QueryIntent(
      name: json['name'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'displayName': displayName,
    };
  }
}

/// Live agent handoff
class LiveAgentHandoff {
  final Map<String, dynamic>? metadata;

  LiveAgentHandoff({this.metadata});

  factory LiveAgentHandoff.fromJson(Map<String, dynamic> json) {
    return LiveAgentHandoff(
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metadata': metadata,
    };
  }
}

/// Conversation success indicator
class ConversationSuccess {
  final Map<String, dynamic>? metadata;

  ConversationSuccess({this.metadata});

  factory ConversationSuccess.fromJson(Map<String, dynamic> json) {
    return ConversationSuccess(
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metadata': metadata,
    };
  }
}

/// Output audio text
class OutputAudioText {
  final String? text;
  final String? ssml;
  final bool allowPlaybackInterruption;

  OutputAudioText({
    this.text,
    this.ssml,
    this.allowPlaybackInterruption = false,
  });

  factory OutputAudioText.fromJson(Map<String, dynamic> json) {
    return OutputAudioText(
      text: json['text'] as String?,
      ssml: json['ssml'] as String?,
      allowPlaybackInterruption:
          json['allowPlaybackInterruption'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'ssml': ssml,
      'allowPlaybackInterruption': allowPlaybackInterruption,
    };
  }
}

/// Mixed audio
class MixedAudio {
  final List<Segment> segments;

  MixedAudio({required this.segments});

  factory MixedAudio.fromJson(Map<String, dynamic> json) {
    return MixedAudio(
      segments: (json['segments'] as List?)
              ?.map((e) => Segment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'segments': segments.map((x) => x.toJson()).toList(),
    };
  }
}

/// Audio segment
class Segment {
  final String? audio;
  final String? uri;
  final bool allowPlaybackInterruption;

  Segment({
    this.audio,
    this.uri,
    this.allowPlaybackInterruption = false,
  });

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      audio: json['audio'] as String?,
      uri: json['uri'] as String?,
      allowPlaybackInterruption:
          json['allowPlaybackInterruption'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audio': audio,
      'uri': uri,
      'allowPlaybackInterruption': allowPlaybackInterruption,
    };
  }
}
