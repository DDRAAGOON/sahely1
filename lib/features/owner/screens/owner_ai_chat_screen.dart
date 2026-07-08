import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/kit.dart';

class OwnerAiChatScreen extends StatefulWidget {
  const OwnerAiChatScreen({super.key});

  @override
  State<OwnerAiChatScreen> createState() => _OwnerAiChatScreenState();
}

class _OwnerAiChatScreenState extends State<OwnerAiChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {'role': 'ai', 'text': 'Hi Layla 👋 I can help with your listings, pricing, guest requests, payouts and house rules. What do you need?'},
  ];
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  void _send(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
    });
    _controller.clear();

    await Future.delayed(const Duration(seconds: 1));
    
    String response = "I'm analyzing your request...";
    bool showAction = false;

    if (text.toLowerCase().contains('price')) {
      response = "For Hacienda Bay villas your size, August peak runs EGP 5,200–5,800/night. Azure is at 4,500 — raising to 5,400 could add ~EGP 16k/month at your current occupancy. Want me to update it?";
      showAction = true;
    } else if (text.toLowerCase().contains('pending')) {
      response = "Your listing 'Summer Retreat' is pending because we're verifying the owner ID. This usually takes 24-48 hours.";
    }

    setState(() {
      _isTyping = false;
      _messages.add({'role': 'ai', 'text': response, 'action': showAction});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEAE1),
      body: SafeArea(child: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          decoration: const BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
          child: Row(children: [
            GestureDetector(onTap: () => Navigator.maybePop(context), child: const Icon(Icons.chevron_left, color: AppColors.navy)),
            const SizedBox(width: 8),
            Container(width: 34, height: 34, decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.goldBright, AppColors.gold]), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.auto_awesome, size: 17, color: AppColors.navy)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Sahely AI', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
              Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF2BB673), shape: BoxShape.circle)), const SizedBox(width: 5), Text('Always on · instant help', style: AppTheme.dm(size: 11, color: AppColors.muted))]),
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
                          Expanded(child: WideButton(label: 'Yes, set 5,400', color: AppColors.success, height: 40)),
                          SizedBox(width: 10),
                          Expanded(child: WideButton(label: 'Not now', color: AppColors.navy, outline: true, height: 40)),
                        ]),
                      ),
                  ],
                );
              }
              return _user(m['text']);
            },
          ),
        ),
        if (_messages.length == 1 && !_isTyping)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              _sugg('Suggest a nightly price', () => _send('Suggest a nightly price')),
              _sugg('Why is my listing pending?', () => _send('Why is my listing pending?')),
            ]),
          ),
        Container(color: AppColors.white, padding: const EdgeInsets.fromLTRB(12, 8, 12, 12), child: Row(children: [
          Container(width: 36, height: 36, decoration: const BoxDecoration(color: AppColors.cream, shape: BoxShape.circle), child: const Icon(Icons.add, size: 18, color: AppColors.navy)),
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
                  hintStyle: AppTheme.dm(size: 13, color: AppColors.faint),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              )
            )
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _send(_controller.text),
            child: Container(width: 40, height: 40, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle), child: const Icon(Icons.send, size: 18, color: AppColors.navy)),
          ),
        ])),
      ])),
    );
  }

  Widget _ai(String t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 28, height: 28, decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.goldBright, AppColors.gold]), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.auto_awesome, size: 15, color: AppColors.navy)),
        const SizedBox(width: 8),
        Flexible(child: Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14)), child: Text(t, style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.4)))),
      ]));
  Widget _user(String t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Flexible(child: Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)), child: Text(t, style: AppTheme.dm(size: 13, color: Colors.white, height: 1.4))))]));
  Widget _sugg(String t, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(border: Border.all(color: AppColors.gold), borderRadius: BorderRadius.circular(18)), child: Text(t, style: AppTheme.dm(size: 12, color: const Color(0xFF9A7A22))))
  );

  Widget _typingIndicator() => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.auto_awesome, size: 15, color: AppColors.gold)),
      const SizedBox(width: 8),
      Text('Sahely is typing...', style: AppTheme.dm(size: 12, color: AppColors.muted, italic: true)),
    ]),
  );
}
