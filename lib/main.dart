import 'dart:io';

import 'package:academy_app/core/connectivity/logic/connectivity/connectivity_cubit.dart';
import 'package:academy_app/core/connectivity/ui/widgets/connectivity_widget.dart';
import 'package:academy_app/core/notifcations/firebase_messaging_service.dart';
import 'package:academy_app/providers/bundles.dart';
import 'package:academy_app/providers/course_forum.dart';
import 'package:academy_app/screens/account_remove_screen.dart';
import 'package:academy_app/screens/auth_screen_private.dart';
import 'package:academy_app/screens/downloaded_course_list.dart';
import 'package:academy_app/screens/edit_password_screen.dart';
import 'package:academy_app/screens/edit_profile_screen.dart';
import 'package:academy_app/screens/sub_category_screen.dart';
import 'package:academy_app/screens/verification_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:screenshot_callback/screenshot_callback.dart';

import 'constants.dart';
import 'core/notifcations/awesome_notifcation_service.dart';
import 'firebase_options.dart';
import 'providers/auth.dart';
import 'providers/categories.dart';
import 'providers/courses.dart';
import 'providers/http_overrides.dart';
import 'providers/misc_provider.dart';
import 'providers/my_bundles.dart';
import 'providers/my_courses.dart';
import 'screens/auth_screen.dart';
import 'screens/bundle_details_screen.dart';
import 'screens/bundle_list_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/device_verifcation.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/my_bundle_courses_list_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash/ui/screens/splash_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/tabs_screen.dart';
import 'package:provider/provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' as hook;


late ScreenshotCallback screenshotCallback;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessagingService.initializeFirebaseMessaging();
  await AwesomeNotifcationService.initializeNotification();
  // String? token = await FirebaseMessaging.instance.getToken();
  // debugPrint(token);
  FirebaseMessagingService.subscribeToTopic('users_notifcations');

  Logger.root.onRecord.listen((LogRecord rec) {
    debugPrint('${rec.loggerName}>${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  HttpOverrides.global = PostHttpOverrides();
  try {
    // screenshotCallback = ScreenshotCallback();

    // screenshotCallback.addListener(() async {
    //   var msg = 'screenshot at ${DateFormat('yyyy-MM-dd–kk:mm').format(DateTime.now())}';
    //   await sendScreenShotLogs(msg);
    // });
  } catch (e) {
    // print(e);
  }
  runApp(hook.ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Categories(),
        ),
        ChangeNotifierProxyProvider<Auth, Courses>(
          create: (ctx) => Courses([], []),
          update: (ctx, auth, prevoiusCourses) => Courses(
            prevoiusCourses == null ? [] : prevoiusCourses.items,
            prevoiusCourses == null ? [] : prevoiusCourses.topItems,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, MyCourses>(
          create: (ctx) => MyCourses([], []),
          update: (ctx, auth, previousMyCourses) => MyCourses(
            previousMyCourses == null ? [] : previousMyCourses.items,
            previousMyCourses == null ? [] : previousMyCourses.sectionItems,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Languages(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Bundles(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MyBundles(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CourseForum(),
        ),
      ],
      child: BlocProvider(
        create: (context) => ConnectivityCubit(Connectivity()),
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'EasyTa3lim',
            theme: ThemeData(
              fontFamily: 'google_sans',
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(secondary: kDarkButtonBg),
            ),
            debugShowCheckedModeBanner: false,
            home:  SplashScreen(),
            routes: {
              '/home': (ctx) => const TabsScreen(),
              AuthScreen.routeName: (ctx) => const AuthScreen(),
              AuthScreenPrivate.routeName: (ctx) => const AuthScreenPrivate(),
              SignUpScreen.routeName: (ctx) => const SignUpScreen(),
              ForgotPassword.routeName: (ctx) => const ForgotPassword(),
              CoursesScreen.routeName: (ctx) => const CoursesScreen(),
              CourseDetailScreen.routeName: (ctx) => const CourseDetailScreen(),
              EditPasswordScreen.routeName: (ctx) => const EditPasswordScreen(),
              EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
              VerificationScreen.routeName: (ctx) => const VerificationScreen(),
              AccountRemoveScreen.routeName: (ctx) => const AccountRemoveScreen(),
              DownloadedCourseList.routeName: (ctx) => const DownloadedCourseList(),
              SubCategoryScreen.routeName: (ctx) => const SubCategoryScreen(),
              BundleListScreen.routeName: (ctx) => const BundleListScreen(),
              BundleDetailsScreen.routeName: (ctx) => const BundleDetailsScreen(),
              MyBundleCoursesListScreen.routeName: (ctx) => const MyBundleCoursesListScreen(),
              DeviceVerificationScreen.routeName: (context) => const DeviceVerificationScreen(),
            },

            builder: (context, child) {
            return Stack(
              children: [
                child!,
                const ConnectivityBanner(),
              ],
            );
          },
          ),
        ),
      ),
    );
  }
}
