import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/providers/data/providers_models.dart';

/// Provider list item widget with performance optimizations
class ProviderListItem extends StatefulWidget {
  final ProviderItem item;
  final VoidCallback onTap;

  const ProviderListItem({
    super.key,
    required this.item,
    required this.onTap,
  });

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
          foregroundImage: AssetImage(
            _assetForProvider(widget.item.name),
          ),
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

  String _assetForProvider(String name) {
    final normalized = name.toLowerCase();
    if (normalized.contains('shifa')) return AppAssets.shifa;
    if (normalized.contains('ezaby') || normalized.contains('elezaby')) {
      return AppAssets.elezaby;
    }
    if (normalized.contains('alfa')) return AppAssets.alfaLogo;
    if (normalized.contains('scan')) return AppAssets.misrScan;
    return AppAssets.providers;
  }
}

