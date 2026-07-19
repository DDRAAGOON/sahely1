import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';

class BrokerSOSChatScreen extends StatefulWidget {
  const BrokerSOSChatScreen({super.key});

  @override
  State<BrokerSOSChatScreen> createState() => _BrokerSOSChatScreenState();
}

class _BrokerSOSChatScreenState extends State<BrokerSOSChatScreen> {
  late final List<Map<String, dynamic>> _messages;
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages = [
      {
        'role': 'agent',
        'text':
            'Hi, this is Sahely Broker Support. We see you flagged an issue for your client. How can we assist you today?'
      },
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _messages.add({'role': 'user', 'imagePath': image.path});
        _isTyping = true;
      });

      await Future.delayed(const Duration(milliseconds: 1500));

      setState(() {
        _isTyping = false;
        _messages.add({
          'role': 'agent',
          'text':
              "We've received the photo from your end. Our team is looking into it. We'll update you shortly."
        });
      });
    }
  }

  void _send(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
    });
    _controller.clear();

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isTyping = false;
      _messages.add({
        'role': 'agent',
        'text':
            "Understood. We are dispatching a technician to the unit. We will notify you once they arrive."
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEAE1),
      body: SafeArea(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            color: const Color(0xFFB22222),
            child: Row(children: [
              GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: const Icon(Icons.chevron_left, color: Colors.white)),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Broker Support · SOS',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: Colors.white)),
                    Row(children: [
                      Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                              color: Color(0xFF7BE0A0),
                              shape: BoxShape.circle)),
                      const SizedBox(width: 5),
                      const Text('Agent connected · Priority',
                          style:
                              TextStyle(fontSize: 11, color: Colors.white70)),
                    ]),
                  ])),
              const Icon(Icons.call_outlined, color: Colors.white, size: 20),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == _messages.length) return _typingIndicator();
                final m = _messages[i];
                return m['role'] == 'agent' ? _agent(m['text']) : _user(m);
              },
            ),
          ),
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(children: [
              GestureDetector(
                  onTap: _pickImage,
                  child: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.muted)),
              const SizedBox(width: 10),
              Expanded(
                  child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          color: const Color(0xFFEFEAE1),
                          borderRadius: BorderRadius.circular(22)),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _send,
                        decoration: InputDecoration(
                          hintText: 'Message support…',
                          hintStyle: TextStyle(
                              fontSize: 13,
                              color: AppColors.navy.withValues(alpha: 0.5)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ))),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _send(_controller.text),
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xFFB22222), shape: BoxShape.circle),
                    child:
                        const Icon(Icons.send, size: 18, color: Colors.white)),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _agent(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                  color: Color(0xFFB22222), shape: BoxShape.circle),
              child: const Icon(Icons.headset_mic_outlined,
                  size: 16, color: Colors.white)),
          const SizedBox(width: 8),
          Flexible(
              child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14)),
                  child: Text(text,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.navy, height: 1.4)))),
        ]),
      );

  Widget _user(Map<String, dynamic> msg) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Flexible(
              child: Container(
                  padding: EdgeInsets.all(msg['imagePath'] != null ? 4 : 11),
                  decoration: BoxDecoration(
                    color: msg['imagePath'] != null
                        ? AppColors.white
                        : AppColors.navy,
                    borderRadius: BorderRadius.circular(14),
                    border: msg['imagePath'] != null
                        ? Border.all(color: AppColors.border)
                        : null,
                  ),
                  child: msg['imagePath'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(File(msg['imagePath']),
                              width: 200, fit: BoxFit.cover),
                        )
                      : Text(msg['text'] ?? '',
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              height: 1.4)))),
        ]),
      );

  Widget _typingIndicator() => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: const Color(0xFFB22222).withValues(alpha: 0.2),
                  shape: BoxShape.circle),
              child: const Icon(Icons.headset_mic_outlined,
                  size: 16, color: Color(0xFFB22222))),
          const SizedBox(width: 8),
          const Text('Agent is typing...',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ]),
      );
}
