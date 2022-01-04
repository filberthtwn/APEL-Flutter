part of 'widgets.dart';

class PoliceDetailModalDisplay extends StatefulWidget {
  const PoliceDetailModalDisplay({
    Key key,
    this.member,
    this.memberProfile,
    this.analytics,
  }) : super(key: key);

  final Member member;
  final MemberProfile memberProfile;
  final List<Analytic> analytics;

  @override
  _PoliceDetailModalDisplayState createState() => _PoliceDetailModalDisplayState(
        member: member,
      );
}

//display detail police
class _PoliceDetailModalDisplayState extends State<PoliceDetailModalDisplay> {
  final Member member;

  _PoliceDetailModalDisplayState({
    @required this.member,
  });

  @override
  deactivate() {
    Provider.of<MemberViewModel>(context, listen: false).reset();

    super.deactivate();
  }

  MemberProfile memberProfile02;
  List<Analytic> analytics02;

  @override
  Widget build(BuildContext context) {
    memberProfile02 = Provider.of<MemberViewModel>(context).memberProfile;
    analytics02 = Provider.of<MemberViewModel>(context).memberAnalytics;

    if (memberProfile02 == null) {
      Provider.of<MemberViewModel>(context, listen: false).getMemberProfile(widget.member.id);
    }

    if (memberProfile02 != null && analytics02 == null) {
      Provider.of<MemberViewModel>(context, listen: false).getMemberAnalytic(widget.member.id, '2021');
    }

    if (analytics02 == null){
      return Container(
        height: 150,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24),
        child: Wrap(
          runSpacing: 16,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: ClipOval(
                      child: (member.profilePictureUrl == null)
                          ? Image.asset(
                              "assets/images/sample-user-profile.jpg",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              member.profilePictureUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.perm_contact_calendar_rounded,
                              size: 17,
                              color: AppColor.TEXT_LIGHT_MUTED_COLOR,
                            ),
                            SizedBox(width: 4),
                            Text(
                              memberProfile02.tanggalLahir,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.TEXT_LIGHT_MUTED_COLOR,
                              ),
                            )
                          ],
                        ),
                        Text(
                          member.fullName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          member.email,
                          style: TextStyle(fontSize: 14, color: AppColor.TEXT_LIGHT_MUTED_COLOR),
                        ),
                        Text(
                          member.phoneNumber,
                          style: TextStyle(fontSize: 14, color: AppColor.TEXT_LIGHT_MUTED_COLOR, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(memberProfile02.point, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                        Text("Total Point", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    VerticalDivider(
                      thickness: 1,
                      width: 10,
                      color: Colors.black,
                    ),
                    Column(
                      children: [
                        Text(memberProfile02.crimeSummary.crimeClearence, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                        Text("Crime Clearence", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    VerticalDivider(
                      thickness: 1,
                      width: 10,
                      color: Colors.black,
                    ),
                    Column(
                      children: [
                        Text(memberProfile02.crimeSummary.crimeTotal, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                        Text("Total Crime", style: TextStyle(fontSize: 14)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              padding: EdgeInsets.only(top: 25),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: 1000,
                  child: charts.BarChart(
                    _createSampleData(),
                    defaultRenderer: new charts.BarRendererConfig(
                      groupingType: charts.BarGroupingType.grouped,
                      strokeWidthPx: 2.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<charts.Series<Analytic, String>> _createSampleData() {
    return [
      new charts.Series<Analytic, String>(
        id: 'Crime Clearence',
        seriesCategory: 'A',
        domainFn: (Analytic _analytic, _) => _analytic.month,
        measureFn: (Analytic _analytic, _) => int.parse(_analytic.crimeClearence),
        data: analytics02,
      ),
      new charts.Series<Analytic, String>(
        id: 'Crime Total',
        seriesCategory: 'A',
        domainFn: (Analytic _analytic, _) => _analytic.month,
        measureFn: (Analytic _analytic, _) => int.parse(_analytic.crimeTotal),
        data: analytics02,
      ),
    ];
  }
}
