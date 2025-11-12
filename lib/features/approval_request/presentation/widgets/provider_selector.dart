import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/providers/data/providers_models.dart';
import 'package:mediconsult/features/providers/presentation/cubit/providers_cubit.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/providers_bottom_sheet.dart';

class ProviderSelector extends StatefulWidget {
  final Function(ProviderItem?)? onProviderSelected;
  final ProviderItem? selectedProvider;

  const ProviderSelector({
    super.key,
    this.onProviderSelected,
    this.selectedProvider,
  });

  @override
  State<ProviderSelector> createState() => _ProviderSelectorState();
}

class _ProviderSelectorState extends State<ProviderSelector> {
  ProviderItem? _selectedProvider;
  bool _chronic = false;

  @override
  void initState() {
    super.initState();
    _selectedProvider = widget.selectedProvider;
  }

  @override
  Widget build(BuildContext context) {
    final isElezaby = (_selectedProvider?.name ?? '').toLowerCase().contains('ezaby') ||
        (_selectedProvider?.name ?? '').toLowerCase().contains('elezaby');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12.r,),
          onTap: _openProvidersSheet,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.whiteClr,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Color(0xffECECEC)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyClr.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_selectedProvider != null)
                  Container(
                    width: 28.w,
                    height: 28.w,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyClr,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _buildProviderLogo(_selectedProvider!),
                  ),
                Expanded(
                  child: Text(
                    _selectedProvider?.name ?? 'approval_request.select_provider'.tr(),
                    style: _selectedProvider == null
                        ? AppTextStyles.font14GreyRegular(context)
                        : AppTextStyles.font14BlackMedium(context),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.greyClr),
              ],
            ),
          ),
        ),
        if (isElezaby) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _chronic,
                  activeThumbColor: AppColors.primaryClr,
                  onChanged: (v) => setState(() => _chronic = v),
                ),
              ),
              // SizedBox(width: 8.w),
              Text('Chronic Treatment', style: AppTextStyles.font14BlackMedium(context)),
            ],
          ),
        ],
      ],
    );
  }

  void _openProvidersSheet() async {
    final result = await showModalBottomSheet<ProviderItem>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        // Use app-wide DI to ensure authorized Dio
        return BlocProvider(
          create: (_) => sl<ProvidersCubit>()
            ..loadProviders(
              lang: context.locale.languageCode,
              page: 1,
              pageSize: 20,
            ),
          child: const ProvidersBottomSheet(),
        );
      },
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        _selectedProvider = result;
        if (!((_selectedProvider?.name ?? '').toLowerCase().contains('ezaby') ||
            (_selectedProvider?.name ?? '').toLowerCase().contains('elezaby'))) {
          _chronic = false;
        }
      });
      widget.onProviderSelected?.call(_selectedProvider);
    }
  }

  Widget _buildProviderLogo(ProviderItem provider) {
    if (provider.logo != null && provider.logo!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: provider.logo!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.lightGreyClr,
          child: Center(
            child: SizedBox(
              width: 12.w,
              height: 12.w,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryClr,
                ),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
         AppAssets.logo,
        ),
      );
    }
    
    return Image.asset(
      AppAssets.logo,
    );
  }
}
