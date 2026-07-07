import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readora/core/constant/app_color.dart';
import 'package:readora/features/auth/presentation/cubit/user_state.dart';
import 'package:readora/features/auth/presentation/pages/verify_email_screen.dart';
import '../cubit/user_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userCubit = UserCubit.get(context);

    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is VerifyEmailSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account Created and Verified Successfully!"),
            ),
          );
          Navigator.pop(context);
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account Created! Please verify your email."),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VerifyEmailScreen()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is VerifyEmailError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 240,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/gemini_image1.jpg",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 240,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: const Offset(0, 35),
                      child: GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            userCubit.profileImage = io.File(pickedFile.path);
                            (context as Element).markNeedsBuild();
                          }
                        },
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 41,
                            backgroundColor: const Color(0xFFF2F2F2),
                            backgroundImage:
                                userCubit.profileImage != null
                                    ? FileImage(userCubit.profileImage!)
                                    : null,
                            child:
                                userCubit.profileImage == null
                                    ? const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 28,
                                      color: AppColors.primaryColor,
                                    )
                                    : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Sign up to get started",
                        style: TextStyle(color: Color(0xFF999797)),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: userCubit.nameController,
                        decoration: InputDecoration(
                          hintText: "Name",
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: AppColors.primaryColor,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF2F2F2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: userCubit.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email address",
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: AppColors.primaryColor,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF2F2F2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: userCubit.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.primaryColor,
                          ),
                          suffixIcon: const Icon(
                            Icons.visibility_off,
                            color: Color(0xFF999797),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF2F2F2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: userCubit.confPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.primaryColor,
                          ),
                          suffixIcon: const Icon(
                            Icons.visibility_off,
                            color: Color(0xFF999797),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF2F2F2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed:
                              state is AuthLoading
                                  ? null
                                  : () {
                                    userCubit.userRegister();
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child:
                              state is AuthLoading
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Color(0xFF999797)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
