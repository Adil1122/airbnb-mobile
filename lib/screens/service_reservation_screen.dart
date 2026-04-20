import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../services/payment_service.dart';
import '../models/booking_model.dart';

class ServiceReservationScreen extends StatefulWidget {
  final Listing listing;

  const ServiceReservationScreen({super.key, required this.listing});

  @override
  State<ServiceReservationScreen> createState() => _ServiceReservationScreenState();
}

class _ServiceReservationScreenState extends State<ServiceReservationScreen> {
  int _currentStep = 0; // 0: Schedule, 1: Review, 2: Payment, 3: Confirm
  String _selectedPaymentMethod = 'google_pay';
  int _guests = 1;
  late DateTime _selectedDate;
  String _selectedTime = '11:30 AM';
  int _selectedPackageIndex = 0;
  final _paymentService = PaymentService();

  final List<Map<String, dynamic>> _packages = [
    {
      'title': 'Quick Snap at Colosseum',
      'price': 36.0,
      'duration': '30 mins',
      'image': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=100&q=80',
      'timeSlots': ['11:30 AM', '12:00 PM', '12:30 PM', '1:00 PM', '1:30 PM'],
    },
    {
      'title': 'Signature Photoshoot',
      'price': 59.0,
      'duration': '1 hr',
      'image': 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=100&q=80',
      'timeSlots': ['11:30 AM', '12:00 PM', '12:30 PM', '1:00 PM', '1:30 PM'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(2026, 4, 15);
  }

  double get _currentPackagePrice => _packages[_selectedPackageIndex]['price'];
  double get _totalPrice => _currentPackagePrice * _guests;

  String _formatDateLong(DateTime date) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1].substring(0, 3)} ${date.day}, ${date.year}';
  }

  String get _paymentLabel {
    switch (_selectedPaymentMethod) {
      case 'credit_card': return 'Credit or debit card';
      case 'paypal': return 'PayPal';
      case 'google_pay': return 'Google Pay';
      case 'stripe': return 'Stripe';
      default: return 'Google Pay';
    }
  }

  IconData get _paymentIcon {
    switch (_selectedPaymentMethod) {
      case 'credit_card': return Icons.credit_card;
      case 'paypal': return Icons.account_balance_wallet;
      case 'google_pay': return Icons.g_mobiledata;
      case 'stripe': return Icons.payment;
      default: return Icons.g_mobiledata;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC), // Ultra-clean background
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            if (_currentStep == 0) _buildProgressBarHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _buildCurrentStep(),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: _currentStep > 0
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildCircularButton(
                icon: Icons.chevron_left,
                onPressed: () => setState(() => _currentStep--),
              ),
            )
          : const SizedBox(),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildCircularButton(
            icon: Icons.close,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
      title: Text(
        _currentStep == 0 ? '' : (_currentStep == 1 ? 'Review reservation' : (_currentStep == 2 ? 'Payment method' : 'Confirm and pay')),
        style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -0.3),
      ),
      centerTitle: true,
    );
  }

  Widget _buildCircularButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black, size: 20),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildProgressBarHeader() {
    return Container(
      height: 4,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: List.generate(4, (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: index <= _currentStep ? Colors.black : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildScheduleStep();
      case 1: return _buildReviewStep();
      case 2: return _buildPaymentStep();
      case 3: return _buildConfirmStep();
      default: return const SizedBox();
    }
  }

  // ═══════════════════════════════════════════════════════════
  // STEP 0: SCHEDULE
  // ═══════════════════════════════════════════════════════════
  Widget _buildScheduleStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text('Schedule your photo shoot', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('A member of ${widget.listing.hostName}\'s team with different qualifications may host your service.', 
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15, height: 1.4)),
          
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_guests guest${_guests > 1 ? 's' : ''}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  _buildCounterButton(Icons.remove, () => setState(() => _guests = _guests > 1 ? _guests - 1 : 1)),
                  const SizedBox(width: 16),
                  Text('$_guests', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  _buildCounterButton(Icons.add, () => setState(() => _guests++)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('April 2026', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Icon(Icons.calendar_today_outlined, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          _buildCalendarStrip(),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          ...List.generate(_packages.length, (index) => _buildPackageSelection(index)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
        child: Icon(icon, size: 20, color: Colors.grey.shade700),
      ),
    );
  }

  Widget _buildCalendarStrip() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(7, (index) {
          final dayNum = 12 + index;
          final isSelected = _selectedDate.day == dayNum;
          final dayName = ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index];
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = DateTime(2026, 4, dayNum)),
            child: Container(
              width: 45,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Column(
                children: [
                  Text(dayName, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade500, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text('$dayNum', style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPackageSelection(int index) {
    final pkg = _packages[index];
    final isPkgSelected = _selectedPackageIndex == index;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(pkg['image'], width: 60, height: 60, fit: BoxFit.cover)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pkg['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('\$${pkg['price'].toInt()} / guest · ${pkg['duration']}', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: (pkg['timeSlots'] as List<String>).map((time) {
              final isTimeSelected = isPkgSelected && _selectedTime == time;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedPackageIndex = index;
                  _selectedTime = time;
                }),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isTimeSelected ? Colors.black : Colors.white,
                    border: Border.all(color: isTimeSelected ? Colors.black : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(time, style: TextStyle(color: isTimeSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w500)),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // STEP 1: REVIEW
  // ═══════════════════════════════════════════════════════════
  Widget _buildReviewStep() {
    final pkg = _packages[_selectedPackageIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(pkg['image'], width: 80, height: 80, fit: BoxFit.cover)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pkg['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(widget.listing.description.split('.').first, style: TextStyle(color: Colors.grey.shade600, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Row(children: [const Icon(Icons.star, size: 14), const SizedBox(width: 4), Text('${widget.listing.rating} (${widget.listing.reviewsCount})', style: const TextStyle(fontSize: 12))]),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                _buildInfoRow('Date', '${_formatDateLong(_selectedDate)}\n$_selectedTime – ${_calculateEndTime(_selectedTime, pkg['duration'])}'),
                const Divider(height: 32),
                _buildInfoRow('Guests', '$_guests guest${_guests > 1 ? 's' : ''}', onAction: () => setState(() => _currentStep = 0)),
                const Divider(height: 32),
                _buildInfoRow('Location', widget.listing.fullAddress),
                const Divider(height: 32),
                _buildInfoRow('Total price', '\$${_totalPrice.toStringAsFixed(2)} USD', onAction: () {}),
                const SizedBox(height: 16),
                const Text('This reservation is non-refundable.', style: TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _calculateEndTime(String startTime, String duration) {
    // Simple mock calculation
    if (duration.contains('30 mins')) return startTime.replaceAll('30 AM', '00 PM').replaceAll('00 PM', '30 PM');
    if (duration.contains('1 hr')) return startTime.replaceAll('30 AM', '30 PM').replaceAll('30 PM', '30 AM?'); // Just a mockup
    return startTime;
  }

  Widget _buildInfoRow(String label, String value, {VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: Colors.grey.shade700, fontSize: 15, height: 1.4)),
          ]),
        ),
        if (onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: Colors.grey.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(label == 'Total price' ? 'Details' : 'Change', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // STEP 2: PAYMENT
  // ═══════════════════════════════════════════════════════════
  Widget _buildPaymentStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
            child: Column(
              children: [
                _buildPaymentOption('credit_card', 'Credit or debit card', Row(children: [const Icon(Icons.credit_card, size: 20), const SizedBox(width: 8), ...['VISA', 'MC', 'AMEX'].map((e) => Text('$e ', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))] )),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildPaymentOption('paypal', 'PayPal', const Icon(Icons.account_balance_wallet, size: 20, color: Color(0xFF003087))),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildPaymentOption('google_pay', 'Google Pay', const Icon(Icons.g_mobiledata, size: 28)),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildPaymentOption('stripe', 'Stripe', Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF635BFF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'S',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String id, String title, Widget leading) {
    final isSelected = _selectedPaymentMethod == id;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade400, width: isSelected ? 7 : 2))),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // STEP 3: CONFIRM
  // ═══════════════════════════════════════════════════════════
  Widget _buildConfirmStep() {
    final pkg = _packages[_selectedPackageIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(pkg['image'], width: 80, height: 80, fit: BoxFit.cover)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pkg['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(widget.listing.description.split('.').first, style: TextStyle(color: Colors.grey.shade600, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Row(children: [const Icon(Icons.star, size: 14), const SizedBox(width: 4), Text('${widget.listing.rating} (${widget.listing.reviewsCount})', style: const TextStyle(fontSize: 12))]),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                _buildInfoRow('Date', '${_formatDateLong(_selectedDate)}\n$_selectedTime – ${_calculateEndTime(_selectedTime, pkg['duration'])}'),
                const Divider(height: 32),
                _buildInfoRow('Guests', '$_guests guest${_guests > 1 ? 's' : ''}', onAction: () => setState(() => _currentStep = 0)),
                const Divider(height: 32),
                _buildInfoRow('Location', widget.listing.fullAddress),
                const Divider(height: 32),
                _buildInfoRow('Total price', '\$${_totalPrice.toStringAsFixed(2)} USD', onAction: () {}),
                const SizedBox(height: 16),
                const Text('This reservation is non-refundable.', style: TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildActionButton('Payment method', Row(children: [Icon(_paymentIcon, size: 24), const SizedBox(width: 8), Text(_paymentLabel, style: const TextStyle(color: Colors.grey))]), () => setState(() => _currentStep = 2)),
          const SizedBox(height: 20),
          const Text('Coupons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildActionButton('Enter a coupon', const SizedBox(), () {}),
          const SizedBox(height: 24),
          const Text('Price details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('\$${pkg['price'].toStringAsFixed(2)} x $_guests guest${_guests > 1 ? 's' : ''}', style: const TextStyle(fontSize: 16)), Text('\$${_totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16))]),
          const Divider(height: 32),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total USD', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)), Text('\$${_totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Widget rightSide, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), if (label == 'Payment method') rightSide]),
            const Icon(Icons.chevron_right, color: Colors.black87),
          ],
        ),
      ),
    );
  }

  // ─── BOTTOM BAR ────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep == 0) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\$${_totalPrice.toInt()} for $_guests guest${_guests > 1 ? 's' : ''}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  ],
                ),
              ],
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE61E4D), Color(0xFFD70466)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE61E4D).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _currentStep == 3 ? _processPayment : () => setState(() => _currentStep++),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: Text(
                      _currentStep == 3 
                          ? (_selectedPaymentMethod == 'google_pay' ? 'Pay with GPay' : 'Confirm and pay') 
                          : 'Next step', 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_currentStep == 3) ...[
            const SizedBox(height: 12),
            const Text('By selecting the button, I agree to the booking terms and release and waiver. View Privacy Policy.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFFE61E4D))),
    );

    try {
      final intentData = await _paymentService.createPaymentIntent(
        amount: _totalPrice,
        propertyId: int.tryParse(widget.listing.id) ?? 0, // Using listing ID as propertyId for simplicity
        checkIn: _selectedDate.toIso8601String(),
        // Services are usually short-lived, so check-out is just a few hours later
        checkOut: _selectedDate.add(const Duration(hours: 2)).toIso8601String(),
        guests: _guests,
      );

      if (intentData == null) throw Exception('Failed to create payment intent');

      final booking = await _paymentService.confirmBooking(
        paymentIntentId: intentData['paymentIntentId']!,
        propertyId: int.tryParse(widget.listing.id) ?? 0,
        checkIn: _selectedDate.toIso8601String(),
        checkOut: _selectedDate.add(const Duration(hours: 2)).toIso8601String(),
        guests: _guests,
        totalPrice: _totalPrice,
        serviceFee: _totalPrice * 0.1,
        cleaningFee: 0,
        propertyPrice: _totalPrice * 0.9,
        nights: 1, // Services are counted as 1 day session
        messageToHost: 'Booked service: ${_packages[_selectedPackageIndex]['title']}',
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading

      if (booking != null) {
        _showSuccessDialog();
      } else {
        _showErrorSnackBar('Booking confirmation failed');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading
      _showErrorSnackBar('Payment failed: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text('Payment Successful!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Your service host has been notified.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close success dialog
                  Navigator.pop(context); // Close reservation screen
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
