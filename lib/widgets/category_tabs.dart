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
    CategoryItem(label: 'Homes', icon: Icons.home_outlined),
    CategoryItem(label: 'Experiences', icon: Icons.celebration_outlined, isNew: true),
    CategoryItem(label: 'Services', icon: Icons.room_service_outlined, isNew: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Opacity(
                        opacity: isSelected ? 1.0 : 0.5,
                        child: Icon(
                          category.icon,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      if (category.isNew)
                        Positioned(
                          right: -30,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE61E4D),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
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
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.black.withOpacity(0.5),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
