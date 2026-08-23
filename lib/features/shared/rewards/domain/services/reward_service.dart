abstract class RewardService {
  Future<void> awardStars({
    required String userId,
    required int amount,
    required String reason,
  });
}
