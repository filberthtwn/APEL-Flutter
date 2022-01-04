part of 'pages.dart';

// ignore: must_be_immutable
class AccountPage extends StatefulWidget {
  BuildContext context;
  AccountPage({this.context});
  @override
  _AccountPageState createState() => _AccountPageState(context);
}

class _AccountPageState extends State<AccountPage> {
  BuildContext context;
  _AccountPageState(this.context);

  User _user = SharedPrefHelper.shared.user;

  @override
  initState() {
    // inspect(_user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    inspect(_user);

    var textStyle = TextStyle(
      fontFamily: "ProximaNova",
      fontWeight: FontWeight.bold,
      fontSize: 17,
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: [
          Container(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipOval(
                    child: Image.network(
                      this._user.profilePictureUrl,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(this._user.unitName, style: _listViewSubheadTextStyle()),
                      Text(this._user.fullName, style: _listViewHeaderTextStyle()),
                      Text(this._user.nrpNumber, style: _listViewSupportTextStyle()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("POIN", style: _listViewHeaderTextStyle()),
                      Text(
                        "1000",
                        style: _listViewHeaderTextStyle(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 3,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("/edit_profile");
            },
            child: Container(
              height: 71,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontFamily: "ProximaNova",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
          Divider(
            height: 3,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/change-password');
            },
            child: Container(
              height: 71,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Ganti Password",
                      style: textStyle,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
          Divider(
            height: 3,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

TextStyle _listViewHeaderTextStyle() {
  return TextStyle(
    fontFamily: "ProximaNova",
    fontWeight: FontWeight.bold,
    fontSize: 17,
  );
}

TextStyle _listViewSubheadTextStyle() {
  return TextStyle(
    fontFamily: "ProximaNova",
    fontSize: 12,
  );
}

TextStyle _listViewSupportTextStyle() {
  return TextStyle(
    fontFamily: "ProximaNova",
    fontSize: 14,
    color: AppColor.DISABLED_TEXTFIELD_TEXT_COLOR,
  );
}

//* rename attribute identifier
