import 'package:flutter/material.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // Slightly off-white background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: const Text(
                'Earnings',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Performance section
                  _buildSectionCard(
                    child: Column(
                      children: [
                        const Text(
                          'Performance',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '\$0.00',
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Total for April (USD)',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildChartBar(100),
                            const SizedBox(width: 12),
                            _buildChartBar(70),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Your overview will show up here once you get your first booking.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Upcoming Section
                  const Text(
                    'Upcoming',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionCard(
                    child: Column(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 48, color: Color(0xFFDDDDDD)),
                        const SizedBox(height: 24),
                        const Text(
                          'No scheduled payouts',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Upcoming payouts will be shown here after your first booking.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Paid Section
                  const Text(
                    'Paid',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionCard(
                    child: Column(
                      children: [
                        const Icon(Icons.account_balance_outlined, size: 48, color: Color(0xFFDDDDDD)),
                        const SizedBox(height: 24),
                        const Text(
                          'No sent payouts',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {},
                          child: const Text(
                            'Learn how payouts work',
                            style: TextStyle(
                              fontSize: 14, 
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildChartBar(double height) {
    return Container(
      width: 60,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
