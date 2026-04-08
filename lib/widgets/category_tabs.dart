import 'package:flutter/material.dart';

class CategoryItem {
  final String label;
  final IconData icon;
  final bool isNew;

  CategoryItem({required this.label, required this.icon, this.isNew = false});
}

class CategoryTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CategoryTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static final List<CategoryItem> _categories = [
    CategoryItem(label: 'Homes', icon: Icons.home),
    CategoryItem(label: 'Experiences', icon: Icons.celebration, isNew: true),
    CategoryItem(label: 'Services', icon: Icons.room_service, isNew: true),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final category = _categories[index];

          return GestureDetector(
            onTap: () {
              onTabSelected(index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        category.icon,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                        size: 28,
                      ),
                      if (category.isNew)
                        Positioned(
                          right: -32,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C4164),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2,
                    width: 40,
                    color: isSelected ? Colors.black : Colors.transparent,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
