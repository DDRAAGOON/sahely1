import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/sample_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/ui.dart';
import '../widgets/filter_widgets.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String? _propertyType;
  String? _bedrooms;
  int _adults = 0;
  int _children = 0;
  RangeValues _priceRange = const RangeValues(1000, 15000);
  DateTime? _checkIn;
  DateTime? _checkOut;

  final Map<String, bool> _rules = {
    'Party allowed': false,
    'Pets allowed': false,
    'Mixed groups OK': false,
  };

  final Set<String> _selectedAmenities = {};

  int get _resultsCount {
    return Sample.allTrending.where((p) {
      if (_propertyType != null && _propertyType != 'All' && p.type != _propertyType) return false;
      if (_bedrooms != null && _bedrooms != 'Any') {
        final bedsStr = _bedrooms!.replaceAll('+', '');
        final filterBeds = int.tryParse(bedsStr) ?? 0;
        if (_bedrooms!.contains('+')) {
          if (p.beds < filterBeds) return false;
        } else {
          if (p.beds != filterBeds) return false;
        }
      }
      if (_adults + _children > p.guests && p.guests != 0) return false;
      if (p.price < _priceRange.start || p.price > _priceRange.end) return false;
      if (_selectedAmenities.isNotEmpty && !_selectedAmenities.every((am) => p.tags.contains(am))) return false;
      if (_rules['Pets allowed'] == true && !p.petsOk) return false;
      return true;
    }).length;
  }

  void _clearAll() {
    setState(() {
      _propertyType = null;
      _bedrooms = null;
      _adults = 0;
      _children = 0;
      _priceRange = const RangeValues(1000, 15000);
      _checkIn = null;
      _checkOut = null;
      _rules.updateAll((key, value) => false);
      _selectedAmenities.clear();
    });
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isCheckIn ? _checkIn : _checkOut) ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.navy,
              onPrimary: Colors.white,
              onSurface: AppColors.navy,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          if (_checkOut != null && _checkOut!.isBefore(_checkIn!)) {
            _checkOut = null;
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const ColoredBox(color: Color(0xFF93969E)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.88,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const SheetHandle(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Filters', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
                          GestureDetector(
                            onTap: _clearAll,
                            child: Text('Clear All', style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(22, 4, 22, 14),
                        children: [
                          _label('Dates'),
                          const SizedBox(height: 8),
                          Row(children: [
                            Expanded(
                              child: FilterDateBox(
                                _checkIn == null ? 'Check-in' : DateFormat('MMM d, yyyy').format(_checkIn!),
                                onTap: () => _selectDate(context, true),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilterDateBox(
                                _checkOut == null ? 'Check-out' : DateFormat('MMM d, yyyy').format(_checkOut!),
                                onTap: () => _selectDate(context, false),
                              ),
                            ),
                          ]),
                          _label('PROPERTY TYPE'),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 10,
                            children: [
                              for (var type in ['All', 'Villa', 'Chalet', 'Apartment'])
                                ChoiceChipPill(
                                  type,
                                  selected: _propertyType == type,
                                  height: 30,
                                  horizontalPadding: 10,
                                  onTap: () => setState(() {
                                    if (type == 'All') {
                                      _propertyType = (_propertyType == 'All') ? null : 'All';
                                    } else {
                                      _propertyType = (_propertyType == type) ? null : type;
                                    }
                                  }),
                                ),
                            ],
                          ),
                          _label('BEDROOMS'),
                          Wrap(
                            spacing: 8,
                            runSpacing: 10,
                            children: [
                              for (var b in ['Any', '1', '2', '3', '4+'])
                                ChoiceChipPill(
                                  b,
                                  selected: _bedrooms == b,
                                  height: 40,
                                  width: b.length > 2 ? null : 54,
                                  horizontalPadding: b.length > 2 ? 18 : 0,
                                  onTap: () => setState(() {
                                    if (b == 'Any') {
                                      _bedrooms = (_bedrooms == 'Any') ? null : 'Any';
                                    } else {
                                      _bedrooms = (_bedrooms == b) ? null : b;
                                    }
                                  }),
                                ),
                            ],
                          ),
                          _label('GUESTS'),
                          GuestStepRow(
                            'Adults',
                            'Ages 18+',
                            _adults,
                            onChanged: (v) => setState(() => _adults = v),
                          ),
                          const Divider(height: 1, color: Color(0xFFF0EBE2)),
                          GuestStepRow(
                            'Children',
                            'Ages 2–17',
                            _children,
                            onChanged: (v) => setState(() => _children = v),
                          ),
                          const SizedBox(height: 14),
                          RichText(
                            text: TextSpan(
                              text: 'Price Range · ',
                              style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy),
                              children: [
                                TextSpan(
                                  text: 'EGP ${_priceRange.start.round()} – ${_priceRange.end.round()}',
                                  style: AppTheme.dm(size: 13, color: AppColors.muted),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          PriceSlider(
                            values: _priceRange,
                            onChanged: (v) => setState(() => _priceRange = v),
                          ),
                          _label('House Rules'),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(color: const Color(0xFFF0EBE2)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Column(children: [
                              for (var entry in _rules.entries) ...[
                                RuleToggle(
                                  entry.key,
                                  entry.value,
                                  onChanged: (v) => setState(() => _rules[entry.key] = v),
                                ),
                                if (entry.key != _rules.keys.last) const Divider(height: 1, color: Color(0xFFF4EFE7)),
                              ],
                            ]),
                          ),
                          const SizedBox(height: 20),
                          _label('AMENITIES'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 10,
                            children: [
                              for (var am in ['Pool', 'WiFi', 'Beach', 'Smart Lock', 'AC', 'Sea View', 'Parking', 'BBQ', 'Garden'])
                                ChoiceChipPill(
                                  am,
                                  selected: _selectedAmenities.contains(am),
                                  height: 30,
                                  horizontalPadding: 10,
                                  borderRadius: 16,
                                  onTap: () => setState(() {
                                    if (_selectedAmenities.contains(am)) {
                                      _selectedAmenities.remove(am);
                                    } else {
                                      _selectedAmenities.add(am);
                                    }
                                  }),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
                      child: NavyButton(
                        label: 'Show Results ($_resultsCount)',
                        onTap: () {
                          final filterSummary = {
                            'type': _propertyType,
                            'beds': _bedrooms,
                            'guests': _adults + _children,
                            'price': 'EGP ${_priceRange.start.round()} – ${_priceRange.end.round()}',
                            'minPrice': _priceRange.start,
                            'maxPrice': _priceRange.end,
                            'dates': _checkIn != null && _checkOut != null
                                ? '${DateFormat("MMM d").format(_checkIn!)} – ${DateFormat("MMM d").format(_checkOut!)}'
                                : null,
                            'rules': _rules.entries.where((e) => e.value).map((e) => e.key).toList(),
                            'amenities': _selectedAmenities.toList(),
                          };
                          Navigator.pop(context, filterSummary);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _label(String s) => Padding(
        padding: const EdgeInsets.only(top: 22, bottom: 8),
        child: Text(s.toUpperCase(),
            style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.navy, letterSpacing: 0.5)),
      );
}
