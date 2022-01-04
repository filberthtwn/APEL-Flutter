part of '../pages.dart';

class MemberPage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final _scrollController = ScrollController();
  final _debouncer = Debouncer();
  final _searchCont = FusionsTextEditingController();
  //* Variables for pagination
  int _currentPage = 1;
  int _totalPage = 0;

  //* Variables for loading
  bool _isLoaded = false;

  //* Variables for search
  String _searchQuery = '';

  @override
  initState() {
    this._searchCont.addListener(this._searchContListener);
    this._scrollController.addListener(this._scrollConListener);

    super.initState();
  }

  void setupData() {
    Provider.of<MemberViewModel>(context, listen: false).getAllMember(searchQuery: this._searchQuery, page: this._currentPage);
  }

  void _scrollConListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && this._currentPage < _totalPage) {
      _currentPage++;
      this.setupData();
    }
  }

  void _searchContListener() {
    this._debouncer.run(() {
      final state = this._searchCont.didTextFieldEditing(textEditingController: this._searchCont);
      if (state == TextFieldEditingState.BEGIN) {
        return;
      }

      //* Reset all variables value
      Provider.of<MemberViewModel>(context, listen: false).resetMembers();

      this._currentPage = 1;
      this._searchQuery = this._searchCont.text;

      //* setState for showing shimmer loading
      setState(() {});
    });
  }

  @override
  deactivate() {
    Provider.of<MemberViewModel>(context, listen: false).resetMembers();

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    //*Bind model data from ViewModel
    final _membersProvider = Provider.of<MemberViewModel>(context).members;
    final _memberProfilesProvider = Provider.of<MemberViewModel>(context).memberProfiles;
    final _memberAnalyticsProvider = Provider.of<MemberViewModel>(context).analytics;
    if (_membersProvider != null) {
      if (this._currentPage == 1) {
        //* Hide shimmer effect on data loaded
        this._isLoaded = true;
      }
    } else {
      //* Show shimmer effect on first time load || search
      this._currentPage = 1;
      this._isLoaded = false;
      this.setupData();
    }
    //* Bind totalPage from ViewModel for pagiantion
    this._totalPage = Provider.of<MemberViewModel>(context).totalPage;

    //* Bind errMsg data form ViewModel
    String _errMsg = Provider.of<MemberViewModel>(context).errorMsg;

    if (_errMsg != null) LoadingWidget.shared.showError(_errMsg);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBarWidget(
          showSearchBar: true,
          searchBarHint: "Cari Anggota",
          title: "Anggota",
          searchCont: this._searchCont,
        ),
        body: SafeArea(
          child: ListView.separated(
            controller: this._scrollController,
            itemCount: (this._isLoaded) ? _membersProvider.length + ((this._currentPage < this._totalPage) ? 1 : 0) : 10,
            itemBuilder: (context, index) {
              if (!this._isLoaded && this._currentPage == 1) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ShimmerWidget(),
                );
              }
              if (index > (_membersProvider.length - 1)) {
                return PaginationLoadingWidget();
              }

              return PoliceMemberListTile(
                member: _membersProvider[index],
                actions: [
                  Container(
                    height: 32,
                    width: 50,
                    child: BuildMemberActionButton(
                      title: "Chat",
                      backgroundColor: Colors.orange,
                      onPressed: () async {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => MessagingPage(occupant: _membersProvider[index]),
                          ),
                        );
                        // String phoneNumber = _membersProvider[index].phoneNumber;
                        // if (phoneNumber[0] == '0') {
                        //   phoneNumber = "+62" + phoneNumber.substring(1);
                        // }
                        // final url = "https://wa.me/${phoneNumber}";
                        // await canLaunch(url) ? await launch(url) : LoadingWidget.shared.showError("There're some errors, please contact developer");
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: 32,
                    width: 50,
                    child: BuildMemberActionButton(
                      title: "Lihat",
                      backgroundColor: AppColor.PRIMARY_BTN_COLOR,
                      onPressed: () {
                        _buildDetailModal(
                          context: context,
                          member: _membersProvider[index]
                        );
                      },
                    ),
                  )
                ],
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: Colors.black26,
              height: 1,
              indent: 24,
            ),
          ),
        ),
      ),
    );
  }
}

Future<dynamic> _buildDetailModal({BuildContext context, Member member, MemberProfile memberProfile, List<Analytic> memberAnalytics}) async {
  showBarModalBottomSheet(
    context: context,
    builder: (context) => PoliceDetailModalDisplay(member: member, memberProfile: memberProfile, analytics: memberAnalytics),
  );
}

class BuildMemberActionButton extends StatelessWidget {
  const BuildMemberActionButton({
    Key key,
    this.title = "",
    this.onPressed,
    this.backgroundColor,
  }) : super(key: key);

  final String title;
  final Function onPressed;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      ),
      onPressed: onPressed,
    );
  }
}
