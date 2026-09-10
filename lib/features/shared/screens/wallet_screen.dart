import 'package:flutter/material.dart';

import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/wallet_add_credit_button.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/wallet_balance_card.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/wallet_recent_activity.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/widgets/wallet_stats_tiles.dart';
import 'package:sahely/features/renter/presentation/screens/wallet/pages/add_credit_sheet.dart';

/// LIVE wallet screen — balance, season totals and recent activity all come
/// from GET /wallet, /wallet/transactions and /violations/mine.
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ApiClient _api = ApiClient();

  bool _loading = true;
  int _balancePiastres = 0;
  int _addedThisSeasonPiastres = 0;
  int _openViolations = 0;
  List<Map<String, dynamic>> _recent = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    int balance = 0;
    int added = 0;
    int violations = 0;
    final recent = <Map<String, dynamic>>[];

    try {
      final wRes = await _api.get(ApiEndpoints.wallet);
      final w = asMap(unwrapData(wRes.data));
      balance = w['spendable_piastres'] as int? ??
          w['balance_piastres'] as int? ??
          (w['balance'] as num?)?.toInt() ??
          0;
    } catch (_) {}

    try {
      final tRes =
          await _api.get(ApiEndpoints.walletTransactions, queryParameters: {
        'page': 1,
        'limit': 10,
      });
      final td = unwrapData(tRes.data);
      final list = ((td is Map ? td['data'] : td) as List?) ?? const [];
      for (final raw in list) {
        final tx = Map<String, dynamic>.from(raw as Map);
        final amount = (tx['amount_piastres'] ?? tx['amount'] ?? 0) as num;
        if (amount > 0) added += amount.toInt();
        recent.add({
          'type': '${tx['type'] ?? 'transaction'}',
          'title':
              '${tx['description'] ?? tx['type'] ?? 'Transaction'}'
                  .replaceAll('_', ' '),
          'subtitle': '${tx['created_at'] ?? ''}'.substring(0,
              '${tx['created_at'] ?? ''}'.length >= 10 ? 10 : '${tx['created_at'] ?? ''}'.length),
          'amount': amount.toInt(),
        });
      }
    } catch (_) {}

    try {
      final vRes = await _api.get('/violations/mine');
      final vd = unwrapData(vRes.data);
      final vlist = ((vd is Map ? vd['violations'] : vd) as List?) ?? const [];
      violations = vlist
          .where((e) {
            final st =
                '${(e as Map)['status'] ?? ''}'.toLowerCase();
            return st == 'pending' || st == 'open';
          })
          .length;
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _balancePiastres = balance;
      _addedThisSeasonPiastres = added;
      _openViolations = violations;
      _recent = recent;
      _loading = false;
    });
  }

  void _showAddCreditSheet(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddCreditSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColors.navy,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Wallet',
          style: AppTheme.dm(
            size: 18,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh, color: AppColors.navy),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WalletBalanceCard(
                        balance: _balancePiastres,
                        subtitle: 'Use credit toward bookings & services',
                      ),
                      const SizedBox(height: 16),
                      WalletAddCreditButton(
                        onAddCredit: () {
                          _showAddCreditSheet(context);
                          Future.delayed(
                              const Duration(milliseconds: 400), _load);
                        },
                      ),
                      const SizedBox(height: 20),
                      WalletStatsTiles(
                        addedThisSeason: _addedThisSeasonPiastres,
                        openViolations: _openViolations,
                      ),
                      const SizedBox(height: 24),
                      WalletRecentActivity(transactions: _recent, onViewAll: () {}),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
