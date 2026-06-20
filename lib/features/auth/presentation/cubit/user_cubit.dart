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
final TextEditingController NameController = TextEditingController();
final TextEditingController confPasswordController = TextEditingController();

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

Future<void> userRegister() async {
    Map<String, dynamic> map = {
      'name':NameController.text,
      'password':passwordController.text,
     'email':emailController.text,
      'confpassword':confPasswordController.text,
    };
      
      try {
        FormData formData = FormData.fromMap(map);
     Response response=   await Network.postData(
          url: Urls.userRegister,
          data: formData,
     );
        emit(AuthSuccess());
      } on DioException catch (error) {
        if (error.type == DioExceptionType.badResponse) {
          emit(AuthError(error: error.response?.data['message']));
        } else {
          emit(AuthError(error: unknownError()));
        }
      }
    }

}