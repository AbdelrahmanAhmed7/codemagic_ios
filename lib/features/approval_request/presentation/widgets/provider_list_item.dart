import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/providers/data/providers_models.dart';

/// Provider list item widget with performance optimizations
class ProviderListItem extends StatefulWidget {
  final ProviderItem item;
  final VoidCallback onTap;

  const ProviderListItem({super.key, required this.item, required this.onTap});

  @override
  State<ProviderListItem> createState() => _ProviderListItemState();
}

class _ProviderListItemState extends State<ProviderListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RepaintBoundary(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.lightGreyClr,
          child: _buildProviderLogo(),
        ),
        title: Text(
          widget.item.name,
          style: AppTextStyles.font14BlackMedium(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          widget.item.categoryName ?? '',
          style: AppTextStyles.font12GreyRegular(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: widget.onTap,
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      ),
    );
  }

  Widget _buildProviderLogo() {
    if (widget.item.logo != null && widget.item.logo!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: widget.item.logo!,
          fit: BoxFit.cover,
          width: 40.w,
          height: 40.w,
          placeholder: (context, url) => Container(
            width: 40.w,
            height: 40.w,
            color: AppColors.lightGreyClr,
            child: Center(
              child: SizedBox(
                width: 16.w,
                height: 16.w,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryClr,
                  ),
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => ClipOval(
            child: Image.asset(AppAssets.logo, width: 40.w, height: 40.w),
          ),
        ),
      );
    }
    return ClipOval(
      child: Image.asset(AppAssets.logo, width: 40.w, height: 40.w),
    );
  }
}
