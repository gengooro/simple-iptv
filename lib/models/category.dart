class Category {
  final String categoryId;
  final String categoryName;
  final int parentId;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.parentId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      parentId: json['parent_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'parent_id': parentId,
    };
  }

  @override
  String toString() {
    return 'Category{id: $categoryId, name: $categoryName, parentId: $parentId}';
  }
}
