import 'package:flutter/material.dart';
import '../../models/listing.dart';
import '../../services/host_service.dart';
import '../../services/property_service.dart';

class CancellationPoliciesScreen extends StatefulWidget {
  final Listing listing;
  const CancellationPoliciesScreen({super.key, required this.listing});

  @override
  State<CancellationPoliciesScreen> createState() => _CancellationPoliciesScreenState();
}

class _CancellationPoliciesScreenState extends State<CancellationPoliciesScreen> {
  late String _shortTermPolicy;
  late String _longTermPolicy;
  bool _nonRefundableEnabled = false;
  bool _showFeedback = false;
  bool _isSaving = false;
  final HostService _hostService = HostService();

  @override
  void initState() {
    super.initState();
    _shortTermPolicy = widget.listing.cancellationPolicy;
    _longTermPolicy = 'Firm Long Term'; // Default or from model if added
  }

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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cancellation policies',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 16, color: Color(0xFF717171), height: 1.4),
                  children: [
                    TextSpan(text: 'Review the full policies in the '),
                    TextSpan(
                      text: 'Help Center',
                      style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Short-term stays section
              const Text(
                'Short-term stays',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Applies to stays under 28 nights. All standard stay policies include a 24-hour free cancellation period.',
                style: TextStyle(fontSize: 14, color: Color(0xFF717171), height: 1.4),
              ),
              const SizedBox(height: 24),
              _buildPolicyCard(
                label: 'Your policy',
                value: _shortTermPolicy,
                onTap: () => _showShortTermSheet(),
              ),
              const SizedBox(height: 16),
              _buildToggleCard('Non-refundable option'),
              
              const SizedBox(height: 40),

              // Long-term stays section
              const Text(
                'Long-term stays',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Applies to stays 28 nights or longer.',
                style: TextStyle(fontSize: 14, color: Color(0xFF717171), height: 1.4),
              ),
              const SizedBox(height: 24),
              _buildPolicyCard(
                label: 'Your policy',
                value: _longTermPolicy,
                onTap: () => _showLongTermSheet(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard({required String label, required String value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _nonRefundableEnabled = !_nonRefundableEnabled;
                    _showFeedback = true;
                  });
                  // Hide feedback after 3 seconds
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) {
                      setState(() => _showFeedback = false);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 50,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: _nonRefundableEnabled ? Colors.black : Colors.grey.shade400,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: _nonRefundableEnabled ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: _nonRefundableEnabled 
                        ? const Icon(Icons.check, size: 16, color: Colors.black)
                        : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Guests can pay 10% less in exchange for you keeping your full payout if they cancel.',
            style: TextStyle(fontSize: 14, color: Color(0xFF717171), height: 1.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'Learn more',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              color: Colors.black,
            ),
          ),
          if (_showFeedback) ...[
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  'Settings updated',
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showShortTermSheet() {
    _showPolicySheet(
      title: 'Short-term stays',
      options: [
        _PolicyOptionData(
          title: 'Flexible',
          details: ['Full refund at least 1 day before check-in', 'Partial refund within 1 day of check-in'],
        ),
        _PolicyOptionData(
          title: 'Moderate',
          details: ['Full refund at least 5 days before check-in', 'Partial refund within 5 days of check-in'],
        ),
        _PolicyOptionData(
          title: 'Limited',
          details: ['Full refund at least 14 days before check-in', 'Partial refund 7-14 days before check-in'],
        ),
        _PolicyOptionData(
          title: 'Firm',
          details: ['Full refund at least 30 days before check-in', 'Partial refund 7-30 days before check-in'],
        ),
      ],
      currentValue: _shortTermPolicy,
      onSave: (val) => setState(() => _shortTermPolicy = val),
    );
  }

  void _showLongTermSheet() {
    _showPolicySheet(
      title: 'Long-term stays',
      options: [
        _PolicyOptionData(
          title: 'Firm Long Term',
          details: [
            'Full refund up to 30 days before check-in',
            'After that, the first 30 days of the stay are non-refundable',
          ],
        ),
        _PolicyOptionData(
          title: 'Strict Long Term',
          details: [
            'Full refund if canceled within 48 hours of booking and at least 28 days before check-in',
            'After that, the first 30 days of the stay are non-refundable',
          ],
        ),
      ],
      currentValue: _longTermPolicy,
      onSave: (val) => setState(() => _longTermPolicy = val),
    );
  }

  void _showPolicySheet({
    required String title,
    required List<_PolicyOptionData> options,
    required String currentValue,
    required Function(String) onSave,
  }) {
    String tempSelection = currentValue;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  
                  // Content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: options.map((opt) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildPolicyOption(
                          data: opt,
                          isSelected: tempSelection == opt.title,
                          onTap: () => setSheetState(() => tempSelection = opt.title),
                        ),
                      )).toList(),
                    ),
                  ),
                  
                  // Footer
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _isSaving ? null : () async {
                            setSheetState(() => _isSaving = true);
                            try {
                              await _hostService.updatePolicies(widget.listing.id.toString(), {
                                'cancellationPolicy': tempSelection,
                              });
                              
                              if (mounted) {
                                setState(() {
                                  _shortTermPolicy = tempSelection;
                                });
                                PropertyService.triggerRefresh();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Cancellation policy updated successfully')),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                                );
                              }
                            } finally {
                              if (mounted) setSheetState(() => _isSaving = false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF222222),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _isSaving 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildPolicyOption({
    required _PolicyOptionData data,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (!isSelected) Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            ...data.details.map((detail) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 14, color: Color(0xFF717171))),
                  Expanded(
                    child: Text(
                      detail,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF717171), height: 1.4),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _PolicyOptionData {
  final String title;
  final List<String> details;
  _PolicyOptionData({required this.title, required this.details});
}
