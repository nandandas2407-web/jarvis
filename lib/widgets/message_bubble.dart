import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(24),
          topRight: const Radius.circular(24),
          bottomLeft: Radius.circular(isUser ? 24 : 6),
          bottomRight: Radius.circular(isUser ? 6 : 24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82,
            ),
            margin: EdgeInsets.only(
              left: isUser ? 52 : 12,
              right: isUser ? 12 : 52,
              top: 6,
              bottom: 6,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isUser
                    ? [
                        const Color(0xFF4F46E5).withOpacity(0.85),
                        const Color(0xFF6366F1).withOpacity(0.7),
                      ]
                    : [
                        isDark ? const Color(0xFF1E293B).withOpacity(0.7) : Colors.white.withOpacity(0.75),
                        isDark ? const Color(0xFF0F172A).withOpacity(0.5) : Colors.white.withOpacity(0.4),
                      ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(24),
                topRight: const Radius.circular(24),
                bottomLeft: Radius.circular(isUser ? 24 : 6),
                bottomRight: Radius.circular(isUser ? 6 : 24),
              ),
              border: Border.all(
                color: isUser
                    ? Colors.white.withOpacity(0.3)
                    : (isDark ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.6)),
                width: 1.5,
              ),
              boxShadow: [
                // Neumorphic / Glass highlight (top-left)
                BoxShadow(
                  color: isDark ? Colors.white.withOpacity(0.06) : Colors.white.withOpacity(0.8),
                  offset: const Offset(-4, -4),
                  blurRadius: 12,
                ),
                // Deep shadow (bottom-right)
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.45 : 0.12),
                  offset: const Offset(6, 6),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Action result badge
                if (message.actionResult != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: message.actionResult!.success
                          ? Colors.green.withOpacity(0.18)
                          : Colors.red.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: message.actionResult!.success
                            ? Colors.green.withOpacity(0.4)
                            : Colors.red.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          message.actionResult!.success
                              ? Icons.check_circle_rounded
                              : Icons.error_rounded,
                          size: 14,
                          color: message.actionResult!.success
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          message.actionResult!.actionType.toUpperCase().replaceAll('_', ' '),
                          style: TextStyle(
                            fontSize: 10,
                            color: message.actionResult!.success
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Message text
                if (isUser)
                  SelectableText(
                    message.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else
                  MarkdownBody(
                    data: message.content,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                      p: TextStyle(
                        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B),
                        fontSize: 15,
                        height: 1.45,
                      ),
                      listBullet: TextStyle(
                        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B),
                        fontSize: 15,
                      ),
                    ),
                  ),
                // Timestamp
                const SizedBox(height: 6),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: isUser
                        ? Colors.white.withOpacity(0.7)
                        : (isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

