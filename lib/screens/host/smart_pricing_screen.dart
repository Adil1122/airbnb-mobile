import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/smart_pricing_service.dart';

class SmartPricingScreen extends StatefulWidget {
  final int propertyId;
  final double currentPrice;

  const SmartPricingScreen({
    super.key,
    required this.propertyId,
    required this.currentPrice,
  });

  @override
  State<SmartPricingScreen> createState() => _SmartPricingScreenState();
}

class _SmartPricingScreenState extends State<SmartPricingScreen> {
  Map<String, dynamic>? _suggestion;
  Map<String, dynamic> _calendar = {};
  bool _loading = false;
  DateTime _checkIn = DateTime.now().add(const Duration(days: 7));
  DateTime _checkOut = DateTime.now().add(const Duration(days: 9));
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _loadSuggestion();
    _loadCalendar();
  }

  Future<void> _loadSuggestion() async {
    setState(() => _loading = true);
    final fmt = DateFormat('yyyy-MM-dd');
    final result = await SmartPricingService.getPriceSuggestion(
      widget.propertyId,
      fmt.format(_checkIn),
      fmt.format(_checkOut),
    );
    setState(() { _suggestion = result; _loading = false; });
  }

  Future<void> _loadCalendar() async {
    final result = await SmartPricingService.getCalendarPricing(
      widget.propertyId, _year, _month,
    );
    setState(() => _calendar = result);
  }

  Color _priceColor(double suggested) {
    final ratio = suggested / widget.currentPrice;
    if (ratio > 1.2) return Colors.red.shade400;
    if (ratio > 1.0) return Colors.orange.shade400;
    return Colors.green.shade500;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Pricing'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_suggestion != null) ...[
                  _SuggestionCard(suggestion: _suggestion!, currentPrice: widget.currentPrice),
                  const SizedBox(height: 24),
                ],
                Text('Price Calendar — ${DateFormat('MMMM yyyy').format(DateTime(_year, _month))}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _CalendarGrid(calendar: _calendar, currentPrice: widget.currentPrice),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          _month--;
                          if (_month < 1) { _month = 12; _year--; }
                        });
                        _loadCalendar();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          _month++;
                          if (_month > 12) { _month = 1; _year++; }
                        });
                        _loadCalendar();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _PricingLegend(),
              ],
            ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final Map<String, dynamic> suggestion;
  final double currentPrice;

  const _SuggestionCard({required this.suggestion, required this.currentPrice});

  @override
  Widget build(BuildContext context) {
    final suggested = (suggestion['suggestedPrice'] as num).toDouble();
    final breakdown = suggestion['breakdown'] as Map<String, dynamic>? ?? {};

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Suggested Price', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            Text('\$${suggested.toStringAsFixed(0)}/night',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFF5A5F))),
            const SizedBox(height: 8),
            Text('Your current price: \$${currentPrice.toStringAsFixed(0)}/night',
                style: const TextStyle(color: Colors.grey)),
            const Divider(height: 24),
            _Row('Season', breakdown['season']?.toString() ?? '—'),
            _Row('Weekend premium', breakdown['isWeekend'] == true ? 'Yes (+25%)' : 'No'),
            _Row('Demand level', breakdown['demandLevel']?.toString() ?? '—'),
            _Row('Price range', '\$${breakdown['minSuggested']} – \$${breakdown['maxSuggested']}'),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _CalendarGrid extends StatelessWidget {
  final Map<String, dynamic> calendar;
  final double currentPrice;
  const _CalendarGrid({required this.calendar, required this.currentPrice});

  @override
  Widget build(BuildContext context) {
    if (calendar.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: calendar.entries.map((e) {
        final price = (e.value as num).toDouble();
        final day = e.key.split('-').last;
        final isHigh = price > currentPrice * 1.1;
        final isLow = price < currentPrice * 0.95;
        final bg = isHigh ? Colors.red.shade50 : isLow ? Colors.green.shade50 : Colors.grey.shade100;
        final fg = isHigh ? Colors.red.shade700 : isLow ? Colors.green.shade700 : Colors.black87;

        return Container(
          width: 46,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Text(day, style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.bold)),
              Text('\$${price.toStringAsFixed(0)}', style: TextStyle(fontSize: 10, color: fg)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _PricingLegend extends StatelessWidget {
  const _PricingLegend();
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _Dot(Colors.red, 'High demand'),
          SizedBox(width: 16),
          _Dot(Colors.grey, 'Normal'),
          SizedBox(width: 16),
          _Dot(Colors.green, 'Low demand'),
        ],
      );
}

class _Dot extends StatelessWidget {
  final Color color;
  final String label;
  const _Dot(this.color, this.label);
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      );
}
