import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends HiveObject {
  @HiveField(0)
  String? categoryId;
  @HiveField(1)
  String? categoryName;
  @HiveField(2)
  int? parentId;
  @HiveField(3)
  String? type;

  CategoryModel({this.categoryId, this.categoryName, this.parentId, this.type});

  CategoryModel.fromJson(Map<String, dynamic> json, String this.type)
      : categoryId = json['category_id'],
        categoryName = json['category_name'],
        parentId = json['parent_id'];

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'parent_id': parentId,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'CategoryModel{categoryId: $categoryId, categoryName: $categoryName, parentId: $parentId, type: $type}';
  }
}
