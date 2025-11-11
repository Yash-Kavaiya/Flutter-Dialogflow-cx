import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Chat input field with modern design
class ChatInputField extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isEnabled;

  const ChatInputField({
    required this.onSendMessage,
    this.isEnabled = true,
    super.key,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleSendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
      setState(() {
        _hasText = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: AppConstants.paddingM,
        right: AppConstants.paddingM,
        top: AppConstants.paddingM,
        bottom: AppConstants.paddingM + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppConstants.backgroundColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                  border: Border.all(
                    color: _focusNode.hasFocus
                        ? AppConstants.primaryColor.withOpacity(0.5)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.isEnabled,
                  maxLines: null,
                  maxLength: AppConstants.maxMessageLength,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM,
                      vertical: AppConstants.paddingM,
                    ),
                    counterText: '',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.grey.shade400,
                        size: 22,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                  ),
                  onSubmitted: (_) => _handleSendMessage(),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.paddingS),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    final isActive = _hasText && widget.isEnabled;

    return AnimatedContainer(
      duration: AppConstants.animationFast,
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: isActive
            ? AppConstants.primaryGradient
            : LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
              ),
        shape: BoxShape.circle,
        boxShadow: isActive ? AppShadows.medium : AppShadows.small,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActive ? _handleSendMessage : null,
          borderRadius: BorderRadius.circular(24),
          child: Icon(
            Icons.send_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}
