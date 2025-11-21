import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/features/network/data/network_category_response_model.dart';

class NetworkCategoriesList extends StatelessWidget {
  final List<NetworkCategory> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;

  const NetworkCategoriesList({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategoryId == category.id;

          return GestureDetector(
            onTap: () {
              onCategorySelected(isSelected ? null : category.id);
            },
            child: Container(
              width: 70.w,
              height: 80.h,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: category.bgColor,
                borderRadius: BorderRadius.circular(40.r),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2.w,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Container(
                    width: 55.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: category.image,
                        width: 26.w,
                        height: 26.h,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            color: Colors.grey,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.medical_services_outlined,
                          size: 22.sp,
                          color: category.iconColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: category.textColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

extension NetworkCategoryUI on NetworkCategory {
  Color get bgColor {
    switch (id) {
      case 1:
        return const Color(0xFFF6DACA);
      case 4:
        return const Color(0xFFD2EDEB);
      case 9:
        return const Color(0xFFE8D6DB);
      case 5:
        return const Color(0xFFD2DAFF);
      case 3:
        return const Color(0xFFFFEDC7);
      case 6:
        return const Color(0xFFCBCCCF);
      case 10:
        return const Color(0xFFCFE0FC);
      case 8:
        return const Color(0xFFCFECEF);
      case 2:
        return const Color(0xFFF2CBE7);
      case 11:
        return const Color(0xFFF2CBE7);
      default:
        return AppColors.lightGreyClr;
    }
  }

  Color get iconColor {
    switch (id) {
      case 1:
        return const Color(0xFFFF9900);
      case 4:
        return const Color(0xFF33CC99);
      case 9:
        return const Color(0xFFCC6699);
      case 5:
        return const Color(0xFF3366FF);
      case 3:
        return const Color(0xFFFFCC00);
      case 6:
        return const Color(0xFF666666);
      case 10:
        return const Color(0xFF004CFF);
      case 8:
        return const Color(0xFF009999);
      case 2:
        return const Color(0xFFCC66CC);
      default:
        return AppColors.greyClr;
    }
  }

  Color get textColor => iconColor;
}
