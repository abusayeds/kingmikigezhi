import 'package:event_sharing/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Shared shimmer wrapper.
class AppSkeleton extends StatelessWidget {
  final Widget child;
  const AppSkeleton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE6E9EC),
      highlightColor: const Color(0xFFF5F7F8),
      child: child,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }
}

/// Horizontal home “today” card skeleton.
class EventChipSkeleton extends StatelessWidget {
  const EventChipSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: Container(
        width: 140.w,
        margin: EdgeInsets.only(right: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(height: 100.h, width: 140.w, radius: 12),
            SizedBox(height: 8.h),
            SkeletonBox(height: 12.h, width: 110.w),
            SizedBox(height: 6.h),
            SkeletonBox(height: 10.h, width: 80.w),
          ],
        ),
      ),
    );
  }
}

/// Large upcoming card skeleton (home / upcoming).
class EventCardSkeleton extends StatelessWidget {
  const EventCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: Container(
        width: 320.w,
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.colorEDF2F4.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SkeletonBox(height: double.infinity, radius: 20)),
            SizedBox(height: 8.h),
            SkeletonBox(height: 14.h, width: 200.w),
            SizedBox(height: 6.h),
            SkeletonBox(height: 10.h, width: 160.w),
            SizedBox(height: 6.h),
            SkeletonBox(height: 10.h, width: 120.w),
          ],
        ),
      ),
    );
  }
}

/// List row skeleton (My Event / Applied / Search).
class EventListTileSkeleton extends StatelessWidget {
  const EventListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColors.colorC8D7DE.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 75.w, height: 75.h, radius: 10),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(height: 14.h, width: double.infinity),
                  SizedBox(height: 8.h),
                  SkeletonBox(height: 10.h, width: 140.w),
                  SizedBox(height: 6.h),
                  SkeletonBox(height: 10.h, width: 100.w),
                  SizedBox(height: 6.h),
                  SkeletonBox(height: 10.h, width: 120.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventListSkeleton extends StatelessWidget {
  final int itemCount;
  const EventListSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: (_, __) => const EventListTileSkeleton(),
    );
  }
}

/// Full event details page skeleton.
class EventDetailsSkeleton extends StatelessWidget {
  const EventDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(height: 180.h, width: double.infinity, radius: 16),
            SizedBox(height: 16.h),
            SkeletonBox(height: 20.h, width: 220.w),
            SizedBox(height: 10.h),
            SkeletonBox(height: 12.h, width: 160.w),
            SizedBox(height: 16.h),
            SkeletonBox(height: 12.h, width: double.infinity),
            SizedBox(height: 8.h),
            SkeletonBox(height: 12.h, width: double.infinity),
            SizedBox(height: 8.h),
            SkeletonBox(height: 12.h, width: 200.w),
            SizedBox(height: 24.h),
            SkeletonBox(height: 48.h, width: double.infinity, radius: 8),
            SizedBox(height: 12.h),
            SkeletonBox(height: 48.h, width: double.infinity, radius: 8),
            SizedBox(height: 24.h),
            SkeletonBox(height: 14.h, width: 140.w),
            SizedBox(height: 10.h),
            Row(
              children: List.generate(
                4,
                (_) => Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: SkeletonBox(width: 50.w, height: 50.w, radius: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationListSkeleton extends StatelessWidget {
  final int itemCount;
  const NotificationListSkeleton({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: SkeletonBox(height: 72.h, width: double.infinity, radius: 20),
        ),
      ),
    );
  }
}

class ConnectionListSkeleton extends StatelessWidget {
  final int itemCount;
  const ConnectionListSkeleton({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              SkeletonBox(width: 56.w, height: 56.w, radius: 28),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(height: 14.h, width: 140.w),
                    SizedBox(height: 6.h),
                    SkeletonBox(height: 10.h, width: 100.w),
                  ],
                ),
              ),
              SkeletonBox(width: 24.w, height: 24.w, radius: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            SkeletonBox(width: 90.w, height: 90.w, radius: 45),
            SizedBox(height: 12.h),
            SkeletonBox(height: 16.h, width: 140.w),
            SizedBox(height: 8.h),
            SkeletonBox(height: 12.h, width: 100.w),
            SizedBox(height: 24.h),
            ...List.generate(
              6,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: SkeletonBox(height: 52.h, width: double.infinity, radius: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact shimmer row shown at the bottom while paginating a list.
class ListLoadMoreSkeleton extends StatelessWidget {
  const ListLoadMoreSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: const EventListTileSkeleton(),
    );
  }
}

/// Full-page shimmer for Settings / About / Terms / Privacy style screens.
class SimplePageSkeleton extends StatelessWidget {
  final int rows;
  const SimplePageSkeleton({super.key, this.rows = 8});

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(height: 18.h, width: 160.w),
            SizedBox(height: 16.h),
            ...List.generate(
              rows,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: SkeletonBox(
                  height: 48.h,
                  width: double.infinity,
                  radius: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeFeedSkeleton extends StatelessWidget {
  const HomeFeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 160.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (_, __) => const EventChipSkeleton(),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 275.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (_, __) => const EventCardSkeleton(),
          ),
        ),
      ],
    );
  }
}
