import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/shared/properties/domain/entities/property_query.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/sheet_handle.dart';

import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import '../../../../../../core/utils/currency_formatter.dart';
import '../../../../../../core/widgets/bouncy_button.dart';

class SearchFiltersSheet extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final List<Property> allProperties;
  final Function(Map<String, dynamic>) onApplyFilters;
  final ScrollController? scrollController;

  const SearchFiltersSheet({
    super.key,
    required this.initialFilters,
    required this.allProperties,
    required this.onApplyFilters,
    this.scrollController,
  });

  @override
  State<SearchFiltersSheet> createState() => _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends State<SearchFiltersSheet> {
  // Filter States
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  late String _selectedPropertyType;
  late String _selectedBedrooms;
  int _adults = 0;
  int _children = 0;
  late RangeValues _currentRangeValues;
  late bool _partyAllowed;
  late bool _petsAllowed;
  late bool _mixedGroupsOK;
  late Set<String> _selectedAmenities;
  int _resultsCount = 0;

  final List<String> _propertyTypes = ['All', 'Villa', 'Chalet', 'Apartment'];
  final List<String> _bedrooms = ['Any', '1', '2', '3', '4+'];
  final List<String> _amenitiesRow1 = ['Pool', 'Wi-Fi', 'Beach', 'AC'];
  final List<String> _amenitiesRow2 = [
    'Smart Lock',
    'Sea View',
    'Parking',
    'BBQ',
    'Garden'
  ];

  @override
  void initState() {
    super.initState();
    _selectedPropertyType = widget.initialFilters['propertyType'] ?? 'All';
    _selectedBedrooms = widget.initialFilters['bedrooms'] ?? 'Any';
    _currentRangeValues = RangeValues(
      widget.initialFilters['minPrice'] ?? 0.0,
      widget.initialFilters['maxPrice'] ?? 100000.0,
    );
    _selectedAmenities =
        Set<String>.from(widget.initialFilters['amenities'] ?? []);
    // Force them to false for the initial "Everything zero" state
    _partyAllowed = widget.initialFilters['partyAllowed'] ?? false;
    _petsAllowed = widget.initialFilters['petsAllowed'] ?? false;
    _mixedGroupsOK = widget.initialFilters['mixedGroupsOK'] ?? false;
    _adults = widget.initialFilters['adults'] ?? 0;
    _children = widget.initialFilters['children'] ?? 0;

    _updateResultsCount();
  }

  Timer? _countDebounce;
  int _countRequest = 0;

  /// "Show N stays" is the server's own count for the current selection, so
  /// the number on the button is the number of results that follow.
  void _updateResultsCount() {
    _countDebounce?.cancel();
    _countDebounce =
        Timer(const Duration(milliseconds: 350), _fetchResultsCount);
  }

  Future<void> _fetchResultsCount() async {
    final request = ++_countRequest;
    try {
      final result = await sl<RenterRepository>().searchProperties(
        PropertyQuery.fromFilters(_currentFilters()),
        limit: 1,
      );
      if (!mounted || request != _countRequest) return;
      setState(() => _resultsCount = result.total);
    } catch (_) {
      if (!mounted || request != _countRequest) return;
      setState(() => _resultsCount = 0);
    }
  }

  Map<String, dynamic> _currentFilters() => {
        'propertyType': _selectedPropertyType,
        'bedrooms': _selectedBedrooms,
        'minPrice': _currentRangeValues.start,
        'maxPrice': _currentRangeValues.end,
        'amenities': _selectedAmenities.toList(),
        'partyAllowed': _partyAllowed,
        'petsAllowed': _petsAllowed,
        'mixedGroupsOK': _mixedGroupsOK,
        'adults': _adults,
        'children': _children,
        'checkIn': _checkInDate,
        'checkOut': _checkOutDate,
      };

  @override
  void dispose() {
    _countDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const SheetHandle(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters',
                      style: AppTheme.dm(
                          size: 24,
                          weight: FontWeight.w700,
                          color: AppColors.navy)),
                  BouncyButton(
                    onTap: _clearAllFilters,
                    child: Text(
                      'Clear All',
                      style: AppTheme.dm(
                          size: 14,
                          weight: FontWeight.w600,
                          color: AppColors.gold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDatesSection(),
                    const SizedBox(height: 24),
                    _buildPropertyTypeSection(),
                    const SizedBox(height: 24),
                    _buildBedroomsSection(),
                    const SizedBox(height: 24),
                    _buildGuestsSection(),
                    const SizedBox(height: 32),
                    _buildPriceRangeSection(),
                    const SizedBox(height: 32),
                    _buildHouseRulesSection(),
                    const SizedBox(height: 32),
                    _buildAmenitiesSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildShowResultsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dates',
            style: AppTheme.dm(
                size: 16, weight: FontWeight.w700, color: AppColors.navy)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildDateField(
                    label: 'Check-in',
                    date: _checkInDate,
                    onTap: () => _selectDate(context, isCheckIn: true))),
            const SizedBox(width: 12),
            Expanded(
                child: _buildDateField(
                    label: 'Check-out',
                    date: _checkOutDate,
                    onTap: () => _selectDate(context, isCheckIn: false))),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
      {required String label,
      required DateTime? date,
      required VoidCallback onTap}) {
    return BouncyButton(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(10),
            border: null),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 16, color: AppColors.gold),
            const SizedBox(width: 8),
            Text(
                date != null ? '${date.day}/${date.month}/${date.year}' : label,
                style: AppTheme.dm(
                    size: 13,
                    color:
                        date != null ? AppColors.dark : AppColors.placeholder)),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Property Type',
            style: AppTheme.dm(
                size: 16, weight: FontWeight.w700, color: AppColors.navy)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _propertyTypes.map((type) {
            final isSelected = _selectedPropertyType == type;
            return BouncyButton(
              onTap: () {
                setState(() => _selectedPropertyType = type);
                _updateResultsCount();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutQuart,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.navy : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.navy.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  type,
                  style: AppTheme.dm(
                      size: 13,
                      weight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.navy),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBedroomsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bedrooms',
            style: AppTheme.dm(
                size: 16, weight: FontWeight.w700, color: AppColors.navy)),
        const SizedBox(height: 12),
        Row(
          children: _bedrooms.map((bedroom) {
            final isSelected = _selectedBedrooms == bedroom;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: BouncyButton(
                  onTap: () {
                    setState(() => _selectedBedrooms = bedroom);
                    _updateResultsCount();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutQuart,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.navy : AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.navy.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        bedroom,
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w600,
                            color:
                                isSelected ? AppColors.white : AppColors.navy),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGuestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Guests',
            style: AppTheme.dm(
                size: 16, weight: FontWeight.w700, color: AppColors.navy)),
        const SizedBox(height: 12),
        _buildGuestRow(
            label: 'Adults',
            subtitle: 'Ages 18+',
            count: _adults,
            onRemove: () {
              if (_adults > 0) setState(() => _adults--);
              _updateResultsCount();
            },
            onAdd: () {
              setState(() => _adults++);
              _updateResultsCount();
            }),
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: AppColors.border, thickness: 0.5)),
        _buildGuestRow(
            label: 'Children',
            subtitle: 'Ages 2-17',
            count: _children,
            onRemove: () {
              if (_children > 0) setState(() => _children--);
              _updateResultsCount();
            },
            onAdd: () {
              setState(() => _children++);
              _updateResultsCount();
            }),
      ],
    );
  }

  Widget _buildGuestRow(
      {required String label,
      required String subtitle,
      required int count,
      required VoidCallback onRemove,
      required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: AppTheme.dm(
                  size: 14, weight: FontWeight.w600, color: AppColors.dark)),
          Text(subtitle,
              style: AppTheme.dm(size: 12, color: AppColors.secondary)),
        ]),
        Row(children: [
          _buildStepperButton(
              icon: Icons.remove, onTap: onRemove, isOutline: true),
          const SizedBox(width: 16),
          Text('$count',
              style: AppTheme.dm(
                  size: 16, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(width: 16),
          _buildStepperButton(icon: Icons.add, onTap: onAdd, isOutline: false),
        ]),
      ],
    );
  }

  Widget _buildStepperButton(
      {required IconData icon,
      required VoidCallback onTap,
      required bool isOutline}) {
    return BouncyButton(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
            color: isOutline ? AppColors.white : AppColors.navy,
            shape: BoxShape.circle,
            border: isOutline
                ? Border.all(color: AppColors.navy, width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ]),
        child: Icon(icon,
            size: 18, color: isOutline ? AppColors.navy : AppColors.white),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('Price Range',
              style: AppTheme.dm(
                  size: 16, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(width: 8),
          Text(
              '${CurrencyFormatter.format(_currentRangeValues.start.round())} – ${CurrencyFormatter.format(_currentRangeValues.end.round())}',
              style: AppTheme.dm(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.secondary)),
        ]),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.gold,
            inactiveTrackColor: AppColors.border,
            thumbColor: AppColors.navy,
            rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 10, elevation: 4),
            overlayColor: AppColors.navy.withValues(alpha: 0.1),
            trackHeight: 4,
          ),
          child: RangeSlider(
            values: _currentRangeValues,
            min: 0,
            max: 100000,
            onChanged: (RangeValues values) {
              setState(() => _currentRangeValues = values);
              _updateResultsCount();
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _buildPriceLabel('Min', _currentRangeValues.start.round()),
          _buildPriceLabel('Max', _currentRangeValues.end.round()),
        ]),
      ],
    );
  }

  Widget _buildPriceLabel(String label, int value) {
    return RichText(
      text: TextSpan(style: AppTheme.dm(), children: [
        TextSpan(
            text: '$label ',
            style: AppTheme.dm(
                size: 10, weight: FontWeight.w500, color: AppColors.secondary)),
        TextSpan(
            text: CurrencyFormatter.format(value),
            style: AppTheme.dm(
                size: 12, weight: FontWeight.w700, color: AppColors.navy)),
      ]),
    );
  }

  Widget _buildHouseRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('House Rules',
            style: AppTheme.dm(
                size: 16, weight: FontWeight.w700, color: AppColors.navy)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: null),
          child: Column(children: [
            _buildToggleRow(
                icon: Icons.camera_alt_outlined,
                label: 'Party allowed',
                value: _partyAllowed,
                onChanged: (v) {
                  setState(() => _partyAllowed = v);
                  _updateResultsCount();
                }),
            const Divider(height: 1, color: AppColors.border),
            _buildToggleRow(
                icon: Icons.pets,
                label: 'Pets allowed',
                value: _petsAllowed,
                onChanged: (v) {
                  setState(() => _petsAllowed = v);
                  _updateResultsCount();
                }),
            const Divider(height: 1, color: AppColors.border),
            _buildToggleRow(
                icon: Icons.people_outline,
                label: 'Mixed groups OK',
                value: _mixedGroupsOK,
                onChanged: (v) {
                  setState(() => _mixedGroupsOK = v);
                  _updateResultsCount();
                }),
          ]),
        ),
      ],
    );
  }

  Widget _buildToggleRow(
      {required IconData icon,
      required String label,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: [
        Icon(icon, size: 20, color: AppColors.navy),
        const SizedBox(width: 12),
        Expanded(
            child: Text(label,
                style: AppTheme.dm(size: 14, color: AppColors.dark))),
        Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.white,
            activeTrackColor: AppColors.green,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.border),
      ]),
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amenities',
            style: AppTheme.dm(
                size: 16, weight: FontWeight.w700, color: AppColors.navy)),
        const SizedBox(height: 12),
        Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amenitiesRow1.map((a) => _buildAmenityChip(a)).toList()),
        const SizedBox(height: 8),
        Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amenitiesRow2.map((a) => _buildAmenityChip(a)).toList()),
      ],
    );
  }

  Widget _buildAmenityChip(String amenity) {
    final isSelected = _selectedAmenities.contains(amenity);
    return BouncyButton(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedAmenities.remove(amenity);
          } else {
            _selectedAmenities.add(amenity);
          }
        });
        _updateResultsCount();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutQuart,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.navy.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(amenity,
            style: AppTheme.dm(
                size: 13,
                weight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.navy)),
      ),
    );
  }

  Widget _buildShowResultsButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          24, 8, 24, 24), // Reduced bottom padding from 100 to 24
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: BouncyButton(
          onTap: _applyFilters,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'Show Results ($_resultsCount)',
              style: AppTheme.dm(
                size: 15,
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isCheckIn}) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
        } else {
          _checkOutDate = picked;
        }
      });
      _updateResultsCount();
    }
  }

  void _clearAllFilters() {
    setState(() {
      _checkInDate = null;
      _checkOutDate = null;
      _selectedPropertyType = 'All';
      _selectedBedrooms = 'Any';
      _currentRangeValues = const RangeValues(0.0, 100000.0);
      _selectedAmenities = {};
      _partyAllowed = false;
      _petsAllowed = false;
      _mixedGroupsOK = false;
      _adults = 0;
      _children = 0;
    });
    _updateResultsCount();
  }

  void _applyFilters() {
    final filters = _currentFilters();
    Navigator.of(context).pop();
    widget.onApplyFilters(filters);
  }
}
