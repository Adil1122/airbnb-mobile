import 'package:flutter/material.dart';
import 'payment_methods_screen.dart';
import 'your_payments_screen.dart';
import 'credits_coupons_screen.dart';
import 'payout_methods_screen.dart';
import 'earnings_screen.dart';
import 'service_fee_settings_screen.dart';

class PaymentsPayoutsScreen extends StatelessWidget {
  const PaymentsPayoutsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                '\$-USD',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'Payments & payouts',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            
            _buildPaymentSection(
              'Traveling',
              [
                _buildPaymentRow(
                  Icons.account_balance_wallet_outlined, 
                  'Payment methods',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                    );
                  },
                ),
                _buildPaymentRow(
                  Icons.list_alt_outlined, 
                  'Your payments',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const YourPaymentsScreen()),
                    );
                  },
                ),
                _buildPaymentRow(
                  Icons.confirmation_num_outlined, 
                  'Credits & coupons',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreditsCouponsScreen()),
                    );
                  },
                ),
              ],
            ),
            
            const Divider(height: 64, thickness: 1, color: Color(0xFFF0F0F0)),
            
            _buildPaymentSection(
              'Hosting',
              [
                _buildPaymentRow(
                  Icons.payments_outlined, 
                  'Payout methods',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PayoutMethodsScreen()),
                    );
                  },
                ),
                _buildPaymentRow(
                  Icons.receipt_long_outlined, 
                  'Transaction history',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EarningsScreen()),
                    );
                  },
                ),
                _buildPaymentRow(
                  Icons.receipt_outlined, 
                  'Service fee: Split-fee',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ServiceFeeSettingsScreen()),
                    );
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ...items,
      ],
    );
  }

  Widget _buildPaymentRow(IconData icon, String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: onTap ?? () {},
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 28),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black, size: 24),
          ],
        ),
      ),
    );
  }
}
