# 🎨 أمثلة على أنواع الخطط المختلفة

## كيفية تغيير نوع الخطة في Home Screen

### 1. Gold Plan (أصفر)
```dart
UserPlanCardWidget(
  planType: PlanType.gold,
  userName: 'Ahmed Mohamed Adel Amin',
  cardId: '976875',
  expireDate: '12/2028',
)
```

### 2. Silver Plan (فضي)
```dart
UserPlanCardWidget(
  planType: PlanType.silver,
  userName: 'Ahmed Mohamed Adel Amin',
  cardId: '976875',
  expireDate: '12/2028',
)
```

### 3. Bronze Plan (برونزي)
```dart
UserPlanCardWidget(
  planType: PlanType.bronze,
  userName: 'Ahmed Mohamed Adel Amin',
  cardId: '976875',
  expireDate: '12/2028',
)
```

### 4. Platinum Plan (بلاتيني)
```dart
UserPlanCardWidget(
  planType: PlanType.platinum,
  userName: 'Ahmed Mohamed Adel Amin',
  cardId: '976875',
  expireDate: '12/2028',
)
```

### 5. Diamond Plan (ألماسي)
```dart
UserPlanCardWidget(
  planType: PlanType.diamond,
  userName: 'Ahmed Mohamed Adel Amin',
  cardId: '976875',
  expireDate: '12/2028',
)
```

## الألوان المستخدمة

```dart
// في app_colors.dart
static const goldPlanColor = Color(0xFFFFD700);      // أصفر ذهبي
static const silverPlanColor = Color(0xFFC0C0C0);    // فضي
static const bronzePlanColor = Color(0xFFCD7F32);    // برونزي
static const platinumPlanColor = Color(0xFFE5E4E2);  // بلاتيني
static const diamondPlanColor = Color(0xFFB9F2FF);   // ألماسي
```

## كيفية التبديل بين الخطط ديناميكياً

```dart
class _HomeScreenState extends State<HomeScreen> {
  PlanType currentPlanType = PlanType.diamond;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... باقي الكود
      body: Column(
        children: [
          // ... باقي الـ widgets
          UserPlanCardWidget(
            planType: currentPlanType, // استخدام المتغير
            userName: 'Ahmed Mohamed Adel Amin',
            cardId: '976875',
            expireDate: '12/2028',
          ),
          // ... باقي الـ widgets
        ],
      ),
    );
  }

  // دالة لتغيير نوع الخطة
  void changePlanType(PlanType newPlanType) {
    setState(() {
      currentPlanType = newPlanType;
    });
  }
}
```

## ملاحظات مهمة

1. **الألوان**: كل خطة لها لون مميز يظهر في الـ tag
2. **النصوص**: يمكن تخصيص أسماء الخطط
3. **المرونة**: يمكن إضافة المزيد من الأنواع بسهولة
4. **التكامل**: يعمل مع جميع المكونات الأخرى

## مثال كامل للاختبار

```dart
// في home_screen.dart، استبدل هذا السطر:
planType: PlanType.diamond,

// بأي نوع آخر من الأنواع أعلاه للاختبار
```

