import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:social_media_app/core/databases/cache/cache_helper.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/utils/logger.dart';
import 'package:social_media_app/features/authentication/domain/params/login_params.dart';
import 'package:social_media_app/features/authentication/domain/params/register_params.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/BlocObserver.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';

void main() async {
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) print("🧪 DEBUG: $message");
  };
  // ✅ تأكد أن الاعتمادية جاهزة
  // TestWidgetsFlutterBinding.ensureInitialized();
  await init();
  // TestWidgetsFlutterBinding.ensureInitialized();
  // ← إذا كنت تستخدم get_it
  // Bloc.observer = SimpleBlocObserver();
  // await CacheHelper.init();

  group('🔥 real server test', () {
    late AuthenticationBloc authBloc;

    setUp(() {
      authBloc = sl<AuthenticationBloc>();
      // await Logger.clear(); // 🧹 امسح سجلّات التجربة السابقة
    });

    tearDown(() {
      authBloc.close();
    });
    blocTest<AuthenticationBloc, AuthenticationState>(
      '🔐 إعادة تعيين كلمة مرور - إدخال الكود يدويًا من البريد',
      build: () => authBloc,
      act: (bloc) async {
        final email = 'hhhhhmod0@gmail.com';
        final newPassword = 'mh0937334252';

    //     print('\n📨 إرسال طلب كود تحقق إلى $email...');
    //     bloc.add(RequstResetCodeRequested(email: email));
    //       await expectLater(
    //       bloc.stream,
    //       emitsInOrder([
    //         isA<AuthLoading>(),
    //         isA<AuthCodeRequestedSuccess>(),
    //       ]),
    //     );
    //     print('📤 تم إرسال الحدث إلى bloc');
    //  print('📌 الحالة الحالية بعد طلب الكود: ${bloc.state}');
        

    //     await Future.delayed(Duration(seconds: 1));

    //     // ✅ قراءة الكود يدويًا من الـ Terminal
    //     stdout.write('📥 من فضلك أدخل كود التحقق الذي وصلك بالإيميل: ');
    //     String? enteredCode = stdin.readLineSync();

    //     if (enteredCode == null || enteredCode.isEmpty) {
    //       throw Exception('❌ لم يتم إدخال كود التحقق.');
    //     }

    //     print('✅ تم إدخال الكود: $enteredCode');

        // 2️⃣ التحقق من الكود
        bloc.add(VerifyResetCodeRequested(code: "794110"));
        // bloc.add(VerifyResetCodeRequested(code: enteredCode));
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthCodeRequestedSuccess>(),
          ]),
        );
        await Future.delayed(Duration(seconds: 2));

        // 3️⃣ إعادة تعيين كلمة المرور
        // bloc.add(ResetPasswordRequested(
        //   newPassword: newPassword,
        // ));
      },
      wait: const Duration(seconds: 1),
      expect: () => [
        AuthLoading(),
        AuthCodeRequestedSuccess("wqwe"),
        AuthLoading(),
        AuthCodeVerifiedSuccess(token: "hjhjh"),
        AuthLoading(),
        AuthPasswordResetSuccess(),
      ],
      verify: (bloc) {
        final state = bloc.state;
        if (state is AuthPasswordResetSuccess) {
          print('✅ تمت إعادة تعيين كلمة المرور بنجاح 🎉');
        } else if (state is AuthFailure) {
          print('❌ فشل: ${state.message}');
        }
      },
    );
    // blocTest<AuthenticationBloc, AuthenticationState>(
    //   '🔐login yeeeeeees ',
    //   build: () => authBloc,
    //   act: (bloc) => bloc.add(LogInRequested(
    //     params: const LoginParams(email: 'yaman1@gmail.com', password: '242761'),
    //   )),
    //   wait: const Duration(seconds: 3), // انتظر نتيجة السيرفر
    //   expect: () => [
    //     AuthLoading(),
    //     isA<AuthSuccess>(), // تحقق من الحالة
    //   ],
    // );

    // blocTest<AuthenticationBloc, AuthenticationState>(
    //   '❌  login nooooooooo ',

    //   build: () => authBloc,
    //   act: (bloc) => bloc.add(LogInRequested(
    //     params: const LoginParams(email: 'wrong@example.com', password: 'wrongpass'),
    //   )),
    //   wait: const Duration(seconds: 3),
    //   expect: () => [
    //     AuthLoading(),
    //     isA<AuthFailure>(), // تحقق من الخطأ
    //   ],
    // );
    // blocTest<AuthenticationBloc, AuthenticationState>(
    //   '🟢 تسجيل ناجح',
    //   build: () => authBloc,
    //   act: (bloc) => bloc.add(RegisterRequested(
    //     params: RegisterParams(
    //       email: 'new${DateTime.now().millisecondsSinceEpoch}@test.com',
    //       password: 'e4453454',
    //       userName: 'newuser${DateTime.now().millisecondsSinceEpoch}',
    //       birthDate:  DateTime(1999,5,5).toIso8601String(),
    //       certifiedDoctor: true,
    //       city: "dsas",
    //       country: "Sda",
    //       firstName: "ali",
    //       lastName: "sos",
    //       preferredTopics:  [
    //     "Anxiety & Stress Management"
    // ]

    //     ),
    //   )),
    //   wait: const Duration(seconds: 3),
    //   expect: () => [
    //     AuthLoading(),
    //     isA<AuthSuccess>(),
    //   ],
    //   verify: (bloc) => print('✅ التسجيل نجح'),
    // );

    //  blocTest<AuthenticationBloc, AuthenticationState>(
    //   '🔴 فشل: بريد مكرر بالتسجيل',
    //   build: () => authBloc,
    //   act: (bloc) => bloc.add(RegisterRequested(
    //     params: RegisterParams(
    //       email:  "yaman1@gmail.com",
    //       password: '123456',
    //       userName: 'newuser',
    //       birthDate:  DateTime(1999,5,5).toIso8601String(),
    //       certifiedDoctor: true,
    //       city: "dsas",
    //       country: "Sda",
    //       firstName: "ali",
    //       lastName: "sos",
    //       preferredTopics:  [
    //     "Anxiety & Stress Management"
    // ]

    //     ),
    //   )),
    //   wait: const Duration(seconds: 3),
    //   expect: () => [
    //     AuthLoading(),
    //     isA<AuthFailure>(),
    //   ],
    //   verify: (bloc) {
    //     final state = bloc.state;
    //     if (state is AuthFailure) {
    //       print('❌ فشل التسجيل: ${state.message}');
    //     }
    //   },
    // );
  });
}



 
    // // ✅ تحقق كود صحيح
    // blocTest<AuthenticationBloc, AuthenticationState>(
    //   '🟢 تحقق كود صحيح',
    //   build: () => authBloc,
    //   act: (bloc) => bloc.add(VerifyResetCodeRequested(
    //     params: VerifycodeParams(
    //       email: 'youruser@test.com',
    //       code: '1234', // كود صحيح
    //     ),
    //   )),
    //   wait: const Duration(seconds: 3),
    //   expect: () => [
    //     AuthLoading(),
    //     isA<AuthCodeVerifiedSuccess>(),
    //   ],
    //   verify: (_) => print('✅ تم التحقق من الكود'),
    // );

    // // ❌ كود خاطئ
    // blocTest<AuthenticationBloc, AuthenticationState>(
    //   '🔴 فشل: كود تحقق خاطئ',
    //   build: () => authBloc,
    //   act: (bloc) => bloc.add(VerifyResetCodeRequested(
    //     params: VerifycodeParams(
    //       email: 'youruser@test.com',
    //       code: '9999', // كود خاطئ
    //     ),
    //   )),
    //   wait: const Duration(seconds: 3),
    //   expect: () => [
    //     AuthLoading(),
    //     isA<AuthFailure>(),
    //   ],
    //   verify: (bloc) {
    //     final state = bloc.state;
    //     if (state is AuthFailure) {
    //       print('❌ فشل التحقق من الكود: ${state.message}');
    //     }
    //   },
    // );

    // // ✅ إعادة تعيين ناجحة
    // blocTest<AuthenticationBloc, AuthenticationState>(
    //   '🟢 إعادة تعيين كلمة المرور',
    //   build: () => authBloc,
    //   act: (bloc) => bloc.add(ResetPasswordRequested(
    //     params: ResetpasswordParams(
    //       email: 'youruser@test.com',
    //       code: '1234', // كود صحيح
    //       newPassword: 'newpassword123',
    //     ),
    //   )),
    //   wait: const Duration(seconds: 3),
    //   expect: () => [
    //     AuthLoading(),
    //     isA<AuthPasswordResetSuccess>(),
    //   ],
    //   verify: (_) => print('✅ تم إعادة تعيين كلمة المرور'),
    // );

    // // ❌ إعادة تعيين بكود خاطئ
    // blocTest<AuthenticationBloc, AuthenticationState>(
    //   '🔴 فشل: كود خاطئ عند إعادة التعيين',
    //   build: () => authBloc,
    //   act: (bloc) => bloc.add(ResetPasswordRequested(
    //     params: ResetpasswordParams(