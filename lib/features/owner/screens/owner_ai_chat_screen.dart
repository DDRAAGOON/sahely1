import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/image.dart';
import 'package:sahely/features/shared/chat/data/chatbot_session.dart';

class OwnerAiChatScreen extends StatefulWidget {
  const OwnerAiChatScreen({super.key});

  @override
  State<OwnerAiChatScreen> createState() => _OwnerAiChatScreenState();
}

class _OwnerAiChatScreenState extends State<OwnerAiChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'role': 'ai',
      'text':
          'Hi 👋 I can help with your listings, pricing, guest requests, payouts and house rules. What do you need?'
    },
  ];
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;
  late final ChatbotSession _assistant = ChatbotSession();

  void _send(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
    });
    _controller.clear();

    String reply;
    try {
      reply = await _assistant.ask(text) ?? ChatbotSession.pendingNotice;
    } catch (_) {
      reply = 'The assistant is unavailable right now. Please try again.';
    }
    if (!mounted) return;
    setState(() {
      _isTyping = false;
      _messages.add({'role': 'ai', 'text': reply, 'action': false});
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
          decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(bottom: BorderSide(color: AppColors.border))),
          child: Row(children: [
            GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: const Icon(Icons.chevron_left, color: AppColors.navy)),
            const SizedBox(width: 8),
            Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.goldBright, AppColors.gold]),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.auto_awesome,
                    size: 17, color: AppColors.navy)),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Sahely AI',
                      style: AppTheme.dm(
                          size: 15,
                          weight: FontWeight.w700,
                          color: AppColors.navy)),
                  Row(children: [
                    Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Color(0xFF2BB673), shape: BoxShape.circle)),
                    const SizedBox(width: 5),
                    Text('Always on · instant help',
                        style: AppTheme.dm(size: 11, color: AppColors.muted))
                  ]),
                ])),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, i) {
              if (i == _messages.length) return _typingIndicator();
              final m = _messages[i];
              if (m['role'] == 'ai') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ai(m['text']),
                    if (m['action'] == true)
                      const Padding(
                        padding: EdgeInsets.only(left: 36, bottom: 12),
                        child: Row(children: [
                          Expanded(
                              child: WideButton(
                                  label: 'Yes, set 5,400',
                                  color: AppColors.success,
                                  height: 40)),
                          SizedBox(width: 10),
                          Expanded(
                              child: WideButton(
                                  label: 'Not now',
                                  color: AppColors.navy,
                                  outline: true,
                                  height: 40)),
                        ]),
                      ),
                  ],
                );
              }
              return _user(m);
            },
          ),
        ),
        if (_messages.length == 1 && !_isTyping)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                _sugg('Suggest a nightly price',
                    () => _send('Suggest a nightly price')),
                const SizedBox(width: 8),
                _sugg('Why is my listing pending?',
                    () => _send('Why is my listing pending?')),
              ]),
            ),
          ),
        Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                        color: AppColors.cream, shape: BoxShape.circle),
                    child:
                        const Icon(Icons.add, size: 18, color: AppColors.navy)),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(22)),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _send,
                        decoration: InputDecoration(
                          hintText: 'Ask Sahely AI…',
                          hintStyle: AppTheme.dm(
                              size: 13,
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
                        color: AppColors.gold, shape: BoxShape.circle),
                    child: const Icon(Icons.send,
                        size: 18, color: AppColors.navy)),
              ),
            ])),
      ])),
    );
  }

  void _pickImageSource(ImageSource source, BuildContext ctx) async {
    Navigator.pop(ctx);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null || !mounted) return;
    // The assistant only takes text; nothing is sent for the photo.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Photos can't be sent to the assistant yet. "
            'Describe it in a message instead.')));
  }

  void _pickImage() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              Text('Upload Photo',
                  style: AppTheme.dm(
                      size: 17,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
              const SizedBox(height: 24),
              WideButton(
                label: 'Choose from Gallery',
                onTap: () => _pickImageSource(ImageSource.gallery, ctx),
              ),
              const SizedBox(height: 12),
              WideButton(
                label: 'Take a Photo',
                outline: true,
                color: AppColors.navy,
                onTap: () => _pickImageSource(ImageSource.camera, ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ai(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.goldBright, AppColors.gold]),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.auto_awesome,
                size: 15, color: AppColors.navy)),
        const SizedBox(width: 8),
        Flexible(
            child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14)),
                child: Text(t,
                    style: AppTheme.dm(
                        size: 13, color: AppColors.ink, height: 1.4)))),
      ]));

  Widget _user(Map<String, dynamic> m) {
    if (m['local_image'] != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(File(m['local_image']),
                  width: 150, height: 150, fit: BoxFit.cover),
            ),
          ],
        ),
      );
    }
    if (m['image'] != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AppNetworkImage(url: m['image'], width: 150, height: 150),
            ),
          ],
        ),
      );
    }
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Flexible(
              child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(14)),
                  child: Text(m['text'] ?? '',
                      style: AppTheme.dm(
                          size: 13, color: Colors.white, height: 1.4))))
        ]));
  }

  Widget _sugg(String t, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              border: null, borderRadius: BorderRadius.circular(18)),
          child: Text(t,
              style: AppTheme.dm(size: 12, color: const Color(0xFF9A7A22)))));

  Widget _typingIndicator() => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.auto_awesome,
                  size: 15, color: AppColors.gold)),
          const SizedBox(width: 8),
          Text('Sahely is typing...',
              style:
                  AppTheme.dm(size: 12, color: AppColors.muted, italic: true)),
        ]),
      );
}
