import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iptv/data/constants.dart';
import 'package:iptv/database/xtream/category.dart';
import 'package:iptv/extension/theme.dart';
import 'package:iptv/widgets/category_tab.dart';
import 'package:iptv/widgets/gap.dart';
import 'package:iptv/widgets/search.dart';
import 'package:provider/provider.dart';
import 'package:iptv/controllers/category_tab.dart';

class MediaTabBase extends StatelessWidget {
  final List<CategoryModel> categories;
  final Widget Function(BuildContext, List<dynamic>) listBuilder;
  final List<dynamic> streams;
  final String Function(dynamic) getCategoryId;
  final String Function(CategoryTabProvider) getSelectedCategoryId;
  final void Function(CategoryTabProvider, String) setSelectedCategory;
  final void Function()? onSearchTap;
  final String? searchTag;

  const MediaTabBase({
    super.key,
    required this.categories,
    required this.listBuilder,
    required this.streams,
    required this.getCategoryId,
    required this.getSelectedCategoryId,
    required this.setSelectedCategory,
    this.onSearchTap,
    this.searchTag,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.padding, vertical: Constants.padding / 2),
          color: context.appColorScheme.surface,
          child: Column(
            children: [
              Hero(
                  tag: '$searchTag',
                  child: SearchTextfield(
                    readOnly: true,
                    onTap: onSearchTap,
                  )),
              VerticalGap(height: 10.h),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final categoryId = categories[index].categoryId;
                    return Consumer<CategoryTabProvider>(
                      builder: (context, categoryTabProvider, child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (getSelectedCategoryId(categoryTabProvider)
                              .isEmpty) {
                            setSelectedCategory(categoryTabProvider,
                                categories[index].categoryId ?? "");
                          }
                        });

                        final isSelected = categoryId ==
                            getSelectedCategoryId(categoryTabProvider);

                        return CategoryTab(
                          key: ValueKey(categoryId),
                          onTap: () => setSelectedCategory(
                              categoryTabProvider, categoryId ?? ""),
                          categoryId: categoryId,
                          isSelected: isSelected,
                          categories: categories,
                          index: index,
                        );
                      },
                    );
                  },
                ),
              ),
              const Divider(),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constants.padding, vertical: Constants.padding / 3),
            child: Consumer<CategoryTabProvider>(
              builder: (context, categoryTabProvider, child) {
                final filteredStreams = streams
                    .where((stream) =>
                        getCategoryId(stream) ==
                        getSelectedCategoryId(categoryTabProvider))
                    .toList();

                if (filteredStreams.isEmpty) {
                  return const Center(child: Text('No channels available'));
                }

                return listBuilder(context, filteredStreams);
              },
            ),
          ),
        ),
      ],
    );
  }
}
