import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/broker/presentation/screens/smart_lock/widgets/broker_check_in_out_footer.dart';
import 'package:sahely/features/broker/presentation/screens/smart_lock/widgets/broker_get_directions_button.dart';
import 'package:sahely/features/broker/presentation/screens/smart_lock/widgets/broker_lock_icon_widget.dart';
import 'package:sahely/features/broker/presentation/screens/smart_lock/widgets/broker_lock_info_cards.dart';
import 'package:sahely/features/broker/presentation/screens/smart_lock/widgets/broker_lock_info_text.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/features/broker/presentation/screens/smart_lock/widgets/broker_lock_status_badge.dart';
import 'package:sahely/features/smart_lock/data/smart_lock_api_data_source.dart';
import 'package:sahely/features/broker/presentation/screens/smart_lock/widgets/broker_passcode_display.dart';

class BrokerSmartLockScreen extends StatefulWidget {
  final String propertyName;
  final String bookingRef;

  /// The stay whose door PIN this is (`GET /bookings/:id/lock/pin`).
  final String bookingId;

  final DateTime checkIn;
  final DateTime checkOut;
  final double propertyLat;
  final double propertyLng;

  const BrokerSmartLockScreen({
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
  State<BrokerSmartLockScreen> createState() => _BrokerSmartLockScreenState();
}

class _BrokerSmartLockScreenState extends State<BrokerSmartLockScreen> {
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

  /// The PIN comes from the backend and only inside the check-in window;
  /// outside it the display stays blank rather than showing a made-up code.
  Future<void> _loadPasscode() async {
    if (widget.bookingId.isEmpty) return;
    try {
      final lock =
          await sl<SmartLockApiDataSource>().bookingPin(widget.bookingId);
      final pin =
          '${pick(lock, 'pin') ?? pick(lock, 'passcode') ?? pick(lock, 'code') ?? ''}';
      if (mounted && pin.isNotEmpty) setState(() => _passcode = pin);
    } catch (_) {
      // No PIN for this stay: the screen keeps its locked state.
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
        const SnackBar(
          content: Text('Passcode copied to clipboard'),
          backgroundColor: Color(0xFFC49F45),
          duration: Duration(seconds: 2),
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
    final bool canUnlock = _isActive && _isInRange;
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
                      BrokerLockIconWidget(isInRange: canUnlock),
                      const SizedBox(height: 24),
                      Text(
                        isExpired
                            ? 'Access Expired'
                            : (canUnlock
                                ? 'Your Door Passcode'
                                : 'Passcode Locked'),
                        style: AppTheme.dm(
                          size: 26,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isExpired
                            ? 'Your stay has ended'
                            : '${widget.propertyName} · Keypad',
                        style: AppTheme.dm(
                          size: 15,
                          color: isExpired
                              ? Colors.redAccent
                              : const Color(0xFFC49F45),
                        ),
                      ),
                      const SizedBox(height: 40),
                      BrokerPasscodeDisplay(
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
                            'Smart Lock access is only available during your active booking period.',
                            textAlign: TextAlign.center,
                            style: AppTheme.dm(color: Colors.white70, size: 13),
                          ),
                        )
                      else
                        BrokerLockInfoCards(
                          isInRange: canUnlock,
                          distance: _distance,
                          checkOut: widget.checkOut,
                        ),
                      const SizedBox(height: 24),
                      if (!isExpired) BrokerLockInfoText(isInRange: canUnlock),
                      const SizedBox(height: 40),
                      // Directions need the listing's coordinates; without
                      // them there is nowhere to send the guest.
                      if (!canUnlock && !isExpired && _hasLocation)
                        BrokerGetDirectionsButton(onTap: _getDirections),
                      const SizedBox(height: 48),
                      BrokerCheckInOutFooter(
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
          BrokerLockStatusBadge(isInRange: _isInRange, distance: _distance),
        ],
      ),
    );
  }
}
