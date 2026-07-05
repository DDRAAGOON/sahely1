import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../widgets/sos_chat_header.dart';
import '../widgets/chat_timestamp.dart';
import '../widgets/support_message_bubble.dart';
import '../widgets/user_message_bubble.dart';
import '../widgets/chat_input_bar.dart';

class SOSChatScreen extends StatefulWidget {
  final String propertyName;
  final String orderNumber;

  const SOSChatScreen({
    super.key,
    required this.propertyName,
    required this.orderNumber,
  });

  @override
  State<SOSChatScreen> createState() => _SOSChatScreenState();
}

class _SOSChatScreenState extends State<SOSChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // No mock messages as requested
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _messages.add({
            'isUser': true,
            'message': '',
            'imageUrl': image.path,
            'timestamp': DateTime.now(),
          });
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        setState(() {
          _messages.add({
            'isUser': true,
            'message': 'Video sent', // In a real app, you'd show a video player
            'timestamp': DateTime.now(),
          });
        });
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video captured and sent')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const SOSChatHeader(),
          
          const SizedBox(height: 12),
          
          // Timestamp
          const ChatTimestamp(
            text: 'Today · Emergency chat started',
          ),

          const SizedBox(height: 16),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final showAvatar = index == 0 || 
                    _messages[index - 1]['isUser'] != message['isUser'];

                if (message['isUser']) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: UserMessageBubble(
                        message: message['message'],
                        imageUrl: message['imageUrl'],
                        timestamp: message['timestamp'],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SupportMessageBubble(
                      agentName: message['agentName'],
                      message: message['message'],
                      showAvatar: showAvatar,
                    ),
                  );
                }
              },
            ),
          ),

          // Input Bar
          ChatInputBar(
            onSendMessage: (text) {
              setState(() {
                _messages.add({
                  'isUser': true,
                  'message': text,
                  'timestamp': DateTime.now(),
                });
              });
            },
            onSendImage: _pickImage,
            onSendVideo: _pickVideo,
          ),
        ],
      ),
    );
  }
}
