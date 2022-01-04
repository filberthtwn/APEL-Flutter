//* unused import
// import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:subditharda_apel/api_service.dart';
import 'package:subditharda_apel/helpers/shared_pref_helper.dart';
import 'package:subditharda_apel/route_generator.dart';
import 'package:subditharda_apel/view_models/attendance_view_model.dart';
import 'package:subditharda_apel/view_models/auth_view_model.dart';
import 'package:subditharda_apel/view_models/banner_view_model.dart';
import 'package:subditharda_apel/view_models/calendar_view_model.dart';
import 'package:subditharda_apel/view_models/doc_trace_view_model.dart';
import 'package:subditharda_apel/view_models/member_view_model.dart';
import 'package:subditharda_apel/view_models/message_view_model.dart';
import 'package:subditharda_apel/view_models/notification_view_model.dart';
import 'package:subditharda_apel/view_models/police_report_view_model.dart';
import 'package:subditharda_apel/view_models/prisoner_view_model.dart';
import 'package:subditharda_apel/view_models/user_view_model.dart';
import 'package:firebase_core/firebase_core.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
  showBadge: true,
  playSound: true,
);

final FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Handle push notification for background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Fireabase
  await Firebase.initializeApp();

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  /// Handle background message
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Handle foreground firebase messaging
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  //* Config EasyLoading package
  EasyLoading.instance..maskType = EasyLoadingMaskType.black;

  //* Get token for logged in state
  final token = await SharedPrefHelper.shared.getToken();
  final currentUser = await SharedPrefHelper.shared.getCurrentUser();

  runApp(App((token != null && currentUser != null)));
}

class App extends StatefulWidget {
  static final shared = App(false);
  BuildContext context;
  final isLoggedIn;

  App(this.isLoggedIn);

  @override
  MyApp createState() => MyApp(this.isLoggedIn);
}

class MyApp extends State<App> {
  final isLoggedIn;

  MyApp(this.isLoggedIn);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: APIHelper.shared),
        ChangeNotifierProvider.value(value: AuthViewModel.shared),
        ChangeNotifierProvider.value(value: UserViewModel.shared),
        ChangeNotifierProvider.value(value: PoliceReportViewModel.shared),
        ChangeNotifierProvider.value(value: DocTraceViewModel.shared),
        ChangeNotifierProvider.value(value: BannerViewModel.shared),
        ChangeNotifierProvider.value(value: PrisonerViewModel()),
        ChangeNotifierProvider.value(value: AttendanceViewModel()),
        ChangeNotifierProvider.value(value: NotificationViewModel()),
        ChangeNotifierProvider.value(value: MemberViewModel.shared),
        ChangeNotifierProvider.value(value: CalendarViewModel.shared),
        ChangeNotifierProvider.value(value: MessageViewModel.shared),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: (!this.isLoggedIn) ? '/login' : '/home',
        builder: EasyLoading.init(),
        theme: ThemeData(scaffoldBackgroundColor: Colors.white, fontFamily: 'ProximaNova'),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
    // return FutureBuilder(
    //   future: Firebase.initializeApp(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return MultiProvider(
    //         providers: [
    //           ChangeNotifierProvider.value(value: APIHelper.shared),
    //           ChangeNotifierProvider.value(value: AuthViewModel.shared),
    //           ChangeNotifierProvider.value(value: UserViewModel.shared),
    //           ChangeNotifierProvider.value(value: PoliceReportViewModel.shared),
    //           ChangeNotifierProvider.value(value: DocTraceViewModel.shared),
    //           ChangeNotifierProvider.value(value: BannerViewModel.shared),
    //           ChangeNotifierProvider.value(value: PrisonerViewModel()),
    //           ChangeNotifierProvider.value(value: AttendanceViewModel()),
    //           ChangeNotifierProvider.value(value: NotificationViewModel()),
    //           ChangeNotifierProvider.value(value: MemberViewModel.shared),
    //           ChangeNotifierProvider.value(value: CalendarViewModel.shared),
    //         ],
    //         child: MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           initialRoute: (!this.isLoggedIn) ? '/login' : '/home',
    //           builder: EasyLoading.init(),
    //           theme: ThemeData(scaffoldBackgroundColor: Colors.white, fontFamily: 'ProximaNova'),
    //           onGenerateRoute: RouteGenerator.generateRoute,
    //         ),
    //       );
    //     }
    //     return Container();
    //   },
    // );
  }
}
