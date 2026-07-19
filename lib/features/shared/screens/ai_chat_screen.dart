import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class AiChatScreen extends StatefulWidget {
  final String? initialMessage;
  const AiChatScreen({super.key, this.initialMessage});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'role': 'ai',
      'text': 'Hi! I can help with WiFi, the pool heater, nearby restaurants or checkout steps. What do you need?'
    },
  ];
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _send(widget.initialMessage!);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
    });
    _controller.clear();

    await Future.delayed(const Duration(seconds: 1));

    String response = "I'm looking into that for you...";
    if (text.toLowerCase().contains('wifi')) {
      response = "The WiFi password is 'sahely2026'. You can also find a QR code on the kitchen counter.";
    } else if (text.toLowerCase().contains('pool')) {
      response = "Tap the round dial by the pool pump to ON, set 28°C, and give it ~40 min.";
    } else if (text.toLowerCase().contains('checkout')) {
      response = "Checkout is at 11:00 AM. Just leave the keys on the table and lock the door via the app.";
    }

    setState(() {
      _isTyping = false;
      _messages.add({'role': 'ai', 'text': response});
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
                color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
            child: Row(children: [
              GestureDetector(onTap: () => Navigator.maybePop(context), child: const Icon(Icons.chevron_left, color: AppColors.navy)),
              const SizedBox(width: 8),
              Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.goldBright, AppColors.gold]),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.auto_awesome, size: 17, color: AppColors.navy)),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Sahely AI', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                Row(children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF2BB673), shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('Always on · instant help', style: AppTheme.dm(size: 11, color: AppColors.muted))
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
                return m['role'] == 'ai' ? _ai(m['text']) : _user(m['text']);
              },
            ),
          ),
          if (_messages.length == 1 && !_isTyping)
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  _chip('How does the pool heater work?', () => _send('How does the pool heater work?')),
                  const SizedBox(width: 8),
                  _chip('Checkout time?', () => _send('Checkout time?')),
                ]),
              ),
            ),
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(children: [
              Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(color: AppColors.cream, shape: BoxShape.circle),
                  child: const Icon(Icons.add, size: 18, color: AppColors.navy)),
              const SizedBox(width: 8),
              Expanded(
                  child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(22)),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _send,
                        decoration: InputDecoration(
                          hintText: 'Ask Sahely AI…',
                          hintStyle: AppTheme.dm(size: 13, color: AppColors.navy.withValues(alpha: 0.5)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ))),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _send(_controller.text),
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                    child: const Icon(Icons.send, size: 18, color: AppColors.navy)),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _ai(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.goldBright, AppColors.gold]),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.auto_awesome, size: 15, color: AppColors.navy)),
          const SizedBox(width: 8),
          Flexible(
              child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14)),
                  child: Text(text, style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.4)))),
        ]),
      );

  Widget _user(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Flexible(
              child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)),
                  child: Text(text, style: AppTheme.dm(size: 13, color: Colors.white, height: 1.4))))
        ]),
      );

  Widget _chip(String text, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: AppColors.gold), borderRadius: BorderRadius.circular(18)),
          child: Text(text, style: AppTheme.dm(size: 12, color: const Color(0xFF9A7A22)))));

  Widget _typingIndicator() => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.auto_awesome, size: 15, color: AppColors.gold)),
          const SizedBox(width: 8),
          Text('Sahely is typing...', style: AppTheme.dm(size: 12, color: AppColors.muted, italic: true)),
        ]),
      );
}
