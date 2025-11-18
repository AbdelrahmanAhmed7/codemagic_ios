import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/features/support/presentation/cubit/faq_cubit.dart';
import 'package:mediconsult/features/support/presentation/cubit/faq_state.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FaqCubit>().load(lang: context.locale.languageCode);
    });
  }

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
                          SizedBox(height: 16.h),

                          // FAQ list
                          SizedBox(height: 16.h),

                          BlocBuilder<FaqCubit, FaqState>(
                            builder: (context, state) {
                              return state.when(
                                initial: () => Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 24.h),
                                    child: const CircularProgressIndicator(),
                                  ),
                                ),
                                loading: () => Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 24.h),
                                    child: const CircularProgressIndicator(),
                                  ),
                                ),
                                failed: (message) => Padding(
                                  padding: EdgeInsets.only(top: 24.h),
                                  child: Text(
                                    message,
                                    style: AppTextStyles.font12GreyRegular(context),
                                  ),
                                ),
                                loaded: (faqResponse) {
                                  final data = faqResponse.data.faqs;
                                  return Column(
                                    children: data.map((faq) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 12.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteClr,
                                          borderRadius: BorderRadius.circular(12.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.greyClr.withValues(alpha: 0.14),
                                              blurRadius: 30,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent,
                                          ),
                                          child: ExpansionTile(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12.r),
                                              side: const BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            collapsedShape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12.r),
                                              side: const BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            title: Text(
                                              faq.question,
                                              style: AppTextStyles.font14BlackMedium(context),
                                            ),
                                            childrenPadding: EdgeInsets.all(12.w),
                                            children: [
                                              Text(
                                                faq.answer,
                                                style: AppTextStyles
                                                    .font14GreyRegular(context)
                                                    .copyWith(
                                                  height: 1.6,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              );
                            },
                          ),
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
