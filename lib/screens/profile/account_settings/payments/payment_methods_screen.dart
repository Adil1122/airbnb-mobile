import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment methods',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Add a payment method using our secure payment system, then start planning your next trip.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Add Payment Method Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF222222),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Add payment method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Safe Payment Info Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.credit_card_outlined,
                    color: Color(0xFFFF385C), // Airbnb Pink
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Make all payments through Airbnb',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: 'Always pay and communicate through Airbnb to ensure you\'re protected under our '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        TextSpan(text: ', '),
                        TextSpan(
                          text: 'Payments Terms of Service',
                          style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        TextSpan(text: ', cancellation, and other safeguards.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      'Learn more',
                      style: TextStyle(
                        fontSize: 16,
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
    );
  }
}
