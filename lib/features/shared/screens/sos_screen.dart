import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

enum UserRole { renter, owner, broker }

class SosScreen extends StatefulWidget {
  const SosScreen({super.key, this.role = UserRole.renter});

  final UserRole role;

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
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
        'text': _initialAgentMessage(),
      },
    ];
  }

  String _initialAgentMessage() {
    switch (widget.role) {
      case UserRole.owner:
        return 'Hi Layla, this is Sahely Support. We see you flagged an urgent issue at Azure Beach Villa. How can we help?';
      case UserRole.broker:
        return 'Hi, this is Sahely Broker Support. We see you flagged an issue for your client. How can we assist you today?';
      case UserRole.renter:
        return 'Hi! This is Mona from Sahely Support. I can see your active stay at Lagoon Retreat. How can I help?';
    }
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
          'text': _imageReceivedMessage(),
        });
      });
    }
  }

  String _imageReceivedMessage() {
    switch (widget.role) {
      case UserRole.broker:
        return "We've received the photo from your end. Our team is looking into it. We'll update you shortly.";
      default:
        return "I've received the photo. Our team is reviewing the issue now. ETA for a technician is still under 60 min.";
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
      _messages.add({'role': 'agent', 'text': _responseMessage()});
    });
  }

  String _responseMessage() {
    switch (widget.role) {
      case UserRole.owner:
        return "Understood - we're dispatching a technician now and notifying the guest. ETA under 90 min. Can you confirm the unit/floor?";
      case UserRole.broker:
        return "Understood. We are dispatching a technician to the unit. We will notify you once they arrive.";
      case UserRole.renter:
        return "Thanks for flagging - I'm dispatching a technician now. They'll arrive within 60 minutes. I'll stay on this chat until it's resolved. Check mark";
    }
  }

  String _getTitle() {
    switch (widget.role) {
      case UserRole.owner:
        return 'SOS - Live Support';
      case UserRole.broker:
        return 'Broker Support - SOS';
      case UserRole.renter:
        return 'Sahely Support - SOS';
    }
  }

  String _getStatusText() {
    switch (widget.role) {
      case UserRole.owner:
        return 'Agent connected - priority';
      case UserRole.broker:
        return 'Agent connected - Priority';
      case UserRole.renter:
        return 'Agent connected - live now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.role == UserRole.broker
          ? const Color(0xFFEFEAE1)
          : const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(children: [
          Container(
            padding: widget.role == UserRole.broker
                ? const EdgeInsets.fromLTRB(12, 10, 12, 12)
                : const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: Color(0xFFB22222),
            ),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: widget.role == UserRole.broker
                    ? const Icon(Icons.chevron_left, color: Colors.white)
                    : Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.chevron_left,
                            color: Colors.white, size: 24),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(_getTitle(),
                        style: AppTheme.dm(
                            size: widget.role == UserRole.broker ? 15 : 16,
                            weight: FontWeight.w700,
                            color: Colors.white)),
                    Row(children: [
                      Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                              color: Color(0xFF7BE0A0),
                              shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(_getStatusText(),
                          style: AppTheme.dm(size: 12, color: Colors.white70)),
                    ]),
                  ])),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: widget.role == UserRole.broker
                  ? const EdgeInsets.all(14)
                  : const EdgeInsets.all(16),
              itemCount: _messages.length +
                  (_isTyping ? 1 : (widget.role != UserRole.broker ? 1 : 1)),
              itemBuilder: (context, i) {
                if (widget.role != UserRole.broker) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24, top: 8),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E1D5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            'Today - Emergency chat started',
                            style: AppTheme.dm(
                                size: 12,
                                weight: FontWeight.w600,
                                color: AppColors.muted),
                          ),
                        ),
                      ),
                    );
                  }
                  final msgIndex = i - 1;
                  if (msgIndex == _messages.length) return _typingIndicator();
                  final m = _messages[msgIndex];
                  return m['role'] == 'agent' ? _agent(m['text']) : _user(m);
                } else {
                  if (i == _messages.length) return _typingIndicator();
                  final m = _messages[i];
                  return m['role'] == 'agent' ? _agent(m['text']) : _user(m);
                }
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
                          hintText: 'Message support...',
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
                      style: AppTheme.dm(
                          size: 13, color: AppColors.ink, height: 1.4)))),
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
                          style: AppTheme.dm(
                              size: 13, color: Colors.white, height: 1.4)))),
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
          Text('Agent is typing...',
              style:
                  AppTheme.dm(size: 12, color: AppColors.muted, italic: true)),
        ]),
      );
}
