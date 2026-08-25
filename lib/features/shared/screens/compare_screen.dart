import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/core/widgets/image.dart';

class CompareScreen extends StatefulWidget {
  final String collectionName;
  final List<String> participantNames;
  final Property? propertyA;
  final Property? propertyB;

  const CompareScreen({
    super.key,
    this.collectionName = 'All Saved',
    this.participantNames = const ['Omar', 'Nour', 'Sara'],
    this.propertyA,
    this.propertyB,
  });

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  Property? _propA;
  Property? _propB;

  @override
  void initState() {
    super.initState();
    _propA = widget.propertyA;
    _propB = widget.propertyB;
    
    // If only one property is provided, prompt to select the second one
    if (widget.propertyA != null && widget.propertyB == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectProperty(false);
      });
    } else if (widget.propertyA == null && widget.propertyB == null) {
      // If none provided, prompt for the first one
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectProperty(true);
      });
    }
  }

  void _selectProperty(bool isA) {
    String searchQuery = '';
    showModalBottomSheet(
      useRootNavigator: true, context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final filteredList = Sample.allTrending.where((p) {
            final nameMatch = p.name.toLowerCase().contains(searchQuery.toLowerCase());
            final areaMatch = p.area.toLowerCase().contains(searchQuery.toLowerCase());
            return nameMatch || areaMatch;
          }).toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Select Property to Compare',
                  style: AppTheme.dm(size: 20, weight: FontWeight.w800, color: AppColors.navy),
                ),
                const SizedBox(height: 16),
                // Search Bar
                Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 18, color: AppColors.gold),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setModalState(() => searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'Search by name or area...',
                            hintStyle: AppTheme.dm(size: 13, color: AppColors.textPlaceholder),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: AppTheme.dm(size: 14),
                        ),
                      ),
                      if (searchQuery.isNotEmpty)
                        GestureDetector(
                          onTap: () => setModalState(() => searchQuery = ''),
                          child: const Icon(Icons.close, size: 18, color: AppColors.muted),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: filteredList.isEmpty
                      ? Center(
                          child: Text(
                            'No properties found.',
                            style: AppTheme.dm(color: AppColors.muted),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final p = filteredList[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AppNetworkImage(url: p.image, width: 60, height: 60),
                              ),
                              title: Row(
                                children: [
                                  Expanded(child: Text(p.name, style: AppTheme.dm(weight: FontWeight.w700))),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: p.saved ? AppColors.gold.withValues(alpha: 0.2) : AppColors.border.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      p.saved ? widget.collectionName : 'All Properties',
                                      style: AppTheme.dm(size: 9, weight: FontWeight.w600, color: p.saved ? AppColors.navy : AppColors.muted),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                '${p.area} · ${CurrencyFormatter.format(p.price)}',
                                style: AppTheme.dm(size: 12, color: AppColors.muted),
                              ),
                              onTap: () {
                                setState(() {
                                  if (isA) {
                                    _propA = p;
                                  } else {
                                    _propB = p;
                                  }
                                });
                                Navigator.pop(ctx);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Compare',
                          style: AppTheme.dm(
                              size: 18,
                              weight: FontWeight.w700,
                              color: AppColors.gold)),
                      Text(widget.collectionName,
                          style: AppTheme.dm(
                              size: 12,
                              color: Colors.white.withValues(alpha: 0.6))),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => AppNavigation.goToShareCollection(
                    context,
                    collectionName: widget.collectionName,
                    shareableLink: 'sahely.app/compare/${widget.collectionName.toLowerCase().replaceAll(' ', '-')}',
                  ),
                  child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(children: [
                        const Icon(Icons.link, size: 14, color: AppColors.navy),
                        const SizedBox(width: 4),
                        Text('Share',
                            style: AppTheme.dm(
                                size: 12,
                                weight: FontWeight.w700,
                                color: AppColors.navy))
                      ])),
                ),
              ]),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectProperty(true),
                                child: _propA != null 
                                    ? _teaserCard(_propA!.image, _propA!.name, CurrencyFormatter.format(_propA!.price))
                                    : _emptyTeaserCard('Add Property'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectProperty(false),
                                child: _propB != null 
                                    ? _teaserCard(_propB!.image, _propB!.name, CurrencyFormatter.format(_propB!.price))
                                    : _emptyTeaserCard('Add Property'),
                              ),
                            ),
                          ]),
                          
                          const SizedBox(height: 16),

                          WhiteCard(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            radius: 20,
                            child: Column(children: [
                              _tableRow(
                                'Collection',
                                _propA == null ? '-' : (_propA!.saved ? widget.collectionName : 'All Properties'),
                                _propB == null ? '-' : (_propB!.saved ? widget.collectionName : 'All Properties'),
                                0,
                              ),
                              _divider(),
                              _tableRow('Location', _propA?.area ?? '-', _propB?.area ?? '-', 1),
                              _divider(),
                              _tableRow('Type', _propA?.type ?? '-', _propB?.type ?? '-', 2),
                              _divider(),
                              _tableRow(
                                'Price', 
                                _propA != null ? CurrencyFormatter.format(_propA!.price) : '-', 
                                _propB != null ? CurrencyFormatter.format(_propB!.price) : '-', 
                                1
                              ),
                              _divider(),
                              _tableRow(
                                'Rating', 
                                _propA != null ? '★ ${_propA!.rating} (${_propA!.reviews})' : '-', 
                                _propB != null ? '★ ${_propB!.rating} (${_propB!.reviews})' : '-', 
                                1
                              ),
                              _divider(),
                              _tableRow('Bedrooms', _propA != null ? '${_propA!.beds} bdr' : '-', _propB != null ? '${_propB!.beds} bdr' : '-', 1),
                              _divider(),
                              _tableRow('Guests', _propA != null ? '${_propA!.guests} guests' : '-', _propB != null ? '${_propB!.guests} guests' : '-', 1),
                              _divider(),
                              _tableRow(
                                'Beach', 
                                _propA != null ? (_propA!.minutesToBeach != null ? '${_propA!.minutesToBeach} min' : '-') : '-', 
                                _propB != null ? (_propB!.minutesToBeach != null ? '${_propB!.minutesToBeach} min' : '-') : '-', 
                                1
                              ),
                              _divider(),
                              _tableRow('Pets OK', _propA != null ? (_propA!.petsOk ? '✓' : '×') : '-', _propB != null ? (_propB!.petsOk ? '✓' : '×') : '-', 1),
                            ]),
                          ),

                          const SizedBox(height: 20),

                          Row(children: [
                            Expanded(
                              child: WideButton(
                                label: _propA != null ? 'Book ${_propA!.name.split(" ").first}' : 'Select A',
                                color: AppColors.navy,
                                enabled: _propA != null,
                                height: 48,
                                radius: 14,
                                onTap: _propA != null ? () => AppNavigation.goToPropertyDetail(context, extra: _propA) : () => _selectProperty(true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: WideButton(
                                label: _propB != null ? 'Book ${_propB!.name.split(" ").first}' : 'Select B',
                                color: AppColors.gold,
                                textColor: AppColors.navy,
                                enabled: _propB != null,
                                height: 48,
                                radius: 14,
                                onTap: _propB != null ? () => AppNavigation.goToPropertyDetail(context, extra: _propB) : () => _selectProperty(false),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _teaserCard(String img, String name, String price) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 106,
          child: Stack(fit: StackFit.expand, children: [
            AppNetworkImage(url: img),
            const DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x99000000)]))),
            Positioned(
                left: 12,
                bottom: 10,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: Colors.white)),
                      Text(price, style: AppTheme.dm(size: 11, weight: FontWeight.w700, color: AppColors.gold)),
                    ])),
          ]),
        ),
      );

  Widget _emptyTeaserCard(String label) => Container(
        height: 106,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, color: AppColors.gold, size: 28),
              const SizedBox(height: 4),
              Text(label, style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: AppColors.navy)),
            ],
          ),
        ),
      );

  Widget _tableRow(String label, String val1, String val2, int highlight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Expanded(flex: 3, child: Text(label, style: AppTheme.dm(size: 12, color: AppColors.textSecondary))),
        Expanded(flex: 2, child: Center(child: Text(val1, style: AppTheme.dm(size: 12, weight: highlight == 1 ? FontWeight.w700 : FontWeight.w400, color: highlight == 1 ? AppColors.gold : AppColors.navy)))),
        Expanded(flex: 2, child: Center(child: Text(val2, style: AppTheme.dm(size: 12, weight: highlight == 2 ? FontWeight.w700 : FontWeight.w400, color: highlight == 2 ? AppColors.gold : AppColors.navy)))),
      ]),
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFF0EBE2));
}
