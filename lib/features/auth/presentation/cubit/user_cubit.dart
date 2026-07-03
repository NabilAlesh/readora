import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readora/core/constant/urls.dart';
import 'package:readora/core/network/exception_handler.dart';
import 'package:readora/core/network/network_service.dart';
import 'package:readora/core/utils/helper/cach_helper.dart';
import 'package:readora/features/auth/presentation/cubit/user_state.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit():  super(UserInitial());

static UserCubit get(context)=>BlocProvider.of(context);

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController confPasswordController = TextEditingController();
final TextEditingController forgetEmailController = TextEditingController();
final TextEditingController otpController = TextEditingController();
final TextEditingController newPasswordController = TextEditingController();
final TextEditingController confNewPasswordController = TextEditingController();
final TextEditingController emailOtpController = TextEditingController();

Future<void> userLogin() async {
  emit(AuthLoading());
  
    Map<String, dynamic> map = {
     'email':emailController.text,
      'password':passwordController.text,
    };
      
      try {
        FormData formData = FormData.fromMap(map);
     Response response=   await Network.postData(
          url: Urls.userLogin,
          data: formData,
        );
        CacheHelper.saveData(key: "token",value:response.data['token']);
        emit(AuthSuccess());
      } on DioException catch (error) {
        if (error.type == DioExceptionType.badResponse) {
          emit(AuthError(error: error.response?.data['message']));
        } else {
          emit(AuthError(error: unknownError()));
        }
      }
    }

File? profileImage; 

Future<void> userRegister() async {
  emit(AuthLoading());

  try {
    Map<String, dynamic> map = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'password_confirmation': confPasswordController.text,
    };

    FormData formData = FormData.fromMap(map);

    if (profileImage != null) {
      formData.files.add(
        MapEntry(
          'profile_photo',
          await MultipartFile.fromFile(
            profileImage!.path,
            filename: profileImage!.path.split('/').last,
          ),
        ),
      );
    }

   await Network.postData(
      url: Urls.userRegister,
      data: formData,
    );
    
    emit(AuthSuccess());
  } on DioException catch (error) {
    if (error.type == DioExceptionType.badResponse) {
      emit(AuthError(error: error.response?.data['message'] ?? 'Registration failed'));
    } else {
      emit(AuthError(error: unknownError()));
    }
  }
}

Future<void> forgetPassword() async {
  emit(ForgetPasswordLoading());
  try {
 await Network.postData(
      url: Urls.forgotPassword,
      data: {
        'email': forgetEmailController.text,
      },
    );
    emit(ForgetPasswordSuccess());
  } on DioException catch (error) {
    if (error.type == DioExceptionType.badResponse) {
      emit(ForgetPasswordError(error: error.response?.data['message'] ?? 'حدث خطأ ما'));
    } else {
      emit(ForgetPasswordError(error: unknownError()));
    }
  }
}

Future<void> verifyResetOtp() async {
  emit(VerifyOTPLoading());
  try {
 await Network.postData(
      url: Urls.verifyResetOtp,
      data: {
        'email': forgetEmailController.text,
        'otp_code': otpController.text,
      },
    );
    emit(VerifyOTPSuccess());
  } on DioException catch (error) {
    if (error.type == DioExceptionType.badResponse) {
      emit(VerifyOTPError(error: error.response?.data['message'] ?? 'الرمز غير صحيح'));
    } else {
      emit(VerifyOTPError(error: unknownError()));
    }
  }
}

Future<void> resetPassword() async {
  emit(ResetPasswordLoading());
  try {
 await Network.postData(
      url: Urls.resetPassword,
      data: {
        'email': forgetEmailController.text,
        'otp_code': otpController.text,
        'password': newPasswordController.text,
        'password_confirmation': confNewPasswordController.text,
      },
    );
    emit(ResetPasswordSuccess());
  } on DioException catch (error) {
    if (error.type == DioExceptionType.badResponse) {
      emit(ResetPasswordError(error: error.response?.data['message'] ?? 'فشل إعادة تعيين كلمة المرور'));
    } else {
      emit(ResetPasswordError(error: unknownError()));
    }
  }
}

Future<void> verifyRegisterEmail() async {
  emit(VerifyEmailLoading());
  try {
 await Network.postData(
      url: Urls.verifyEmail,
      data: {
        'email': emailController.text,
        'otp_code': emailOtpController.text,
      },
    );
    emit(VerifyEmailSuccess());
  } on DioException catch (error) {
    if (error.type == DioExceptionType.badResponse) {
      emit(VerifyEmailError(error: error.response?.data['message'] ?? 'الرمز غير صحيح'));
    } else {
      emit(VerifyEmailError(error: unknownError()));
    }
  }
  
  }

}