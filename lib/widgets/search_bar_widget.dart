import 'package:flutter/material.dart';
import '../screens/search_screen.dart';
import '../models/listing.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(List<Listing>, int)? onSearchResults;
  final int initialCategoryIndex;
  
  const SearchBarWidget({super.key, this.onSearchResults, this.initialCategoryIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: GestureDetector(
        onTap: () async {
          final data = await Navigator.push<Map<String, dynamic>>(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(initialCategoryIndex: initialCategoryIndex),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
          
          if (data != null && onSearchResults != null) {
            onSearchResults!(
              data['results'] as List<Listing>,
              data['categoryIndex'] as int,
            );
          }
        },
        child: Hero(
          tag: 'search_bar',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.grey.shade200, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.black, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Where to?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 1),
                        Row(
                          children: [
                            Text(
                              'Anywhere',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text('•', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ),
                            Text(
                              'Any week',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text('•', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ),
                            Text(
                              'Add guests',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.tune_rounded, size: 18, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
