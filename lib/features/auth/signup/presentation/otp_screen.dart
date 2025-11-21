// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mediconsult/core/theming/app_colors.dart';
// import 'package:mediconsult/core/theming/app_text_styles.dart';
// import 'package:mediconsult/core/utils/app_button.dart';

// class OtpScreen extends StatefulWidget {
//   final String phoneNumber;

//   const OtpScreen({super.key, required this.phoneNumber});

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final List<TextEditingController> _controllers =
//       List.generate(4, (_) => TextEditingController());

//   int _secondsRemaining = 120;
//   late final _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Stream.periodic(const Duration(seconds: 1), (x) => x).listen((_) {
//       if (_secondsRemaining > 0) {
//         setState(() {
//           _secondsRemaining--;
//         });
//       } else {
//         _timer.cancel();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     _timer.cancel();
//     super.dispose();
//   }

//   String get _formattedTime {
//     final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
//     final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }

//   void _onVerify() {
//     if (_formKey.currentState!.validate()) {
//       final otp = _controllers.map((c) => c.text).join();
//       // TODO: handle OTP verification logic
//       context.go('/account-verified');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundClr,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   SizedBox(width: 30.w,),
//                   Text(
//                     'Account Verification',
//                     style: AppTextStyles.font20BlackSemiBold,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 44 .h),
//               Text(
//                 'Verify Account',
//                 style: AppTextStyles.font20BlackSemiBold,
//               ),
//               SizedBox(height: 12.h),
//               Text.rich(
//                 TextSpan(
//                   text: 'Please enter the OTP we just sent to ',
//                   style: AppTextStyles.font14GreyRegular,
//                   children: [
//                     TextSpan(
//                       text: widget.phoneNumber,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 33 .h),
//               Form(
//                 key: _formKey,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(
//                     4,
//                     (index) => SizedBox(
//                       width: 70.w,
//                       height: 60.h,
//                       child: TextFormField(
//                         controller: _controllers[index],
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         maxLength: 1,
//                         decoration: InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                             borderSide: const BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                             borderSide: const BorderSide(color: AppColors.primaryClr),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return '';
//                           }
//                           return null;
//                         },
//                         onChanged: (value) {
//                           if (value.isNotEmpty && index < 3) {
//                             FocusScope.of(context).nextFocus();
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 40.h),
//               Center(
//                 child: Text(
//                   'The verify code will expire in $_formattedTime',
//                   style: AppTextStyles.font14GreyRegular,
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               Center(
//                 child: GestureDetector(
//                   onTap: _secondsRemaining == 0
//                       ? () {
//                           setState(() {
//                             _secondsRemaining = 120;
//                           });
//                           _startTimer();
//                         }
//                       : null,
//                   child: Text(
//                     'Resend Code',
//                     style: TextStyle(
//                       color: _secondsRemaining == 0
//                           ? AppColors.primaryClr
//                           : Colors.grey,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 41.h),

//               AppButton(
//                 text: 'Verify',
//                 onPressed: _onVerify,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
