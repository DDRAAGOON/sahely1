import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';

class SearchFiltersSheet extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final List<Map<String, dynamic>> allProperties;
  final Function(Map<String, dynamic>) onApplyFilters;

  const SearchFiltersSheet({
    super.key,
    required this.initialFilters,
    required this.allProperties,
    required this.onApplyFilters,
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
  int _adults = 2;
  int _children = 1;
  late RangeValues _currentRangeValues;
  late bool _partyAllowed;
  late bool _petsAllowed;
  late bool _mixedGroupsOK;
  late Set<String> _selectedAmenities;
  int _resultsCount = 0;

  final List<String> _propertyTypes = ['All', 'Villa', 'Chalet', 'Apartment'];
  final List<String> _bedrooms = ['Any', '1', '2', '3', '4+'];
  final List<String> _amenitiesRow1 = ['Pool', 'WiFi', 'Beach', 'AC'];
  final List<String> _amenitiesRow2 = ['Smart Lock', 'Sea View', 'Parking', 'BBQ', 'Garden'];

  @override
  void initState() {
    super.initState();
    // تحميل البيانات المحفوظة بدقة
    _selectedPropertyType = widget.initialFilters['propertyType'] ?? 'All';
    _selectedBedrooms = widget.initialFilters['bedrooms'] ?? 'Any';
    _currentRangeValues = RangeValues(
      widget.initialFilters['minPrice'] ?? 0.0,
      widget.initialFilters['maxPrice'] ?? 100000.0,
    );
    _selectedAmenities = Set<String>.from(widget.initialFilters['amenities'] ?? []);
    _partyAllowed = widget.initialFilters['partyAllowed'] ?? true;
    _petsAllowed = widget.initialFilters['petsAllowed'] ?? false;
    _mixedGroupsOK = widget.initialFilters['mixedGroupsOK'] ?? true;
    
    _updateResultsCount();
  }

  void _updateResultsCount() {
    setState(() {
      // فلترة حقيقية لحساب العدد الدقيق
      var results = widget.allProperties;

      if (_selectedPropertyType != 'All') {
        results = results.where((p) => p['type'] == _selectedPropertyType).toList();
      }

      results = results.where((p) {
        double priceEgp = p['price'] / 100;
        return priceEgp >= _currentRangeValues.start && priceEgp <= _currentRangeValues.end;
      }).toList();

      if (_selectedBedrooms != 'Any') {
        int needed = int.parse(_selectedBedrooms.replaceAll('+', ''));
        results = results.where((p) => p['beds'] >= needed).toList();
      }

      if (_selectedAmenities.isNotEmpty) {
        results = results.where((p) {
          List features = p['features'] as List;
          return _selectedAmenities.every((a) => features.contains(a));
        }).toList();
      }

      if (_partyAllowed) results = results.where((p) => p['partyAllowed'] == true).toList();
      if (_petsAllowed) results = results.where((p) => p['petsAllowed'] == true).toList();
      if (_mixedGroupsOK) results = results.where((p) => p['mixedGroupsOK'] == true).toList();

      _resultsCount = results.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filters', style: Theme.of(context).textTheme.headlineMedium),
                GestureDetector(
                  onTap: _clearAllFilters,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gold, fontFamily: 'Cairo'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
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
    );
  }

  Widget _buildDatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildDateField(label: 'Check-in', date: _checkInDate, onTap: () => _selectDate(context, isCheckIn: true))),
            const SizedBox(width: 12),
            Expanded(child: _buildDateField(label: 'Check-out', date: _checkOutDate, onTap: () => _selectDate(context, isCheckIn: false))),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField({required String label, required DateTime? date, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.gold),
            const SizedBox(width: 8),
            Text(date != null ? '${date.day}/${date.month}/${date.year}' : label,
                style: TextStyle(fontSize: 13, color: date != null ? AppColors.dark : AppColors.placeholder, fontFamily: 'Cairo')),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Property Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _propertyTypes.map((type) {
            final isSelected = _selectedPropertyType == type;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedPropertyType = type);
                _updateResultsCount();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.navy : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? null : Border.all(color: AppColors.navy, width: 1),
                ),
                child: Text(type, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.white : AppColors.navy, fontFamily: 'Cairo')),
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
        const Text('Bedrooms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
        const SizedBox(height: 12),
        Row(
          children: _bedrooms.map((bedroom) {
            final isSelected = _selectedBedrooms == bedroom;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedBedrooms = bedroom);
                    _updateResultsCount();
                  },
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.navy : AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected ? null : Border.all(color: AppColors.navy, width: 1),
                    ),
                    child: Center(child: Text(bedroom, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.white : AppColors.navy, fontFamily: 'Cairo'))),
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
        const Text('Guests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
        const SizedBox(height: 12),
        _buildGuestRow(label: 'Adults', subtitle: 'Ages 18+', count: _adults, onRemove: () { if (_adults > 1) setState(() => _adults--); _updateResultsCount(); }, onAdd: () { setState(() => _adults++); _updateResultsCount(); }),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: AppColors.border, thickness: 0.5)),
        _buildGuestRow(label: 'Children', subtitle: 'Ages 2-17', count: _children, onRemove: () { if (_children > 0) setState(() => _children--); _updateResultsCount(); }, onAdd: () { setState(() => _children++); _updateResultsCount(); }),
      ],
    );
  }

  Widget _buildGuestRow({required String label, required String subtitle, required int count, required VoidCallback onRemove, required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark, fontFamily: 'Cairo')),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.secondary, fontFamily: 'Cairo')),
        ]),
        Row(children: [
          _buildStepperButton(icon: Icons.remove, onTap: onRemove, isOutline: true),
          const SizedBox(width: 16),
          Text('$count', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
          const SizedBox(width: 16),
          _buildStepperButton(icon: Icons.add, onTap: onAdd, isOutline: false),
        ]),
      ],
    );
  }

  Widget _buildStepperButton({required IconData icon, required VoidCallback onTap, required bool isOutline}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: isOutline ? AppColors.white : AppColors.navy, shape: BoxShape.circle, border: isOutline ? Border.all(color: AppColors.navy, width: 1.5) : null),
        child: Icon(icon, size: 18, color: isOutline ? AppColors.navy : AppColors.white),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Text('Price Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
          const SizedBox(width: 8),
          Text('EGP ${_currentRangeValues.start.round()} - ${_currentRangeValues.end.round()}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary, fontFamily: 'Cairo')),
        ]),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.gold, inactiveTrackColor: AppColors.border, thumbColor: AppColors.navy,
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10, elevation: 4),
            overlayColor: AppColors.navy.withValues(alpha: 0.1), trackHeight: 4,
          ),
          child: RangeSlider(
            values: _currentRangeValues, min: 0, max: 100000,
            onChanged: (RangeValues values) { setState(() => _currentRangeValues = values); _updateResultsCount(); },
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
      text: TextSpan(style: const TextStyle(fontFamily: 'Cairo'), children: [
        TextSpan(text: '$label ', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.secondary)),
        const TextSpan(text: 'EGP ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy)),
        TextSpan(text: '$value', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy)),
      ]),
    );
  }

  Widget _buildHouseRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('House Rules', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Column(children: [
            _buildToggleRow(icon: Icons.party_mode, label: 'Party allowed', value: _partyAllowed, onChanged: (v) { setState(() => _partyAllowed = v); _updateResultsCount(); }),
            const Divider(height: 1, color: AppColors.border),
            _buildToggleRow(icon: Icons.pets, label: 'Pets allowed', value: _petsAllowed, onChanged: (v) { setState(() => _petsAllowed = v); _updateResultsCount(); }),
            const Divider(height: 1, color: AppColors.border),
            _buildToggleRow(icon: Icons.groups, label: 'Mixed groups OK', value: _mixedGroupsOK, onChanged: (v) { setState(() => _mixedGroupsOK = v); _updateResultsCount(); }),
          ]),
        ),
      ],
    );
  }

  Widget _buildToggleRow({required IconData icon, required String label, required bool value, required ValueChanged<bool> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: [
        Icon(icon, size: 20, color: AppColors.navy),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.dark, fontFamily: 'Cairo'))),
        Switch(value: value, onChanged: onChanged, activeColor: AppColors.white, activeTrackColor: AppColors.green, inactiveThumbColor: AppColors.white, inactiveTrackColor: AppColors.border),
      ]),
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Amenities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo')),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: _amenitiesRow1.map((a) => _buildAmenityChip(a)).toList()),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: _amenitiesRow2.map((a) => _buildAmenityChip(a)).toList()),
      ],
    );
  }

  Widget _buildAmenityChip(String amenity) {
    final isSelected = _selectedAmenities.contains(amenity);
    return GestureDetector(
      onTap: () {
        setState(() { if (isSelected) _selectedAmenities.remove(amenity); else _selectedAmenities.add(amenity); });
        _updateResultsCount();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: isSelected ? AppColors.navy : AppColors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.navy, width: 1)),
        child: Text(amenity, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.white : AppColors.navy, fontFamily: 'Cairo')),
      ),
    );
  }

  Widget _buildShowResultsButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: SizedBox(
        width: double.infinity, height: 52,
        child: ElevatedButton(
          onPressed: _applyFilters,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: AppColors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
          child: Text('Show Results ($_resultsCount)', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Cairo')),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isCheckIn}) async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null) {
      setState(() { if (isCheckIn) _checkInDate = picked; else _checkOutDate = picked; });
      _updateResultsCount();
    }
  }

  void _clearAllFilters() {
    setState(() {
      _checkInDate = null; _checkOutDate = null; _selectedPropertyType = 'All'; _selectedBedrooms = 'Any';
      _currentRangeValues = const RangeValues(0.0, 100000.0); _selectedAmenities = {};
      _partyAllowed = true; _petsAllowed = false; _mixedGroupsOK = true;
    });
    _updateResultsCount();
  }

  void _applyFilters() {
    final filters = {
      'propertyType': _selectedPropertyType,
      'bedrooms': _selectedBedrooms,
      'minPrice': _currentRangeValues.start,
      'maxPrice': _currentRangeValues.end,
      'amenities': _selectedAmenities.toList(),
      'partyAllowed': _partyAllowed,
      'petsAllowed': _petsAllowed,
      'mixedGroupsOK': _mixedGroupsOK,
    };
    Navigator.pop(context); // Pop the sheet FIRST
    widget.onApplyFilters(filters); // Then trigger the navigation
  }
}
