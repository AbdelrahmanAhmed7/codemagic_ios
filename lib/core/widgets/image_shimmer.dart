import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mediconsult/core/theming/app_colors.dart';

/// Shimmer effect for image loading placeholder
class ImageShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxShape shape;

  const ImageShimmer({
    super.key,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
  });

  const ImageShimmer.circle({
    super.key,
    this.width,
    this.height,
  }) : shape = BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyClr.withValues(alpha: 0.3),
      highlightColor: AppColors.greyClr.withValues(alpha: 0.1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.greyClr.withValues(alpha: 0.3),
          shape: shape,
        ),
      ),
    );
  }
}
