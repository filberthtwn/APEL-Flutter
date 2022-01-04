part of 'pages.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _scrollController = ScrollController();
  //* Variables for pagination
  int _currentPage = 1;
  int _totalPage = 0;

  //* Variables for loading
  bool _isLoaded = false;

  @override
  initState() {
    this._scrollController.addListener(this._scrollConListener);
    super.initState();
  }

  void setupData() {
    Provider.of<NotificationViewModel>(context, listen: false)
        .getAllNotification(page: this._currentPage);
  }

  void _scrollConListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        this._currentPage < _totalPage) {
      _currentPage++;
      this.setupData();
    }
  }

  @override
  deactivate() {
    Provider.of<NotificationViewModel>(context, listen: false).reset();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    //*Bind model data from ViewModel
    final _notificationsProvider =
        Provider.of<NotificationViewModel>(context).notifications;
    if (_notificationsProvider != null) {
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
    this._totalPage = Provider.of<NotificationViewModel>(context).totalPage;

    //* Bind errMsg data form ViewModel
    String _errMsg = Provider.of<NotificationViewModel>(context).errorMsg;

    if (_errMsg != null) LoadingWidget.shared.showError(_errMsg);
    return Scaffold(
      appBar: AppBarWidget(
        title: "Notifikasi",
      ),
      body: ListView.separated(
        controller: this._scrollController,
        itemCount: (this._isLoaded)
            ? _notificationsProvider.length +
                ((this._currentPage < this._totalPage) ? 1 : 0)
            : 10,
        itemBuilder: (context, index) {
          if (!this._isLoaded && this._currentPage == 1) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: ShimmerWidget(),
            );
          }
          if (index > (_notificationsProvider.length - 1)) {
            return PaginationLoadingWidget();
          }
          return Container(
              child: _buildNotificationTile(
                  context, _notificationsProvider[index]));
        },
        separatorBuilder: (context, index) => Divider(
          color: Colors.black26,
          height: 1,
          indent: 24,
        ),
      ),
    );
  }
}

Widget _buildNotificationTile(BuildContext context, Notif notif) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.notificationType,
                    style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 14,
                      color: AppColor.TEXT_LIGHT_MUTED_COLOR,
                    ),
                  ),
                  SizedBox(
                    height: 11.0,
                  ),
                  Text(
                    notif.headline,
                    style: TextStyle(
                        fontFamily: "ProximaNova",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  SizedBox(
                    height: 11.0,
                  ),
                  Text(
                    parse(notif.subHeadline).toString(),
                    style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              notif.createdAt.split('T')[0] +
                  " " +
                  notif.createdAt.split('T')[1].substring(0, 5),
              style: TextStyle(
                fontFamily: "ProximaNova",
                fontSize: 14,
                color: AppColor.TEXT_LIGHT_MUTED_COLOR,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
