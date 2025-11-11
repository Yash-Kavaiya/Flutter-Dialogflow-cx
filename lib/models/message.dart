import 'package:flutter/material.dart';

/// Enum for message sender type
enum MessageType { user, bot }

/// Enum for message content type
enum MessageContentType {
  text,
  card,
  quickReplies,
  image,
  customPayload,
}

/// Message model representing a chat message
class Message {
  final String id;
  final String text;
  final MessageType type;
  final MessageContentType contentType;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final List<QuickReply>? quickReplies;
  final CardData? cardData;
  final String? imageUrl;
  final bool isSending;
  final bool hasError;

  Message({
    required this.id,
    required this.text,
    required this.type,
    this.contentType = MessageContentType.text,
    required this.timestamp,
    this.metadata,
    this.quickReplies,
    this.cardData,
    this.imageUrl,
    this.isSending = false,
    this.hasError = false,
  });

  Message copyWith({
    String? id,
    String? text,
    MessageType? type,
    MessageContentType? contentType,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
    List<QuickReply>? quickReplies,
    CardData? cardData,
    String? imageUrl,
    bool? isSending,
    bool? hasError,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      contentType: contentType ?? this.contentType,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      quickReplies: quickReplies ?? this.quickReplies,
      cardData: cardData ?? this.cardData,
      imageUrl: imageUrl ?? this.imageUrl,
      isSending: isSending ?? this.isSending,
      hasError: hasError ?? this.hasError,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.toString(),
      'contentType': contentType.toString(),
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'quickReplies': quickReplies?.map((x) => x.toJson()).toList(),
      'cardData': cardData?.toJson(),
      'imageUrl': imageUrl,
      'isSending': isSending,
      'hasError': hasError,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      text: json['text'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      contentType: MessageContentType.values.firstWhere(
        (e) => e.toString() == json['contentType'],
        orElse: () => MessageContentType.text,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      quickReplies: json['quickReplies'] != null
          ? (json['quickReplies'] as List)
              .map((x) => QuickReply.fromJson(x as Map<String, dynamic>))
              .toList()
          : null,
      cardData: json['cardData'] != null
          ? CardData.fromJson(json['cardData'] as Map<String, dynamic>)
          : null,
      imageUrl: json['imageUrl'] as String?,
      isSending: json['isSending'] as bool? ?? false,
      hasError: json['hasError'] as bool? ?? false,
    );
  }
}

/// Quick reply button model
class QuickReply {
  final String text;
  final String payload;
  final IconData? icon;

  QuickReply({
    required this.text,
    required this.payload,
    this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'payload': payload,
      'icon': icon?.codePoint,
    };
  }

  factory QuickReply.fromJson(Map<String, dynamic> json) {
    return QuickReply(
      text: json['text'] as String,
      payload: json['payload'] as String,
      icon: json['icon'] != null
          ? IconData(json['icon'] as int, fontFamily: 'MaterialIcons')
          : null,
    );
  }
}

/// Card data model for rich responses
class CardData {
  final String title;
  final String? subtitle;
  final String? imageUri;
  final List<CardButton>? buttons;

  CardData({
    required this.title,
    this.subtitle,
    this.imageUri,
    this.buttons,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imageUri': imageUri,
      'buttons': buttons?.map((x) => x.toJson()).toList(),
    };
  }

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      imageUri: json['imageUri'] as String?,
      buttons: json['buttons'] != null
          ? (json['buttons'] as List)
              .map((x) => CardButton.fromJson(x as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

/// Card button model
class CardButton {
  final String text;
  final String? url;
  final String? postback;

  CardButton({
    required this.text,
    this.url,
    this.postback,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'url': url,
      'postback': postback,
    };
  }

  factory CardButton.fromJson(Map<String, dynamic> json) {
    return CardButton(
      text: json['text'] as String,
      url: json['url'] as String?,
      postback: json['postback'] as String?,
    );
  }
}
