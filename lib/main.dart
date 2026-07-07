import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readora/core/utils/helper/cach_helper.dart';
import 'package:readora/core/utils/observer/BlocObservable.dart';
import 'package:readora/core/utils/theme/theme_cubit.dart';
import 'package:readora/features/auth/presentation/cubit/user_cubit.dart';
import 'package:readora/features/auth/presentation/pages/Login_Screen.dart';
import 'package:readora/features/auth/presentation/widgets/StartPageScreen.dart';
import 'package:readora/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:readora/features/my_library/presentation/cubit/my_library_cubit.dart';
import 'package:readora/features/my_orders/presentation/cubit/orders_cubit.dart';
import 'core/network/network_service.dart';
import 'core/utils/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Network.init();
  Bloc.observer = BlocObservable();

  bool isFirstTime = CacheHelper.getData(key: 'isFirstTime') ?? true;
  String? token = CacheHelper.getData(key: 'token');

  Widget initialScreen;

  if (isFirstTime) {
    initialScreen = const Startpagescreen();
  } else if (token != null && token.isNotEmpty) {
    initialScreen = const LoginScreen();
  } else {
    initialScreen = const LoginScreen();
  }

  runApp(MyApp(startWidget: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => OrdersCubit()),
        BlocProvider(create: (_) => MyLibraryCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                supportedLocales: const [Locale('en')],
                home: startWidget,
              );
            },
          );
        },
      ),
    );
  }
}
