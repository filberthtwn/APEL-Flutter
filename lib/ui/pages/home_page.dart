part of 'pages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements HomeInterface {
  BuildContext context;
  int _selectedIndex = 0;
  QRViewController qrViewC;
  static List<Widget> _pageOptions;
  static List<Widget> _appBarOptions;

  Color navbarColor = AppColor.PRIMARY_COLOR;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(context) {
    final logout = Provider.of<APIHelper>(context).isLoggedOut;
    print(logout);

    App.shared.context = context;

    setState(() {
      _appBarOptions = <Widget>[
        _timelineAppBar(context, this.navbarColor),
        _accountAppBar(context),
      ];
      _pageOptions = <Widget>[
        TimelinePage(context: context, homeInterface: this),
        AccountPage(context: context),
      ];
    });

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBarOptions.elementAt(_selectedIndex),
        body: _pageOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColor.PRIMARY_BTN_COLOR,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Timeline',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.PRIMARY_BTN_COLOR,
          child: Icon(Icons.qr_code_rounded),
          onPressed: () {
            Navigator.of(context).pushNamed('/scan_qr');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  @override
  void changeNavbarColor(Color color) {
    this.navbarColor = color;
    setState(() {});
  }
}

Widget _timelineAppBar(BuildContext context, Color navbarColor) {
  return AppBar(
    elevation: 0,
    backgroundColor: navbarColor,
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: navbarColor,
      statusBarIconBrightness: (navbarColor == AppColor.PRIMARY_COLOR) ? Brightness.light : Brightness.dark,
    ),
    automaticallyImplyLeading: false,
    actions: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
          child: TextField(
            readOnly: true,
            onTap: () {
              Navigator.of(context).pushNamed("/police_report");
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: Colors.white,
              prefixIconConstraints: BoxConstraints(
                minWidth: 21,
                minHeight: 21,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.search,
                  color: AppColor.TEXT_LIGHT_MUTED_COLOR,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
                borderSide: BorderSide(
                  color: AppColor.DISABLED_TEXTFIELD_FILL_COLOR,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
                borderSide: BorderSide(
                  color: AppColor.DISABLED_TEXTFIELD_FILL_COLOR,
                  width: 1,
                ),
              ),
              hintText: "Pencarian Laporan Polisi",
              hintStyle: TextStyle(fontSize: 14.0, color: AppColor.TEXT_LIGHT_MUTED_COLOR),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () => Navigator.of(context).pushNamed("/notification"),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 24, 0),
          child: Icon(
            Icons.notifications,
            color: (navbarColor == AppColor.PRIMARY_COLOR) ? Colors.white : Colors.black,
          ),
        ),
      ),
    ],
  );
}

Widget _accountAppBar(BuildContext context) {
  return AppBarWidget(
    title: "My Profile",
    automaticallyImplyLeading: false,
    actions: [
      TextButton(
        onPressed: () {
          SharedPrefHelper.shared.removeCurrentUser().then(
                (value) => {
                  Navigator.pushReplacementNamed(context, '/login'),
                },
              );
        },
        child: Text(
          "Logout",
          style: TextStyle(color: AppColor.TERTIARY_COLOR),
        ),
      )
    ],
  );
}

class HomeInterface {
  void changeNavbarColor(Color color) {}
}
