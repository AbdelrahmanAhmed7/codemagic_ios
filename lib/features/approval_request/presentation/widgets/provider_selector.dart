import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class ProviderSelector extends StatefulWidget {
  const ProviderSelector({super.key});

  @override
  State<ProviderSelector> createState() => _ProviderSelectorState();
}

class _ProviderSelectorState extends State<ProviderSelector> {
  String? _selectedProvider;
  bool _chronic = false;

  @override
  Widget build(BuildContext context) {
    final isElezaby =
        (_selectedProvider ?? '').toLowerCase().contains('ezaby') ||
        (_selectedProvider ?? '').toLowerCase().contains('elezaby');
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
                    child: Image.asset(
                      _assetForProvider(_selectedProvider!),
                      fit: BoxFit.cover,
                    ),
                  ),
                Expanded(
                  child: Text(
                    _selectedProvider ?? 'Select provider',
                    style: _selectedProvider == null
                        ? AppTextStyles.font14GreyRegular
                        : AppTextStyles.font14BlackMedium,
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
              Text('Chronic Treatment', style: AppTextStyles.font14BlackMedium),
            ],
          ),
        ],
      ],
    );
  }

  void _openProvidersSheet() async {
    final providers = const [
      ('Shifa', 'Hospital'),
      ('Elezaby', 'Pharmacy'),
      ('Alfa Lab', 'Laboratory'),
      ('MISR Scan', 'Scan Center'),
    ];
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.whiteClr,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyClr,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Text(
                    'Select provider',
                    style: AppTextStyles.font16BlackMedium,
                  ),
                  SizedBox(height: 12.h),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: providers.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: AppColors.lightGreyClr),
                      itemBuilder: (context, index) {
                        final (name, type) = providers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.lightGreyClr,
                            foregroundImage: AssetImage(
                              _assetForProvider(name),
                            ),
                          ),
                          title: Text(
                            name,
                            style: AppTextStyles.font14BlackMedium,
                          ),
                          subtitle: Text(
                            type,
                            style: AppTextStyles.font12GreyRegular,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).pop(name),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        _selectedProvider = result;
        if (!((_selectedProvider ?? '').toLowerCase().contains('ezaby') ||
            (_selectedProvider ?? '').toLowerCase().contains('elezaby'))) {
          _chronic = false;
        }
      });
    }
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
