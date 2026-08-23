import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import '../../../../../../core/utils/currency_formatter.dart';

class ConciergeBookingScreen extends StatefulWidget {
  final String serviceName;
  final int? basePrice;

  const ConciergeBookingScreen({
    super.key,
    required this.serviceName,
    this.basePrice,
  });

  @override
  State<ConciergeBookingScreen> createState() => _ConciergeBookingScreenState();
}

class _ConciergeBookingScreenState extends State<ConciergeBookingScreen> {
  int _quantity = 1;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedBooking;
  final TextEditingController _notesController = TextEditingController();
  String _paymentMethod = 'Wallet';

  final List<String> _activeBookings = [
    'Marassi – Chalet #12 (Jul 15 – Jul 22)',
    'Hacienda – Villa #5 (Aug 01 – Aug 10)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Book ${widget.serviceName}',
            style: AppTheme.dm(
                color: AppColors.navy, weight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quantity
            _buildSectionTitle('Quantity'),
            Row(
              children: [
                _buildStepperButton(Icons.remove, () {
                  if (_quantity > 1) setState(() => _quantity--);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('$_quantity',
                      style: AppTheme.dm(
                          size: 18, weight: FontWeight.bold)),
                ),
                _buildStepperButton(Icons.add, () {
                  setState(() => _quantity++);
                }),
              ],
            ),
            const SizedBox(height: 24),

            // Date & Time
            _buildSectionTitle('Date & Time'),
            Row(
              children: [
                Expanded(
                  child: _buildPickerTile(
                    icon: Icons.calendar_today,
                    label: _selectedDate == null
                        ? 'Select Date'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPickerTile(
                    icon: Icons.access_time,
                    label: _selectedTime == null
                        ? 'Select Time'
                        : _selectedTime!.format(context),
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Link to Booking
            _buildSectionTitle('Link to Active Booking'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border : null,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedBooking,
                  isExpanded: true,
                  hint: const Text('Choose a confirmed booking'),
                  items: _activeBookings.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedBooking = val),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Notes
            _buildSectionTitle('Notes for Provider'),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Any special requests?',
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Method
            _buildSectionTitle('Payment Method'),
            _buildPaymentOption(
                'Wallet', '${CurrencyFormatter.format(2450)} available', Icons.account_balance_wallet),
            const SizedBox(height: 12),
            _buildPaymentOption('Credit Card', '**** 4242', Icons.credit_card),

            const SizedBox(height: 40),

            // Price Breakdown & Button
            if (widget.basePrice != null) ...[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Price',
                      style:
                          AppTheme.dm(size: 16, color: AppColors.secondary)),
                  Text('EGP ${widget.basePrice! * _quantity}',
                      style: AppTheme.dm(
                          size: 20,
                          weight: FontWeight.bold,
                          color: AppColors.navy)),
                ],
              ),
              const SizedBox(height: 20),
            ],

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Confirm & Pay',
                    style: AppTheme.dm(
                        color: Colors.white,
                        size: 16,
                        weight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title,
          style: AppTheme.dm(
              size: 16,
              weight: FontWeight.w700,
              color: AppColors.navy)),
    );
  }

  Widget _buildStepperButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border : null,
        ),
        child: Icon(icon, size: 20, color: AppColors.navy),
      ),
    );
  }

  Widget _buildPickerTile(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.navy),
            const SizedBox(width: 8),
            Expanded(
                child: Text(label,
                    style: AppTheme.dm(size: 13),
                    overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, IconData icon) {
    bool isSelected = _paymentMethod == title;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.navy),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTheme.dm(weight: FontWeight.bold)),
                Text(subtitle,
                    style: AppTheme.dm(
                        size: 12, color: AppColors.secondary)),
              ],
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.navy),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  void _submitBooking() {
    if (_selectedDate == null ||
        _selectedTime == null ||
        _selectedBooking == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    // Logic for API call: POST /concierge/bookings
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text(
            'Your service request has been sent to the provider. They will contact you via WhatsApp shortly.'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK')),
        ],
      ),
    );
  }
}
