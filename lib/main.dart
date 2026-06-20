import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readora/core/utils/helper/cach_helper.dart';
import 'package:readora/core/utils/observer/BlocObservable.dart';
import 'package:readora/features/auth/presentation/cubit/user_cubit.dart';
import 'package:readora/features/auth/presentation/pages/Login_Screen.dart';
import 'package:readora/features/auth/presentation/pages/register_screen.dart';

import 'core/network/network_service.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await CacheHelper.init();
    await Network.init();
    Bloc.observer = BlocObservable();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:LoginScreen(),
      ),
    );
  }
}


