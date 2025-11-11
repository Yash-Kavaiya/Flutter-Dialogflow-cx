import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/message.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

/// Message bubble widget with beautiful animations
class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onRetry;

  const MessageBubble({
    required this.message,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingS,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(context, isUser),
          const SizedBox(width: AppConstants.paddingS),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _buildBubble(context, isUser),
                const SizedBox(height: 4),
                _buildTimestamp(context),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.paddingS),
          if (isUser) _buildAvatar(context, isUser),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppConstants.animationFast)
        .slideY(
          begin: 0.3,
          end: 0,
          duration: AppConstants.animationFast,
          curve: Curves.easeOut,
        );
  }

  Widget _buildAvatar(BuildContext context, bool isUser) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: isUser
            ? AppConstants.primaryGradient
            : AppConstants.accentGradient,
        shape: BoxShape.circle,
        boxShadow: AppShadows.small,
      ),
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildBubble(BuildContext context, bool isUser) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: context.screenWidth * 0.75,
      ),
      decoration: BoxDecoration(
        gradient: isUser ? AppConstants.primaryGradient : null,
        color: isUser ? null : AppConstants.botBubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppConstants.radiusL),
          topRight: const Radius.circular(AppConstants.radiusL),
          bottomLeft: Radius.circular(
            isUser ? AppConstants.radiusL : AppConstants.radiusS,
          ),
          bottomRight: Radius.circular(
            isUser ? AppConstants.radiusS : AppConstants.radiusL,
          ),
        ),
        boxShadow: AppShadows.small,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isSending)
            _buildSendingIndicator(context)
          else if (message.hasError)
            _buildErrorContent(context, isUser)
          else
            _buildMessageContent(context, isUser),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isUser) {
    return Text(
      message.text,
      style: AppTextStyles.bodyMedium.copyWith(
        color: isUser
            ? AppConstants.userTextColor
            : AppConstants.botTextColor,
        height: 1.5,
      ),
    );
  }

  Widget _buildSendingIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppConstants.userTextColor.withOpacity(0.7),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Sending...',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppConstants.userTextColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorContent(BuildContext context, bool isUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.error_outline,
              size: 16,
              color: isUser ? Colors.white : AppConstants.errorColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Failed to send',
              style: AppTextStyles.bodySmall.copyWith(
                color: isUser ? Colors.white : AppConstants.errorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          message.text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isUser
                ? AppConstants.userTextColor
                : AppConstants.botTextColor,
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 8),
          InkWell(
            onTap: onRetry,
            child: Text(
              'Tap to retry',
              style: AppTextStyles.bodySmall.copyWith(
                color: isUser ? Colors.white : AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimestamp(BuildContext context) {
    return Text(
      message.timestamp.toTimeString(),
      style: AppTextStyles.caption.copyWith(
        color: Colors.grey.shade600,
      ),
    );
  }
}
