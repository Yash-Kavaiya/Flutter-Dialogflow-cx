import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';

/// Animated typing indicator for bot responses
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(),
          const SizedBox(width: AppConstants.paddingS),
          _buildTypingBubble(),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppConstants.animationFast)
        .slideY(
          begin: 0.3,
          end: 0,
          duration: AppConstants.animationFast,
        );
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        gradient: AppConstants.accentGradient,
        shape: BoxShape.circle,
        boxShadow: AppShadows.small,
      ),
      child: const Icon(
        Icons.smart_toy,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.botBubbleColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusL),
          topRight: Radius.circular(AppConstants.radiusL),
          bottomLeft: Radius.circular(AppConstants.radiusS),
          bottomRight: Radius.circular(AppConstants.radiusL),
        ),
        boxShadow: AppShadows.small,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingM,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(0),
          const SizedBox(width: 4),
          _buildDot(1),
          const SizedBox(width: 4),
          _buildDot(2),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        shape: BoxShape.circle,
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .fadeIn(
          delay: Duration(milliseconds: 200 * index),
          duration: const Duration(milliseconds: 600),
        )
        .fadeOut(
          delay: Duration(milliseconds: 200 * index),
          duration: const Duration(milliseconds: 600),
        );
  }
}
