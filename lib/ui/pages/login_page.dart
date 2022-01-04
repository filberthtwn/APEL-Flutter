part of "pages.dart";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idTextCon = TextEditingController();
  final _passTextCont = TextEditingController();

  String fcmToken;
  String message;
  bool _isPasswordHidden = true;

  @override
  deactivate() {
    Provider.of<AuthViewModel>(context, listen: false).reset();
    Provider.of<UserViewModel>(context, listen: false).reset();

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    ApiResponse apiResponse = Provider.of<AuthViewModel>(context, listen: true).apiResponse;
    String errMsg = Provider.of<AuthViewModel>(context).errorMsg;

    final user = Provider.of<UserViewModel>(context).user;
    final isAddDeviceSuccess = Provider.of<UserViewModel>(context).isAddDeviceSuccess;

    if (apiResponse != null && !isAddDeviceSuccess) {
      message = apiResponse.message;
      Provider.of<AuthViewModel>(context, listen: false).reset();

      Provider.of<UserViewModel>(context, listen: false).addDevice(fcmToken: fcmToken);
    }

    if (user != null) {
      Provider.of<UserViewModel>(context, listen: false).reset();
      LoadingWidget.shared.showSuccess(message).then((value) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      });
    }

    if (isAddDeviceSuccess){
      Provider.of<UserViewModel>(context, listen: false).resetAddDevice();
      Provider.of<UserViewModel>(context, listen: false).getUserDetail();
    }

    if (errMsg != null) {
      EasyLoading.showError(errMsg);
      Provider.of<AuthViewModel>(context, listen: false).resetErrMsg();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomRight,
              child: Image.asset("assets/images/APEL-login-background.png"),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Log In",
                      style: TextStyle(
                        fontFamily: "ProximaNova",
                        fontWeight: FontWeight.bold,
                        fontSize: 48,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Login untuk melanjutkan",
                      style: TextStyle(
                        fontFamily: "ProximaNova",
                        fontWeight: FontWeight.normal,
                        fontSize: 21,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      height: 82,
                    ),
                    Text(
                      "Email/ NRP",
                      style: TextStyle(
                        fontFamily: "ProximaNova",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _idTextCon,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Email/ NRP",
                          prefixIcon: Icon(
                            Icons.person_outlined,
                            color: Colors.grey[400],
                          ),
                          hintStyle: TextStyle(color: Colors.grey[400])),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Password",
                      style: TextStyle(
                        fontFamily: "ProximaNova",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _passTextCont,
                      obscureText: this._isPasswordHidden,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Password",
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.grey[400],
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                this._isPasswordHidden = !this._isPasswordHidden;
                              });
                            },
                            icon: Icon(this._isPasswordHidden ? Icons.visibility : Icons.visibility_off),
                          ),
                          hintStyle: TextStyle(color: Colors.grey[400])),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    BigButtonWidget(
                      text: "Login",
                      onPressed: () async {
                        if (_idTextCon.text.isEmpty) return;
                        if (_passTextCont.text.isEmpty) return;

                        /// Get FCM Token, send to server
                        fcmToken = await messaging.getToken();

                        /// Start login process
                        EasyLoading.show();
                        Provider.of<AuthViewModel>(context, listen: false).login(
                          email: _idTextCon.text,
                          password: _passTextCont.text,
                          fcmToken: fcmToken,
                        );
                      },
                    ),
                    Container()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
