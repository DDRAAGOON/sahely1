import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/features/owner/screens/listing_submitted_screen.dart';

import '../../../core/navigation/app_navigation.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  int step = 0;

  /// Localized step titles for display only.
  String _localizedTitle(BuildContext context, int index) {
    final l = AppLocalizations.of(context);
    switch (index) {
      case 0:
        return l.stepBasics;
      case 1:
        return l.stepLocation;
      case 2:
        return l.stepFeatures;
      case 3:
        return l.stepPhotos;
      default:
        return '';
    }
  }

  bool _submitted = false;

  // State Variables
  String? _propertyType;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _guestsController = TextEditingController();
  final _numBedsController = TextEditingController();
  bool? _petsOk;
  bool? _partyOk;
  bool? _mixedOk;
  final _referralController = TextEditingController();
  final _customAmenityController = TextEditingController();

  final Set<String> _selectedAmenities = {};

  // Location & Specs Variables
  final _areaController = TextEditingController();
  final _addressController = TextEditingController();
  final _propNoController = TextEditingController();
  final _floorController = TextEditingController();
  final _sqmController = TextEditingController();
  final _floorsInUnitController = TextEditingController();
  final _metersFromSeaController = TextEditingController();
  String? _propertyView;
  LatLng? _selectedLatLng;
  final List<XFile> _pickedImages = [];

  static const _suggested = [
    ('Air conditioning (all rooms)', Icons.ac_unit),
    ('Smart TV', Icons.tv),
    ('Private pool', Icons.pool),
    ('Wi-Fi 200 Mbps', Icons.wifi),
    ('Fully equipped kitchen', Icons.restaurant),
    ('Cleaning before arrival', Icons.clean_hands),
    ('Safe box', Icons.lock_outline),
    ('24/7 security', Icons.security),
    ('Roller shutters', Icons.grid_view),
    ('Microwave', Icons.microwave),
    ('Nespresso Machine', Icons.coffee_maker),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _guestsController.dispose();
    _numBedsController.dispose();
    _referralController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    _propNoController.dispose();
    _floorController.dispose();
    _sqmController.dispose();
    _floorsInUnitController.dispose();
    _metersFromSeaController.dispose();
    _customAmenityController.dispose();
    super.dispose();
  }

  Property _createPropertyObject(PropertyStatus status) {
    return Property(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.isEmpty
          ? (status == PropertyStatus.draft ? 'New Draft Listing' : 'Untitled Property')
          : _nameController.text,
      area: _areaController.text.split(',').first,
      image: _pickedImages.isNotEmpty ? _pickedImages.first.path : '',
      price: int.tryParse(_referralController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      rating: 0.0,
      reviews: 0,
      type: _propertyType ?? '',
      beds: int.tryParse(_numBedsController.text) ?? 0,
      guests: int.tryParse(_guestsController.text) ?? 0,
      petsOk: _petsOk ?? true,
      tags: _selectedAmenities.toList(),
      status: status,
    );
  }

  void _submit() {
    final newProp = _createPropertyObject(PropertyStatus.underReview);
    Sample.ownerProperties.insert(0, newProp);
    setState(() => _submitted = true);
    
    // Auto navigate to properties after a short delay from success screen if needed, 
    // but the requirement says "وديني ليها"
    Future.delayed(const Duration(seconds: 3), () {
       if (mounted) AppNavigation.goToOwnerProperties(context, filter: 'Under Review');
    });
  }

  void _saveAsDraft() {
    final newProp = _createPropertyObject(PropertyStatus.draft);
    Sample.ownerProperties.insert(0, newProp);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).draftSaved)),
    );
    
    AppNavigation.goToOwnerProperties(context, filter: 'Draft');
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() => _pickedImages.addAll(images));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return ListingSubmittedScreen(
          propertyName: _nameController.text.isEmpty
              ? 'Untitled Property'
              : _nameController.text);
    }
    return PhoneScaffold(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(children: [
            GestureDetector(
                onTap: () => step == 0
                    ? Navigator.maybePop(context)
                    : setState(() => step--),
                child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        border : null,
                        borderRadius: BorderRadius.circular(9)),
                    child: const Icon(Icons.chevron_left,
                        size: 20, color: AppColors.navy))),
            const SizedBox(width: 12),
            Text('Add Property',
                style: AppTheme.dm(
                    size: 16, weight: FontWeight.w700, color: AppColors.navy)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            for (var i = 0; i < 4; i++) ...[
              Expanded(
                  child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: i <= step ? AppColors.gold : AppColors.border,
                          borderRadius: BorderRadius.circular(3)))),
              if (i < 3) const SizedBox(width: 6),
            ],
          ]),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text('${AppLocalizations.of(context).stepOf(step + 1, 4)} · ${_localizedTitle(context, step)}',
                    style: AppTheme.dm(size: 12, color: AppColors.muted)))),
        Expanded(child: _stepBody()),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.transparent),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
                onTap: _saveAsDraft,
                child: Text(AppLocalizations.of(context).saveDraft,
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.gold))),
            SizedBox(
              width: 170,
              child: NavyButton(
                  label: step == 3 ? AppLocalizations.of(context).submitListing : AppLocalizations.of(context).continueBtn,
                  height: 45,
                  onTap: () => step == 3 ? _submit() : setState(() => step++)),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _stepBody() {
    return switch (step) {
      0 =>
        ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 16), children: [
          FieldGroup(
            label: AppLocalizations.of(context).propertyType,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  border : null,
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _propertyType,
                  hint: Text(AppLocalizations.of(context).selectType,
                      style: AppTheme.dm(size: 14, color: AppColors.navy)),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      size: 18, color: AppColors.muted),
                  items: ['Villa', 'Chalet', 'Apartment']
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, style: AppTheme.dm(size: 14))))
                      .toList(),
                  onChanged: (v) => setState(() => _propertyType = v!),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FieldGroup(
              label: AppLocalizations.of(context).propertyNameLabel,
              child:
                  AppTextField(controller: _nameController, hintText: AppLocalizations.of(context).nameHint)),
          const SizedBox(height: 12),
          FieldGroup(
              label: AppLocalizations.of(context).descriptionLabel,
              child: AppTextField(
                  controller: _descController,
                  height: 100,
                  hintText: AppLocalizations.of(context).describeHint)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: FieldGroup(
                    label: AppLocalizations.of(context).bedrooms,
                    child: _NumericInput(controller: _bedroomsController))),
            const SizedBox(
              width: 12,
            ),
            Expanded(
                child: FieldGroup(
                    label: AppLocalizations.of(context).bathrooms,
                    child: _NumericInput(controller: _bathroomsController))),
            const SizedBox(width: 12),
            Expanded(
                child: FieldGroup(
                    label: AppLocalizations.of(context).guestsLabel,
                    child: _NumericInput(controller: _guestsController))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: FieldGroup(
                    label: AppLocalizations.of(context).numberOfBeds,
                    child: _NumericInput(controller: _numBedsController))),
            const SizedBox(width: 12),
            Expanded(
                child: FieldGroup(
                    label: AppLocalizations.of(context).petsAllowedQ,
                    child: _SegmentToggle(
                        _petsOk, (v) => setState(() => _petsOk = v)))),
          ]),
          const SizedBox(height: 12),
          FieldGroup(
              label: AppLocalizations.of(context).partyAllowedQ,
              child: _SegmentToggle(
                  _partyOk, (v) => setState(() => _partyOk = v))),
          const SizedBox(height: 12),
          FieldGroup(
              labelWidget: RichText(
                text: TextSpan(
                  style: AppTheme.dm(
                      size: 13, weight: FontWeight.w600, color: AppColors.navy),
                  children: [
                    TextSpan(text: AppLocalizations.of(context).mixedGroupsAllowedQ),
                    TextSpan(
                        text: '(unrelated men & women)',
                        style: AppTheme.dm(
                            color: const Color(0xFF9A9A9A),
                            weight: FontWeight.w400)),
                  ],
                ),
              ),
              child: _SegmentToggle(
                  _mixedOk, (v) => setState(() => _mixedOk = v))),
          const SizedBox(height: 12),
          FieldGroup(
              labelWidget: RichText(
                text: TextSpan(
                  style: AppTheme.dm(
                      size: 13, weight: FontWeight.w600, color: AppColors.navy),
                  children: [
                    TextSpan(text: AppLocalizations.of(context).referralCodeLabel),
                    TextSpan(
                        text: '(optional)',
                        style: AppTheme.dm(
                            color: const Color(0xFF9A9A9A),
                            weight: FontWeight.w400)),
                  ],
                ),
              ),
              child: AppTextField(
                controller: _referralController,
                leading:
                    const Icon(Icons.star, size: 16, color: AppColors.gold),
                backgroundColor: AppColors.goldTint,
                hintText: '',
                textColor: const Color(0xFFaf944d),
              )),
        ]),
      // Step 2: Location & Specs (as per image and user request)
      1 =>
        ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 16), children: [
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push<LatLng>(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          MapPickerScreen(initialLocation: _selectedLatLng)));
              if (result != null) {
                setState(() => _selectedLatLng = result);
                // Optionally update address if we had reverse geocoding
              }
            },
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFCFE0E8),
                borderRadius: BorderRadius.circular(16),
                image: _selectedLatLng != null
                    ? null : null, // Could add a static map preview here
              ),
              child: Stack(
                children: [
                  if (_selectedLatLng != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AbsorbPointer(
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: _selectedLatLng!, zoom: 15),
                          markers: {
                            Marker(
                                markerId: const MarkerId('selected'),
                                position: _selectedLatLng!)
                          },
                        ),
                      ),
                    )
                  else
                    const Center(
                        child: Icon(Icons.location_on,
                            color: Color(0xFFB22222), size: 32)),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: AppColors.navy.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                          _selectedLatLng == null
                              ? AppLocalizations.of(context).dragPin
                              : AppLocalizations.of(context).locationSelected,
                          style: AppTheme.dm(
                              size: 11,
                              weight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FieldGroup(
              label: AppLocalizations.of(context).compoundArea,
              child: AppTextField(
                  controller: _areaController,
                  hintText: AppLocalizations.of(context).marassiHint)),
          const SizedBox(height: 12),
          FieldGroup(
              label: AppLocalizations.of(context).exactAddress,
              child: AppTextField(
                  controller: _addressController,
                  hintText: AppLocalizations.of(context).unitStreetHint)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: FieldGroup(
                    label: AppLocalizations.of(context).propertyNo,
                    child: AppTextField(
                        controller: _propNoController,
                        hintText: 'e.g. B-214'))),
            const SizedBox(width: 12),
            Expanded(
                child: FieldGroup(
                    label: AppLocalizations.of(context).floorIfApartment,
                    child: AppTextField(
                        controller: _floorController, hintText: 'e.g. 4')))
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: FieldGroup(
                    label: 'Area (m²)',
                    child: AppTextField(
                        controller: _sqmController, hintText: '320'))),
            const SizedBox(width: 12),
            Expanded(
                child: FieldGroup(
                    label: AppLocalizations.of(context).floorsInUnit,
                    child: AppTextField(
                        controller: _floorsInUnitController, hintText: '2')))
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: FieldGroup(
                    label: AppLocalizations.of(context).metersFromSea,
                    child: AppTextField(
                        controller: _metersFromSeaController,
                        hintText: '150 m'))),
            const SizedBox(width: 12),
            Expanded(
                child: FieldGroup(
                    label: AppLocalizations.of(context).viewLabel,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          border : null,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _propertyView,
                          hint: Text(AppLocalizations.of(context).selectView,
                              style: AppTheme.dm(
                                  size: 14, color: AppColors.muted.withValues(alpha: 0.6))),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              size: 18, color: AppColors.muted),
                          items: [
                            'Sea view',
                            'Pool view',
                            'Garden view',
                            'Street view'
                          ]
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e, style: AppTheme.dm(size: 14))))
                              .toList(),
                          onChanged: (v) => setState(() => _propertyView = v!),
                        ),
                      ),
                    ))),
          ]),
        ]),
      2 =>
        ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 16), children: [
          const InfoNote(
              text:
                  'What is this? List everything in your home. Guests use this exact list as their arrival checklist — only add what\'s really there, or you may get a violation.',
              icon: Icons.help_outline),
          const SizedBox(height: 14),
          SectionLabel('${AppLocalizations.of(context).addedLabel} · ${_selectedAmenities.length}'),
          const SizedBox(height: 8),
          WhiteCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Column(children: [
                if (_selectedAmenities.isEmpty)
                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(AppLocalizations.of(context).noAmenitiesYet,
                          style:
                              AppTheme.dm(size: 13, color: AppColors.muted))),
                for (var i = 0; i < _selectedAmenities.length; i++) ...[
                  _amenityRow(_selectedAmenities.elementAt(i),
                      added: true,
                      onTap: () => setState(() => _selectedAmenities
                          .remove(_selectedAmenities.elementAt(i)))),
                  if (i < _selectedAmenities.length - 1)
                    const Divider(height: 1, color: Color(0xFFF4EFE7)),
                ]
              ])),
          const SizedBox(height: 14),
          const SectionLabel('SUGGESTED — TAP TO ADD'),
          const SizedBox(height: 8),
          WhiteCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Column(children: [
                for (var i = 0; i < _suggested.length; i++)
                  if (!_selectedAmenities.contains(_suggested[i].$1)) ...[
                    _amenityRow(_suggested[i].$1,
                        added: false,
                        icon: _suggested[i].$2,
                        onTap: () => setState(
                            () => _selectedAmenities.add(_suggested[i].$1))),
                    if (_suggested
                            .where((e) => !_selectedAmenities.contains(e.$1))
                            .toList()
                            .last
                            .$1 !=
                        _suggested[i].$1)
                      const Divider(height: 1, color: Color(0xFFF4EFE7)),
                  ]
              ])),
          const SizedBox(height: 18),
          SectionLabel(AppLocalizations.of(context).customFeatures),
          const SizedBox(height: 8),
          WhiteCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _customAmenityController,
                    hintText: 'e.g. Nespresso machine',
                    height: 44,
                    radius: 12,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    final val = _customAmenityController.text.trim();
                    if (val.isNotEmpty) {
                      setState(() {
                        _selectedAmenities.add(val);
                        _customAmenityController.clear();
                      });
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ]),
      3 =>
        ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 16), children: [
          Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                const Icon(Icons.info_outline, color: AppColors.gold, size: 20),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(AppLocalizations.of(context).photoGuidelines,
                        style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w700,
                            color: Colors.white))),
                Text('Read →',
                    style: AppTheme.dm(
                        size: 12,
                        weight: FontWeight.w700,
                        color: AppColors.gold)),
              ])),
          const SizedBox(height: 10),
          Row(children: [
            const Pill('☀ Daylight / morning',
                bg: AppColors.white,
                border: AppColors.gold,
                fg: Color(0xFF9A7A22),
                radius: 20),
            const SizedBox(width: 8),
            const Pill('📷 Vertical',
                bg: AppColors.white,
                border: AppColors.gold,
                fg: Color(0xFF9A7A22),
                radius: 20),
            const SizedBox(width: 8),
            Pill(AppLocalizations.of(context).min5Photos,
                bg: AppColors.white,
                border: AppColors.gold,
                fg: const Color(0xFF9A7A22),
                radius: 20)
          ]),
          const SizedBox(height: 18),
          Text(AppLocalizations.of(context).requiredShots,
              style: AppTheme.dm(
                  size: 14, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 8),
          WhiteCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Column(children: [
                ChecklistTile(
                    label: AppLocalizations.of(context).compoundLayoutShot,
                    done: true,
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                const Divider(height: 1, color: Color(0xFFF4EFE7)),
                const ChecklistTile(
                    label: "Each room + each room's view",
                    done: true,
                    padding: EdgeInsets.symmetric(vertical: 12)),
                const Divider(height: 1, color: Color(0xFFF4EFE7)),
                ChecklistTile(
                    label: AppLocalizations.of(context).balconyViewShot,
                    done: true,
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                const Divider(height: 1, color: Color(0xFFF4EFE7)),
                ChecklistTile(
                    label: AppLocalizations.of(context).everyToiletShot,
                    done: true,
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                const Divider(height: 1, color: Color(0xFFF4EFE7)),
                ChecklistTile(
                    label: AppLocalizations.of(context).outsideDoorShot,
                    done: false,
                    warn: true,
                    padding: const EdgeInsets.symmetric(vertical: 12)),
              ])),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _pickImages,
            child: DottedBorder(
                color: AppColors.gold,
                child: Container(
                    height: 110,
                    alignment: Alignment.center,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.cloud_upload_outlined,
                          size: 30, color: AppColors.gold),
                      const SizedBox(height: 8),
                      Text(AppLocalizations.of(context).uploadPhotos,
                          style: AppTheme.dm(
                              size: 14,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      Text(AppLocalizations.of(context).dragDrop,
                          style: AppTheme.dm(size: 12, color: AppColors.muted))
                    ]))),
          ),
          if (_pickedImages.isNotEmpty) ...[
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _pickedImages.length + 1,
              itemBuilder: (context, index) {
                if (index == _pickedImages.length) {
                  return GestureDetector(
                    onTap: _pickImages,
                    child: DottedBorder(
                      color: AppColors.gold,
                      radius: 12,
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.add, color: AppColors.gold),
                      ),
                    ),
                  );
                }
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_pickedImages[index].path),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (index == 0)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(AppLocalizations.of(context).coverLabel,
                              style: AppTheme.dm(
                                  size: 10,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                        ),
                      ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _pickedImages.removeAt(index)),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              color: Colors.black45, shape: BoxShape.circle),
                          child: const Icon(Icons.close,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ]),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _amenityRow(String label,
      {required bool added, IconData? icon, VoidCallback? onTap}) {
    final IconData effectiveIcon = icon ??
        _suggested
            .firstWhere((e) => e.$1 == label, orElse: () => ('', Icons.star))
            .$2;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(effectiveIcon, size: 18, color: AppColors.navy),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Text(label,
                style: AppTheme.dm(size: 13, color: const Color(0xFF2D2D2D)))),
        GestureDetector(
          onTap: onTap,
          child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  color: added ? const Color(0xFFFDECEC) : AppColors.navy,
                  shape: BoxShape.circle),
              child: Icon(added ? Icons.remove : Icons.add,
                  size: 16,
                  color: added ? const Color(0xFFB22222) : Colors.white)),
        ),
      ]),
    );
  }
}

class _NumericInput extends StatelessWidget {
  const _NumericInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        border : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: AppTheme.dm(
              size: 16, weight: FontWeight.w700, color: AppColors.navy),
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            hintText: '0',
            hintStyle: AppTheme.dm(color: AppColors.muted.withValues(alpha: 0.6), size: 16),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle(this.selected, this.onChanged);

  final bool? selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        border : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                decoration: BoxDecoration(
                  color: selected == true ? AppColors.navy : Colors.transparent,
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(9)),
                ),
                alignment: Alignment.center,
                child: Text(AppLocalizations.of(context).yesLabel,
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w600,
                        color:
                            selected == true ? Colors.white : AppColors.navy)),
              ),
            ),
          ),
          Container(width: 1, color: AppColors.border),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      selected == false ? AppColors.navy : Colors.transparent,
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(9)),
                ),
                alignment: Alignment.center,
                child: Text(AppLocalizations.of(context).noBtn,
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w600,
                        color:
                            selected == false ? Colors.white : AppColors.navy)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerScreen({super.key, this.initialLocation});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late LatLng _currentCenter;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _currentCenter = widget.initialLocation ??
        const LatLng(
            31.0403, 31.3785); // Default to Mansoura/Egypt area or North Coast
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).selectLocation,
            style: AppTheme.dm(
                size: 16, weight: FontWeight.w700, color: AppColors.navy)),
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: const BackButton(color: AppColors.navy),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _currentCenter, zoom: 15),
            onMapCreated: (c) => _controller = c,
            onCameraMove: (pos) => _currentCenter = pos.target,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35), // Adjust for pin tip
              child:
                  Icon(Icons.location_on, color: Color(0xFFB22222), size: 40),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              mini: true,
              child: const Icon(Icons.my_location, color: AppColors.navy),
              onPressed: () async {
                final pos = await Geolocator.getCurrentPosition();
                _controller?.animateCamera(CameraUpdate.newLatLng(
                    LatLng(pos.latitude, pos.longitude)));
              },
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 30,
            child: NavyButton(
              label: AppLocalizations.of(context).confirmLocation,
              onTap: () => Navigator.pop(context, _currentCenter),
            ),
          ),
        ],
      ),
    );
  }
}
