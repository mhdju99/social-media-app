// import 'package:flutter/material.dart';
// import 'package:social_media_app/core/utils/app_colors.dart';

// class AppTheme {
//   static ThemeData getAppTheme(context) {
//     return ThemeData(
//       timePickerTheme: TimePickerThemeData(
//         hourMinuteColor:
//             MaterialStateColor.resolveWith((Set<MaterialState> states) {
//           if (states.contains(MaterialState.selected)) {
//             return AppColors.primaryColor;
//           }
//           return Colors.transparent;
//         }),
//         dayPeriodColor:
//             MaterialStateColor.resolveWith((Set<MaterialState> states) {
//           if (states.contains(MaterialState.selected)) {
//             return AppColors.primaryColor;
//           }
//           return Colors.transparent;
//         }),
//       ),
//       colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4AB37E)),
//       shadowColor: AppColors.shadowColor,
//       scaffoldBackgroundColor: AppColors.whiteColor,
//       // colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
//       textTheme: TextTheme(
//         labelLarge: TextStyle(
//           fontSize: 16.sp,
//           fontFamily: CacheProvider.getAppLocale() == "en" ||
//                   CacheProvider.getAppLocale() == null
//               ? 'Poppins'
//               : 'Cairo',
//           fontWeight: FontWeight.w600,
//         ),
//         labelMedium: TextStyle(
//           fontFamily: CacheProvider.getAppLocale() == "en" ||
//                   CacheProvider.getAppLocale() == null
//               ? 'Poppins'
//               : 'Cairo',
//           fontWeight: FontWeight.w500,
//           fontSize: 14.sp,
//         ),
//         labelSmall: TextStyle(
//           fontFamily: CacheProvider.getAppLocale() == "en" ||
//                   CacheProvider.getAppLocale() == null
//               ? 'Poppins'
//               : 'Cairo',
//           fontSize: 12.sp,
//           fontWeight: FontWeight.w600,
//         ),
//         bodyMedium: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w500,
//             fontFamily: CacheProvider.getAppLocale() == "en" ||
//                     CacheProvider.getAppLocale() == null
//                 ? 'Poppins'
//                 : 'Cairo'),
//         bodyLarge: TextStyle(
//           fontFamily: 'Red Rose',
//           fontSize: 20.sp,
//           fontWeight: FontWeight.w400,
//         ),
//         bodySmall: TextStyle(
//           fontSize: 10.sp,
//           fontFamily: CacheProvider.getAppLocale() == "en" ||
//                   CacheProvider.getAppLocale() == null
//               ? 'Poppins'
//               : 'Cairo',
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );
//   }
// }
