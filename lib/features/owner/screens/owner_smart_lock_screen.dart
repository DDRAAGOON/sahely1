import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';

class OwnerSmartLockScreen extends StatelessWidget {
  const OwnerSmartLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          const TopBar(title: 'Smart Lock', subtitle: 'Azure Beach Villa'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF22335A), AppColors.navy]),
                borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                      color: Color(0xFF46B7A8), shape: BoxShape.circle),
                  child: const Icon(Icons.lock_outline, color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Lock online',
                        style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w700,
                            color: Colors.white)),
                    Text('Battery 86% · synced 2m ago',
                        style: AppTheme.dm(size: 12, color: Colors.white60)),
                  ])),
            ]),
          ),
          const SizedBox(height: 14),
          WhiteCard(
            padding: const EdgeInsets.all(14),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Current passcode',
                  style: AppTheme.dm(size: 13, color: AppColors.muted)),
              const SizedBox(height: 8),
              Row(children: [
                Text('4 8 2 9 1 7',
                    style: AppTheme.dm(
                        size: 24,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                        letterSpacing: 4)),
                const Spacer(),
                const Icon(Icons.copy, color: AppColors.gold),
              ]),
              const SizedBox(height: 12),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFCEEDD),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                      'Guest checked in — passcode is locked until check-out (Jun 25) for their security.',
                      style: AppTheme.dm(
                          size: 12,
                          color: const Color(0xFF8A6A1E),
                          height: 1.4))),
              const SizedBox(height: 12),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBE3D9),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock, size: 16, color: Color(0xFF717171)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Change passcode (after check-out)',
                        style: AppTheme.dm(
                          size: 13,
                          weight: FontWeight.w600,
                          color: const Color(0xFF717171),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Access log',
                style: AppTheme.dm(
                    size: 15, weight: FontWeight.w700, color: AppColors.navy)),
            Text('Export',
                style: AppTheme.dm(
                    size: 13, weight: FontWeight.w600, color: AppColors.gold)),
          ]),
          const SizedBox(height: 8),
          WhiteCard(
              child: Column(children: [
            _logRow('Omar Khalil (guest)', 'Entered · Today 3:12 PM', true),
            _logRow('Omar Khalil (guest)', 'Left · Today 11:40 AM', false),
            _logRow('Cleaning · Sahely', 'Entered · Jun 20 9:05 AM', true),
            _logRow('You (owner)', 'Entered · Jun 18 6:20 PM', true,
                last: true),
          ])),
        ],
      ),
    );
  }

  Widget _logRow(String name, String meta, bool entry, {bool last = false}) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: last
            ? null
            : const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
        child: Row(children: [
          Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color:
                      entry ? const Color(0xFFE6F4EC) : const Color(0xFFEFEAE1),
                  shape: BoxShape.circle),
              child: Icon(entry ? Icons.login : Icons.logout,
                  size: 15,
                  color: entry ? AppColors.success : AppColors.muted)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(name,
                    style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
                Text(meta,
                    style: AppTheme.dm(size: 11, color: AppColors.muted)),
              ])),
        ]),
      );
}
