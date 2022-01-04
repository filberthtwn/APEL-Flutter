import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:subditharda_apel/models/attendance_model.dart';
import 'package:subditharda_apel/ui/pages/pages.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      // case '/beranda':
      //   return MaterialPageRoute(builder: (_) => BerandaPage());
      case '/account':
        return MaterialPageRoute(builder: (_) => AccountPage());
      case '/change-password':
        return CupertinoPageRoute(builder: (_) => ChangePasswordPage());
      case '/home':
        return CupertinoPageRoute(builder: (_) => HomePage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/prisoner':
        return CupertinoPageRoute(builder: (_) => PrisonerPage());
      case '/calendar':
        return CupertinoPageRoute(builder: (_) => CalendarPage());
      case '/attendance':
        return CupertinoPageRoute(builder: (_) => AttendancePage());
      case '/attendance/detail':
        Attendance attendance = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => AttendanceDetailPage(attendance: attendance));
      case '/attendance/create':
        LocationData locationData = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => AttendanceCreatePage(locationData));
      case '/police_report':
        return CupertinoPageRoute(builder: (_) => PoliceReportPage());
      case '/police-member':
        return CupertinoPageRoute(builder: (_) => MemberPage());
      case '/doc_trace':
        return CupertinoPageRoute(builder: (_) => DocTracePage());
      case '/edit_profile':
        return MaterialPageRoute(builder: (_) => EditProfilePage());
      case '/notification':
        return CupertinoPageRoute(builder: (_) => NotificationPage());
      case '/scan_qr':
        return MaterialPageRoute(builder: (_) => ScanQRPage());
      case '/camera':
        return MaterialPageRoute(builder: (_) => CameraPage());
      case '/peta-crime':
        return MaterialPageRoute(builder: (_) => CrimeMapPage());
      case '/location-disclosure':
        return MaterialPageRoute(builder: (_) => LocationDisclosure());
      // case '/sandbox':
      //   return MaterialPageRoute(builder: (_) => SandBox());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("ERROR"),
        ),
      );
    });
  }
}
