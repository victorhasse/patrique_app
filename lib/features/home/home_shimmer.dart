import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark
        ? const Color(0xFF1C1D21)
        : const Color(0xFFFFE0EE);
    final highlightColor = isDark
        ? const Color(0xFF2C2D32)
        : const Color(0xFFFFF0F5);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(width: 180, height: 24, isDark: isDark),
                    const SizedBox(height: 8),
                    _ShimmerBox(width: 140, height: 16, isDark: isDark),
                  ],
                ),
                _ShimmerBox(width: 48, height: 48, radius: 12, isDark: isDark),
              ],
            ),
            const SizedBox(height: 28),
            _ShimmerBox(width: double.infinity, height: 90, radius: 16, isDark: isDark),
            const SizedBox(height: 28),
            _ShimmerBox(width: 120, height: 20, isDark: isDark),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                7,
                (_) => _ShimmerBox(width: 36, height: 36, radius: 18, isDark: isDark),
              ),
            ),
            const SizedBox(height: 28),
            _ShimmerBox(width: 140, height: 20, isDark: isDark),
            const SizedBox(height: 12),
            _ShimmerBox(width: double.infinity, height: 76, radius: 16, isDark: isDark),
            const SizedBox(height: 16),
            _ShimmerBox(width: double.infinity, height: 76, radius: 16, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final bool isDark;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 8,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1C1D21)
            : const Color(0xFFFFE0EE),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}