import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/chat/presentation/widgets/chat_empty_state.dart';
import 'package:mediconsult/features/chat/presentation/widgets/chat_input.dart';
import 'package:mediconsult/features/chat/presentation/widgets/message_bubble.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();

    // Simulate agent response
    _simulateAgentResponse(text);
  }

  void _simulateAgentResponse(String userMessage) {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: _getAgentResponse(userMessage),
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
      }
    });
  }

  String _getAgentResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    if (message.contains('pharmacy') || message.contains('medicine')) {
      return 'Sure 👋, what is your location';
    } else if (message.contains('location') || message.contains('nasr city')) {
      return 'Would you like me to suggest the nearest in-network pharmacy for lower costs?';
    } else if (message.contains('yes') || message.contains('please')) {
      return 'Perfect! I found 3 nearby pharmacies. Here are the details...';
    } else {
      return 'Hi! How can I assist you today? 😊';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Live Chat', backPath: '/profile'),
            Expanded(
              child: Transform.translate(
                offset: Offset(0, -20.h),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteClr,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greyClr.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: _messages.isEmpty
                              ? const ChatEmptyState()
                              : _buildMessagesList(),
                        ),
                        ChatInput(
                          controller: _messageController,
                          onSendMessage: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            'Today',
            style: AppTextStyles.font12GreyRegular(context),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: MessageBubble(
                  text: message.text,
                  isUser: message.isUser,
                  timestamp: message.timestamp,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
