import 'package:flutter/material.dart';

class TripsScreen extends StatelessWidget {
  final VoidCallback? onGetStarted;

  const TripsScreen({super.key, this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 16.0),
          child: Text(
            'Trips',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 48),
            // Custom Illustration Section
            _buildTimelineIllustration(),
            
            const SizedBox(height: 64),
            
            // Text Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                children: [
                   Text(
                    'Build the perfect trip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Explore homes, experiences, and services. When you book, your reservations will show up here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // CTA Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: SizedBox(
                width: 200,
                height: 56,
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31C5F), // Airbnb Pink/Red
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Get started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineIllustration() {
    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Vertical Dashed Line
          Positioned(
            left: 60,
            top: 20,
            bottom: 20,
            child: CustomPaint(
              size: const Size(2, double.infinity),
              painter: DashedLinePainter(),
            ),
          ),
          
          // Timeline Cards Stack
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIllustrationCard(
                imageUrl: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=100&q=80',
                nodeTop: true,
                offset: -10,
              ),
              const SizedBox(height: 12),
              _buildIllustrationCard(
                imageUrl: 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=100&q=80',
                nodeActive: true,
                offset: 10,
              ),
              const SizedBox(height: 12),
              _buildIllustrationCard(
                imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=100&q=80',
                nodeBottom: true,
                offset: -5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIllustrationCard({
    required String imageUrl,
    bool nodeTop = false,
    bool nodeActive = false,
    bool nodeBottom = false,
    double offset = 0,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Timeline Node
        Container(
          width: 60,
          alignment: Alignment.center,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: nodeActive ? Colors.grey.shade600 : Colors.grey.shade300,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
        
        // The Floating Card
        Transform.translate(
          offset: Offset(offset, 0),
          child: Container(
            width: 240,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 8,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 2;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
