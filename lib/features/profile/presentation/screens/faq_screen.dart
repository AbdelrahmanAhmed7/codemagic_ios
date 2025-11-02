import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:easy_localization/easy_localization.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int selectedCategory = 0;

  final List<String> categories = [
    'faq.categories.general'.tr(),
    'faq.categories.approval'.tr(),
    'faq.categories.refund'.tr(),
    'faq.categories.medications'.tr(),
  ];

  final List<Map<String, dynamic>> faqData = [
    {
      "question": "How do I find an in-network doctor or hospital?",
      "answer": [
        "Select the “Provider” button in main screen.",
        "Choose provider type (pharmacy, labs, etc.).",
        "Select “Nearby” to see a list of providers closest to your location.",
        "Tap on a provider to view details, contact information, and directions.",
      ],
    },
    {
      "question": "Can I add family members to my insurance?",
      "answer": [
        "Yes, you can add eligible family members to your insurance plan.",
        "Navigate to the Profile section, then select Family Members.",
        "From there, you can add new members by providing their personal information.",
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(title: 'profile.faq.title'.tr(), backPath: '/profile'),
            Expanded(
              child: Transform.translate(
                offset: Offset(0, -20.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteClr,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greyClr.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search bar
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteClr,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.borderClr),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.greyClr.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search,size: 24,),
                                hintText: 'profile.faq.search_placeholder'.tr(),
                                hintStyle:
                                    AppTextStyles.font12BlackRegular(context).copyWith(
                                  color: AppColors.greyClr,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Category chips
                          SizedBox(
                            height: 37.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(width: 8.w),
                              itemBuilder: (context, index) {
                                final isSelected = index == selectedCategory;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() => selectedCategory = index);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xffFFEDC4)
                                          : AppColors.lightGreyClr,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        categories[index],
                                        style: AppTextStyles.font12GreyRegular(context),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // FAQ list
                          ...faqData.map((faq) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color: AppColors.whiteClr,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.greyClr.withValues(alpha: 0.08),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  faq["question"],
                                  style: AppTextStyles.font14BlackMedium(context),
                                ),
                                childrenPadding: EdgeInsets.all(12.w),
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      faq["answer"].length,
                                      (i) => Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 8.h),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 10.r,
                                              backgroundColor:
                                                  AppColors.primaryClr,
                                              child: Text(
                                                '${i + 1}',
                                                style: AppTextStyles
                                                    .font10GreyRegular(context)
                                                    .copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: Text(
                                                faq["answer"][i],
                                                style: AppTextStyles
                                                    .font12BlackRegular(context)
                                                    .copyWith(
                                                  color: AppColors.greyClr,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
