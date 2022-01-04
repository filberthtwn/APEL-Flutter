part of 'widgets.dart';

class PoliceMemberListTile extends StatelessWidget {
  const PoliceMemberListTile({
    Key key,
    // this.name = "",
    // this.unit = "",
    // this.phoneNumber = "",
    // this.photoProfile = "",
    this.actions,
    this.member,
  }) : super(key: key);

  // final String name;
  // final String unit;
  // final String phoneNumber;
  // final String photoProfile;
  final List<Widget> actions;
  final Member member;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: (member.profilePictureUrl == null)
              ? ClipOval(
                  child: Image.asset(
                    "assets/images/sample-user-profile.jpg",
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                )
              : ClipOval(
                  child: Image.network(
                    member.profilePictureUrl,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print(member.profilePictureUrl);
                      print(error); //do something
                    },
                  ),
                ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(this.member.unit, style: _listViewSubheadTextStyle()),
              Text(
                this.member.fullName,
                style: _listViewHeaderTextStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(this.member.nrpNumber, style: _listViewSupportTextStyle()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: actions,
          ),
        ),
      ],
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
