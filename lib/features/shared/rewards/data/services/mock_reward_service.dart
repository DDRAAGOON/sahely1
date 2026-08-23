import 'package:flutter/foundation.dart';
import '../../domain/services/reward_service.dart';

class MockRewardService implements RewardService {
  @override
  Future<void> awardStars({
    required String userId,
    required int amount,
    required String reason,
  }) async {
    debugPrint('REWARD: Awarded $amount stars to $userId for "$reason"');
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
