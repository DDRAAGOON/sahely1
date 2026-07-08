import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/kit.dart';
import '../../../widgets/sheet_handle.dart';

const _lagoon = 'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=800&q=72&auto=format&fit=crop';

class ShareCollectionScreen extends StatelessWidget {
  const ShareCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      bg: const LinearGradient(colors: [Color(0xFF7FA8BF), Color(0xFF2C5066)]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SheetHandle(),
          const SizedBox(height: 6),
          Row(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(_lagoon,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 52, height: 52, color: AppColors.cardWarm))),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Beach Trip 2026', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
              Text('5 places · shareable link', style: AppTheme.dm(size: 12, color: AppColors.muted)),
            ]),
          ]),
          const SizedBox(height: 16),
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: AppColors.white, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(999)),
            child: Row(children: [
              const Icon(Icons.link, size: 16, color: AppColors.gold),
              const SizedBox(width: 8),
              Expanded(child: Text('sahely.app/c/beach-2026', style: AppTheme.dm(size: 12, color: AppColors.muted))),
              Text('Copy', style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.navy)),
            ]),
          ),
          const SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _target('WhatsApp', const Color(0xFF25D366), Icons.chat),
            _target('Instagram', null, Icons.camera_alt,
                gradient: const [Color(0xFFFEDA77), Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF)]),
            _target('Save', AppColors.navy, Icons.download, iconColor: AppColors.gold),
            _target('More', AppColors.white, Icons.more_horiz, border: true),
          ]),
          const SizedBox(height: 18),
          WhiteCard(
            padding: const EdgeInsets.all(12),
            radius: 18,
            child: Row(children: [
              const Icon(Icons.people_outline, size: 20, color: AppColors.success),
              const SizedBox(width: 10),
              Expanded(
                  child: RichText(
                      text: TextSpan(style: AppTheme.dm(size: 12, color: AppColors.ink), children: const [
                TextSpan(text: 'Invite friends to '),
                TextSpan(text: 'add & vote', style: TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(text: ' on places')
              ]))),
              Text('Invite', style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.gold)),
            ]),
          ),
          const SizedBox(height: 16),
          WideButton(label: 'Done', color: AppColors.navy, height: 50, radius: 999, onTap: () => Navigator.maybePop(context)),
        ],
      ),
    );
  }

  Widget _target(String label, Color? bg, IconData icon,
          {List<Color>? gradient, Color iconColor = Colors.white, bool border = false}) =>
      Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
                color: bg,
                gradient: gradient != null
                    ? LinearGradient(
                        colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : null,
                shape: BoxShape.circle,
                border: border ? Border.all(color: AppColors.border) : null),
            child: Icon(icon, color: border ? AppColors.navy : iconColor, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTheme.dm(size: 11, color: AppColors.ink)),
        ],
      );
}

class _SheetScaffold extends StatelessWidget {
  const _SheetScaffold({required this.child, required this.bg});
  final Widget child;
  final Gradient bg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: bg))),
        const Positioned.fill(child: ColoredBox(color: Color(0x8C0B101C))),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
                color: Color(0xF5F5F0E8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
            child: SafeArea(top: false, child: child),
          ),
        ),
      ]),
    );
  }
}
