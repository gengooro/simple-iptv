import 'package:flutter/material.dart';
import 'package:iptv/database/xtream/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTab extends StatelessWidget {
  final String? categoryId;
  final bool isSelected;
  final List<CategoryModel> categories;
  final int index;
  final Function() onTap;

  const CategoryTab({
    super.key,
    required this.categoryId,
    required this.isSelected,
    required this.categories,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: isSelected
                  ? Theme.of(context).colorScheme.surfaceContainer
                  : Colors.transparent),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
            child: Text(categories[index].categoryName ?? ""),
          ),
        ),
      ),
    );
  }
}
