import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/services/api_service.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../base/bottom_menu..dart';
import '../../base/custom_text.dart';
import 'search_applied_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<dynamic> categories = [];
  bool isLoading = true;
  String? error;
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _fetchCategories() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Get.find<ApiService>();
      final response = await apiService.get(
        '${ApiConstants.categoriesEvent}?page=$_page&limit=$_limit',
      );

      if (response['success'] == true) {
        final data = response['data'] ?? [];
        final meta = response['meta'] ?? {};
        
        setState(() {
          categories = data;
          _hasMore = meta['hasNext'] == true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
      _page++;
    });

    try {
      final apiService = Get.find<ApiService>();
      final response = await apiService.get(
        '${ApiConstants.categoriesEvent}?page=$_page&limit=$_limit',
      );

      if (response['success'] == true) {
        final data = response['data'] ?? [];
        final meta = response['meta'] ?? {};

        setState(() {
          categories.addAll(data);
          _hasMore = meta['hasNext'] == true;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _page--;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshCategories() async {
    setState(() {
      _page = 1;
      _hasMore = true;
      categories.clear();
    });
    await _fetchCategories();
  }

  void _navigateToSearchScreen(dynamic category) {
    Get.to(
      () => CategoriesSearchAppliedScreen(category: category),
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomMenu(1),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          text: 'Categories',
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            _searchBar(),
            SizedBox(height: 16.h),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading && categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && categories.isEmpty) {
      return Center(child: Text(error!, style: const TextStyle(color: Colors.red)));
    }

    if (categories.isEmpty) {
      return const Center(child: Text('No categories found'));
    }

    return RefreshIndicator(
      onRefresh: _refreshCategories,
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 8.0.w,
          mainAxisSpacing: 8.0.h,
        ),
        itemCount: categories.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == categories.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final category = categories[index];
          final name = category['name'] ?? 'Unknown';
          final imageUrl = category['imageUrl'];

          return GestureDetector(
            onTap: () => _navigateToSearchScreen(category),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  AppImages.logo,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              AppImages.logo,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.r),
                          bottomRight: Radius.circular(16.r),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        child: CustomText(
                          text: name,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder(String name) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: CustomText(
          text: name.isNotEmpty ? name[0].toUpperCase() : '?',
          fontsize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600] ?? Colors.grey,
        ),
      ),
    );
  }

  //============================> Search Bar Section <=================================
  _searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 271.w,
          child: CustomTextField(
            controller: _searchController,
            contenpaddingHorizontal: 12.w,
            contenpaddingVertical: 12.h,
            hintText: "Search Event",
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                Get.toNamed(AppRoutes.searchEventScreen,
                    arguments: {'searchTerm': value});
              }
            },
            sufixicons: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: GestureDetector(
                onTap: () {
                  if (_searchController.text.isNotEmpty) {
                    Get.toNamed(AppRoutes.searchEventScreen,
                        arguments: {'searchTerm': _searchController.text});
                  }
                },
                child: SvgPicture.asset(
                  AppIcons.search,
                  width: 24.w,
                  height: 24.h,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.categoriesFilterScreen);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.fillColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(width: 1.w, color: AppColors.primaryColor),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: SvgPicture.asset(
                AppIcons.filterIcon,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ),
        )
      ],
    );
  }
}
