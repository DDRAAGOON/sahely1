import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class UserMessageBubble extends StatelessWidget {
  final String message;
  final String? imageUrl;
  final DateTime timestamp;

  const UserMessageBubble({
    super.key,
    required this.message,
    this.imageUrl,
    required this.timestamp,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (message.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontFamily: 'DM Sans',
                height: 1.4,
              ),
            ),
          ),
        if (imageUrl != null) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImage(imageUrl!),
          ),
        ],
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            _formatTime(timestamp),
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.secondary,
              fontFamily: 'DM Sans',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: 200,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
      );
    } else {
      return Image.file(
        File(path),
        width: 200,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
      );
    }
  }

  Widget _errorPlaceholder() {
    return Container(
      width: 200,
      height: 150,
      color: AppColors.border,
      child: const Icon(
        Icons.image,
        color: AppColors.secondary,
        size: 48,
      ),
    );
  }
}
