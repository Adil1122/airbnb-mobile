import 'package:flutter/material.dart';
import 'identity_verification_screen.dart';

class FinishUpPublishScreen extends StatelessWidget {
  const FinishUpPublishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Finish up and publish',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Complete these final steps so you can start getting booked.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 48),
            
            _buildStatusItem(
              title: 'Verify your identity',
              subtitle: "We'll gather some information to help confirm you're you.",
              statusText: 'Required',
              statusColor: const Color(0xFFFF385C),
              showChevron: true,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IdentityVerificationScreen())),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Divider(height: 1),
            ),
            
            _buildStatusItem(
              title: 'Confirm your phone number',
              subtitle: "We'll call or text to confirm your number. Standard messaging rates apply.",
              statusText: 'Complete',
              statusColor: Colors.green,
              showChevron: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required String title,
    required String subtitle,
    required String statusText,
    required Color statusColor,
    required bool showChevron,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 14,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showChevron)
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Icon(Icons.chevron_right, color: Colors.black, size: 24),
          ),
      ],
    ),
   );
  }
}
