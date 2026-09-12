import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/smart_lock/data/smart_lock_api_data_source.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/check_in_out_footer.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/get_directions_button.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/lock_icon_widget.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/lock_info_cards.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/lock_info_text.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/lock_status_badge.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/passcode_display.dart';
import 'package:sahely/l10n/app_localizations.dart';

class SmartLockScreen extends StatefulWidget {
  final String propertyName;
  final String bookingRef;

  /// The stay whose door PIN this is (`GET /bookings/:id/lock/pin`).
  final String bookingId;

  final DateTime checkIn;
  final DateTime checkOut;
  final double propertyLat;
  final double propertyLng;

  const SmartLockScreen({
    super.key,
    required this.propertyName,
    required this.bookingRef,
    this.bookingId = '',
    required this.checkIn,
    required this.checkOut,
    required this.propertyLat,
    required this.propertyLng,
  });

  @override
  State<SmartLockScreen> createState() => _SmartLockScreenState();
}

class _SmartLockScreenState extends State<SmartLockScreen> {
  /// The door PIN, once the backend has issued it for this stay.
  String _passcode = '';
  bool _isInRange = false;
  double _distance = 0.0;
  bool _isLoading = true;
  StreamSubscription<Position>? _positionStream;

  static const double _rangeThreshold = 2.0; // 2 km

  @override
  void initState() {
    super.initState();
    _initLocation();
    _loadPasscode();
  }

  /// The PIN is issued by the backend and only inside the check-in window;
  /// outside it the display stays blank rather than showing a made-up code.
  Future<void> _loadPasscode() async {
    if (widget.bookingId.isEmpty) return;
    try {
      final lock = await sl<SmartLockApiDataSource>().bookingPin(
        widget.bookingId,
      );
      final pin = '${pick(lock, 'pin') ?? pick(lock, 'passcode') ?? pick(lock, 'code') ?? ''}';
      if (mounted && pin.isNotEmpty) setState(() => _passcode = pin);
    } catch (_) {
      // No PIN yet: the screen keeps its locked state.
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      _positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(
        (Position position) => _updateDistance(position),
      );

      final initialPosition = await Geolocator.getCurrentPosition();
      _updateDistance(initialPosition);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _updateDistance(Position position) {
    final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          widget.propertyLat,
          widget.propertyLng,
        ) /
        1000;

    if (mounted) {
      setState(() {
        _distance = distance;
        _isInRange = distance <= _rangeThreshold;
        _isLoading = false;
      });
    }
  }

  Future<void> _copyPasscode() async {
    await Clipboard.setData(ClipboardData(text: _passcode));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).passcodeCopied),
          backgroundColor: const Color(0xFFC49F45),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _getDirections() async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${widget.propertyLat},${widget.propertyLng}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  bool get _isActive {
    final now = DateTime.now();
    return (now.isAtSameMomentAs(widget.checkIn) ||
            now.isAfter(widget.checkIn)) &&
        now.isBefore(widget.checkOut);
  }

  bool get _isPast => DateTime.now().isAfter(widget.checkOut);

  /// Whether the backend gave us a location for this listing.
  bool get _hasLocation => widget.propertyLat != 0 || widget.propertyLng != 0;

  @override
  Widget build(BuildContext context) {
    final bool canUnlock = _isActive && _isInRange && _passcode.isNotEmpty;
    final bool isExpired = _isPast;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF223053),
            Color(0xFF11182C),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFC49F45)))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTopBar(),
                      const SizedBox(height: 32),
                      LockIconWidget(isInRange: canUnlock),
                      const SizedBox(height: 24),
                      Text(
                        isExpired
                            ? AppLocalizations.of(context).accessExpired
                            : (canUnlock
                                ? 'Your Door Passcode'
                                : AppLocalizations.of(context).passcodeLocked),
                        style: AppTheme.dm(
                          size: 26,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isExpired
                            ? AppLocalizations.of(context).stayEnded
                            : '${widget.propertyName} · Keypad',
                        style: AppTheme.dm(
                          size: 15,
                          color: isExpired
                              ? Colors.redAccent
                              : const Color(0xFFC49F45),
                        ),
                      ),
                      const SizedBox(height: 40),
                      PasscodeDisplay(
                        passcode: isExpired || _passcode.isEmpty
                            ? '----'
                            : _passcode,
                        isInRange: canUnlock,
                        onCopyTap: isExpired ? null : _copyPasscode,
                      ),
                      const SizedBox(height: 32),
                      if (isExpired)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            AppLocalizations.of(context).smartLockOnlyActive,
                            textAlign: TextAlign.center,
                            style: AppTheme.dm(color: Colors.white70, size: 13),
                          ),
                        )
                      else
                        LockInfoCards(
                          isInRange: canUnlock,
                          distance: _distance,
                          checkOut: widget.checkOut,
                        ),
                      const SizedBox(height: 24),
                      if (!isExpired) LockInfoText(isInRange: canUnlock),
                      const SizedBox(height: 40),
                      // Directions need the listing's coordinates; without
                      // them there is nowhere to send the guest.
                      if (!canUnlock && !isExpired && _hasLocation)
                        GetDirectionsButton(onTap: _getDirections),
                      const SizedBox(height: 48),
                      CheckInOutFooter(
                          checkIn: widget.checkIn, checkOut: widget.checkOut),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Icons.chevron_left, color: Colors.white, size: 24),
            ),
          ),
          LockStatusBadge(isInRange: _isInRange, distance: _distance),
        ],
      ),
    );
  }
}
