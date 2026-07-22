import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/avatars.dart';
import 'package:sahely/core/widgets/cards.dart';
import 'package:sahely/core/widgets/common.dart';

class CollabCard extends StatelessWidget {
  const CollabCard({
    super.key,
    required this.image,
    required this.name,
    required this.loc,
    required this.tags,
    required this.pet,
    required this.petOk,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.comment,
  });

  final String image, name, loc, pet, rating, reviews, price, comment;
  final List<String> tags;
  final bool petOk;

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      padding: EdgeInsets.zero,
      radius: 16,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.network(
            image,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (c, child, p) => p == null
                ? child
                : Container(height: 180, color: const Color(0xFFE8E4DC)),
            errorBuilder: (_, __, ___) =>
                Container(height: 180, color: const Color(0xFFE8E4DC)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: AppTheme.dm(
                    size: 15, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 3),
            Row(children: [
              const Icon(Icons.location_on_outlined,
                  size: 11, color: AppColors.muted),
              const SizedBox(width: 3),
              Text(loc, style: AppTheme.dm(size: 12, color: AppColors.muted))
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final t in tags)
                Pill(t, bg: AppColors.cream, fg: AppColors.ink),
              Pill(pet,
                  bg: petOk ? const Color(0xFFD7EEDD) : const Color(0xFFFDECEC),
                  fg: petOk ? AppColors.success : const Color(0xFFB22222)),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                const Icon(Icons.star, size: 13, color: AppColors.gold),
                const SizedBox(width: 4),
                Text(rating,
                    style: AppTheme.dm(size: 13, weight: FontWeight.w700)),
                Text(' ($reviews)',
                    style: AppTheme.dm(size: 12, color: AppColors.muted))
              ]),
              Text('$price /night',
                  style: AppTheme.dm(
                      size: 13,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
            ]),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const AvatarCircle(
                    size: 22, colors: [Color(0xFF7FA8BF), Color(0xFF2C5066)]),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(comment,
                        style: AppTheme.dm(size: 12, color: AppColors.ink))),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}
