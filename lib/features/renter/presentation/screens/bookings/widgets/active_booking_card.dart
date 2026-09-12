import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/image.dart';

class ActiveBookingCard extends StatelessWidget {
  final String propertyName;
  final String location;
  final String orderNumber;
  final String dates;
  final String guests;
  final String imageUrl;
  final VoidCallback onDigitalLockTap;
  final VoidCallback onSOSTap;
  final VoidCallback onViewDetailsTap;

  const ActiveBookingCard({
    super.key,
    required this.propertyName,
    required this.location,
    required this.orderNumber,
    required this.dates,
    required this.guests,
    required this.imageUrl,
    required this.onDigitalLockTap,
    required this.onSOSTap,
    required this.onViewDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4B87A), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: AspectRatio(
                  aspectRatio: 1.8,
                  child: AppNetworkImage(url: imageUrl),
                ),
              ),
              // Status Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B6B3A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.circle, color: Colors.white, size: 6),
                      const SizedBox(width: 6),
                      Text(
                        'Active • Checked in',
                        style: AppTheme.dm(
                          color: Colors.white,
                          size: 11,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Name and Location Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        propertyName,
                        style: AppTheme.dm(
                          color: Colors.white,
                          size: 18,
                          weight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.white70, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: AppTheme.dm(
                              color: Colors.white70,
                              size: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRow('Order no.', orderNumber),
                const SizedBox(height: 8),
                _buildRow('Dates', dates),
                const SizedBox(height: 8),
                _buildRow('Guests', guests),
                const SizedBox(height: 16),

                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onDigitalLockTap,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B2744),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.lock_outline,
                                  color: Color(0xFFC9A84C), size: 18),
                              const SizedBox(width: 8),
                              Flexible(
                                child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Digital Lock',
                                      style: AppTheme.dm(
                                        color: Colors.white,
                                        weight: FontWeight.w700,
                                        size: 14,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: onSOSTap,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.sos, // Updated to sosRed color
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'SOS',
                                style: AppTheme.dm(
                                  color: Colors.white,
                                  weight: FontWeight.w700,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // View Details
                GestureDetector(
                  onTap: onViewDetailsTap,
                  child: Text(
                    'View booking details →',
                    style: AppTheme.dm(
                      color: const Color(0xFFC9A84C),
                      size: 13,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.dm(
            color: const Color(0xFF9A9A9A),
            size: 13,
          ),
        ),
        Text(
          value,
          style: AppTheme.dm(
            color: const Color(0xFF1B2744),
            size: 13,
            weight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
