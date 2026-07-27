import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/arrival_checklist_section.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/ask_sahely_ai_section.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/booked_property_header.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/booking_info_chips.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/door_passcode_sos_buttons.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/location_map_section.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/property_details_card.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/property_photo_gallery.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/rate_your_stay_section.dart';
import 'package:sahely/data/sample_data.dart';

/// Enum for the user role to customize the active booking detail screen.
enum ActiveBookingRole { renter, owner, broker }

/// Unified Active Booking Detail Screen shared across all 3 roles.
class ActiveBookingDetailScreen extends StatefulWidget {
  final Property? property;
  final Map<String, dynamic>? bookingData;
  final ActiveBookingRole role;

  const ActiveBookingDetailScreen({
    super.key,
    this.property,
    this.bookingData,
    this.role = ActiveBookingRole.renter,
  });

  @override
  State<ActiveBookingDetailScreen> createState() =>
      _ActiveBookingDetailScreenState();
}

class _ActiveBookingDetailScreenState extends State<ActiveBookingDetailScreen> {
  final TextEditingController _aiController = TextEditingController();

  @override
  void dispose() {
    _aiController.dispose();
    super.dispose();
  }

  

  String get _propertyName {
    if (widget.property != null) return widget.property!.name;
    return widget.bookingData?['propertyName'] ?? 'Lagoon Retreat';
  }

  String get _location {
    if (widget.property != null) {
      return '${widget.property!.area} Â· North Coast';
    }
    return widget.bookingData?['location'] ?? 'Marassi Â· North Coast';
  }

  String get _imageUrl {
    if (widget.property != null) return widget.property!.image;
    return widget.bookingData?['imageUrl'] ?? '';
  }

  String get _orderNumber {
    return widget.bookingData?['orderNumber'] ?? 'SHLY-7741';
  }

  String get _dates {
    return widget.bookingData?['dates'] ?? 'Jun 14â€“18';
  }

  String get _guests {
    return widget.bookingData?['guests'] ?? '2A Â· 1C';
  }

  @override
  Widget build(BuildContext context) {
    final prop = widget.property ?? Sample.lagoon;
    final isOwner = widget.role == ActiveBookingRole.owner;
    final isBroker = widget.role == ActiveBookingRole.broker;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // Header with Hero Image
          SliverToBoxAdapter(
            child: BookedPropertyHeader(
              propertyName: _propertyName,
              location: _location,
              imageUrl: _imageUrl.isNotEmpty ? _imageUrl : prop.image,
              onBackTap: () => Navigator.pop(context),
            ),
          ),

          // Photo Gallery
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PropertyPhotoGallery(
                photos: [
                  _imageUrl.isNotEmpty ? _imageUrl : prop.image,
                  Sample.lagoon.image,
                  Sample.dunes.image,
                ],
              ),
            ),
          ),

          // Booking Info Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BookingInfoChips(
                orderNumber: _orderNumber,
                dates: _dates,
                guests: _guests,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Door Passcode & SOS Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DoorPasscodeSosButtons(
                onDoorPasscodeTap: () {
                  if (isOwner) {
                    AppNavigation.goToOwnerSmartLock(context);
                  } else if (isBroker) {
                    AppNavigation.goToBrokerSmartLock(
                      context,
                      extra: {
                        'propertyName': _propertyName,
                        'bookingRef': _orderNumber,
                        'passcode': '8842',
                        'checkIn':
                            widget.bookingData?['checkIn'] ?? DateTime.now(),
                        'checkOut': widget.bookingData?['checkOut'] ??
                            DateTime.now().add(const Duration(days: 4)),
                        'propertyLat': 31.0263,
                        'propertyLng': 28.9402,
                      },
                    );
                  } else {
                    AppNavigation.goToSmartLock(context, extra: prop);
                  }
                },
                onSOSTap: () {
                  if (isOwner) {
                    AppNavigation.goToSosOwner(context);
                  } else if (isBroker) {
                    AppNavigation.goToBrokerSos(context);
                  } else {
                    AppNavigation.goToSos(context);
                  }
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Property Details
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: PropertyDetailsCard(
                details: {
                  'bedrooms': 3,
                  'beds': 4,
                  'bathrooms': 2,
                  'beach': 'Hacienda White Beach',
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Location
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LocationMapSection(location: _location),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Arrival Checklist
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ArrivalChecklistSection(
                checklist: const [
                  {'label': 'Pool clean & usable', 'completed': true},
                  {
                    'label': 'WiFi works (password on fridge)',
                    'completed': true
                  },
                  {'label': 'AC in all rooms', 'completed': true},
                  {'label': '5 beds made & linens fresh', 'completed': true},
                  {'label': 'Beach access tags (4)', 'completed': false},
                  {'label': 'Kitchen fully equipped', 'completed': false},
                ],
                onChecklistChanged: (_) {},
                onReportIssue: () {
                  AppNavigation.push(context, '/arrival-checklist');
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Rate Your Stay
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RateYourStaySection(
                onAddReview: () {
                  AppNavigation.goToWriteReview(
                    context,
                    extra: prop,
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Ask Sahely AI
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: AskSahelyAiSection(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }
}

