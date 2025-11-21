import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class MonthlyMedicinesSelector extends StatefulWidget {
  const MonthlyMedicinesSelector({super.key});

  @override
  State<MonthlyMedicinesSelector> createState() => _MonthlyMedicinesSelectorState();
}

class _MonthlyMedicinesSelectorState extends State<MonthlyMedicinesSelector> {
  final List<_MedItem> _items = [
    _MedItem('Metformin 500mg', 'Take twice daily'),
    _MedItem('Lisinopril 10mg', 'Take once daily'),
    _MedItem('Lisinopril 10mg', 'Take once daily'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _items.length; i++) ...[
          _MedicineTile(
            title: _items[i].name,
            subtitle: _items[i].subtitle,
            selected: _items[i].selected,
            onToggle: () => setState(() => _items[i].selected = !_items[i].selected),
          ),
          if (i != _items.length - 1) SizedBox(height: 12.h),
        ],
      ],
    );
  }
}

class _MedicineTile extends StatelessWidget {
  const _MedicineTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onToggle,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Color(0xffF1F5FC),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyClr.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.font14BlackMedium(context)),
                  SizedBox(height: 4.h),
                  Text(subtitle, style: AppTextStyles.font10GreyRegular(context)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? AppColors.successClr : AppColors.greyClr,
            ),
          ],
        ),
      ),
    );
  }
}

class _MedItem {
  _MedItem(this.name, this.subtitle);
  final String name;
  final String subtitle;
  bool selected = false;
}


