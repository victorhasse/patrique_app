import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.surface,
      highlightColor: const Color(0xFF2C2D32),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Header shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(width: 180, height: 24),
                    const SizedBox(height: 8),
                    _ShimmerBox(width: 140, height: 16),
                  ],
                ),
                _ShimmerBox(width: 48, height: 48, radius: 12),
              ],
            ),

            const SizedBox(height: 28),

            // Card streak shimmer
            _ShimmerBox(
              width: double.infinity,
              height: 90,
              radius: 16,
            ),

            const SizedBox(height: 28),

            // Título shimmer
            _ShimmerBox(width: 120, height: 20),
            const SizedBox(height: 12),

            // Dias da semana shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                7,
                (_) => _ShimmerBox(width: 36, height: 36, radius: 18),
              ),
            ),

            const SizedBox(height: 28),

            // Título shimmer
            _ShimmerBox(width: 140, height: 20),
            const SizedBox(height: 12),

            // Cards treino shimmer
            _ShimmerBox(width: double.infinity, height: 76, radius: 16),
            const SizedBox(height: 16),
            _ShimmerBox(width: double.infinity, height: 76, radius: 16),
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

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}