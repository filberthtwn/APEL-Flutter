part of '../pages.dart';

GlobalKey state = GlobalKey<_CalendarState>();

class CalendarPage extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarPage> {
  DateTime _selectedCalendar = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _isDataLoaded = false;

  @override
  initState() {
    Provider.of<CalendarViewModel>(context, listen: false).getAllAgenda(
      startDate: DateFormatter.shared.formatDateTime(DateTime(_selectedDate.year, _selectedDate.month, 1)),
      endDate: DateFormatter.shared.formatDateTime(DateTime(_selectedDate.year, _selectedDate.month + 1, 0)),
      type: 'piket',
    );
    Provider.of<CalendarViewModel>(context, listen: false).getAllAgenda(
      startDate: DateFormatter.shared.formatDateTime(this._selectedDate),
      endDate: DateFormatter.shared.formatDateTime(this._selectedDate),
      type: 'piket',
    );
    super.initState();
  }

  @override
  deactivate() {
    _markedDateMap.events.clear();
    Provider.of<CalendarViewModel>(context, listen: false).reset();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    List<MemberActivity> _memberDuties = Provider.of<CalendarViewModel>(context).memberDuties;
    List<MemberActivity> _memberActivites = Provider.of<CalendarViewModel>(context).memberActivites;

    //* Today activites
    List<MemberActivity> _todayMemberDuties = Provider.of<CalendarViewModel>(context).todayMemberDuties;
    List<MemberActivity> _todayMemberActivites = Provider.of<CalendarViewModel>(context).todayMemberActivites;

    if (_memberDuties != null && _memberActivites == null) {
      Provider.of<CalendarViewModel>(context, listen: false).getAllAgenda(
        startDate: DateFormatter.shared.formatDateTime(DateTime(_selectedCalendar.year, _selectedCalendar.month, 1)),
        endDate: DateFormatter.shared.formatDateTime(DateTime(_selectedCalendar.year, _selectedCalendar.month + 1, 0)),
        type: 'kegiatan_penyidik',
      );
      inspect(_memberDuties);
    }

    if (_memberActivites != null) {
      inspect(_memberActivites);
      EasyLoading.dismiss();

      //* Setup duties on calendar
      for (var memberDuty in _memberDuties) {
        final dateTime = DateTime.parse(memberDuty.date);
        final formatedDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);

        _markedDateMap.events[formatedDateTime] = [
          Event(
            date: formatedDateTime,
            title: 'Event 1',
            dot: customCircleShape(size: 5, color: Colors.cyan),
          ),
        ];
      }

      //* Setup activities on calendar
      for (var memberActivity in _memberActivites) {
        final dateTime = DateTime.parse(memberActivity.date);
        final formatedDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);

        if (_markedDateMap.events[formatedDateTime] == null) {
          //* Initiate activity event to day events if events is null
          _markedDateMap.events[formatedDateTime] = [
            Event(
              date: formatedDateTime,
              title: 'kegiatan',
              dot: customCircleShape(size: 5, color: Colors.orange),
            ),
          ];
        } else {
          //* Add activity event to day events if event with 'kegiatan' title not exists
          if (_markedDateMap.events[formatedDateTime].where((e) => e.title == 'kegiatan').isEmpty) {
            _markedDateMap.events[formatedDateTime].add(
              Event(
                date: formatedDateTime,
                title: 'kegiatan',
                dot: customCircleShape(size: 5, color: Colors.orange),
              ),
            );
          }
        }
      }
    }

    //* Completion handler for today activities
    if (_todayMemberDuties != null && _todayMemberActivites == null) {
      Provider.of<CalendarViewModel>(context, listen: false).getAllAgenda(
        startDate: DateFormatter.shared.formatDateTime(this._selectedDate),
        endDate: DateFormatter.shared.formatDateTime(this._selectedDate),
        type: 'kegiatan_penyidik',
      );
    }

    if (_todayMemberActivites != null) {
      this._isDataLoaded = true;
    }

    return Scaffold(
      key: state,
      appBar: AppBarWidget(
        title: 'Calendar',
        showSearchBar: false,
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          // decoration: BoxDecoration(color: Colors.red),
          child: Column(
            children: [
              //* Calendar Child
              Container(
                // decoration: BoxDecoration(color: Colors.blue),
                child: _buildCalendar(
                  context: context,
                  state: this,
                  selectedDate: this._selectedDate,
                ),
              ),
              Divider(height: 1, thickness: 1, color: AppColor.LINE_COLOR),
              //* Legend Child
              Container(
                // decoration: BoxDecoration(color: Colors.orange),
                child: _buildCalendarLegend(),
              ),
              Divider(height: 1, thickness: 1, color: AppColor.LINE_COLOR),
              //* Tab Layout & View Pager Child
              Expanded(
                child: Container(
                  child: _buildCalendarTabLayout(
                    isDataLoaded: this._isDataLoaded,
                    memberDuties: _todayMemberDuties,
                    memberActivites: _todayMemberActivites,
                  ),
                ),
              )
            ],
          )),
    );
  }
}

/*
  * Build Calendar Function
*/
EventList<Event> _markedDateMap = new EventList<Event>(
  events: {},
);

Widget _buildCalendar({@required BuildContext context, state, DateTime selectedDate}) => CalendarCarousel(
      height: 385,
      pageScrollPhysics: NeverScrollableScrollPhysics(),
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      selectedDateTime: selectedDate,
      onDayPressed: (date, events) {
        state.setState(() {
          state._isDataLoaded = false;
          state._selectedDate = date;
        });
        Provider.of<CalendarViewModel>(context, listen: false).resetTodayActivites();
        Provider.of<CalendarViewModel>(context, listen: false).getAllAgenda(
          startDate: DateFormatter.shared.formatDateTime(date),
          endDate: DateFormatter.shared.formatDateTime(date),
          type: 'piket',
        );
      },
      onCalendarChanged: (dateTime) {
        EasyLoading.show();
        _markedDateMap.events.clear();
        state._selectedCalendar = dateTime;
        Provider.of<CalendarViewModel>(context, listen: false).resetActivities();
        Provider.of<CalendarViewModel>(context, listen: false).getAllAgenda(
          startDate: DateFormatter.shared.formatDateTime(DateTime(dateTime.year, dateTime.month, 1)),
          endDate: DateFormatter.shared.formatDateTime(DateTime(dateTime.year, dateTime.month + 1, 0)),
          type: 'piket',
        );
      },
      headerTextStyle: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
      dayPadding: 4,
      headerMargin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      childAspectRatio: 1.15,
      selectedDayButtonColor: AppColor.PRIMARY_COLOR, // todayTextStyle: TextStyle(fontSize: 12),
      markedDatesMap: _markedDateMap,
      markedDateIconMaxShown: 2,

      selectedDayTextStyle: TextStyle(
        color: Colors.white,
      ),
      daysTextStyle: TextStyle(
        color: AppColor.PRIMARY_COLOR,
      ),
      weekdayTextStyle: TextStyle(
        color: AppColor.PRIMARY_COLOR,
      ),
      weekendTextStyle: TextStyle(
        color: AppColor.PRIMARY_COLOR,
      ),
    );

/*
  * Build Calendar Legend Function
*/
Widget _buildCalendarLegend() => Row(
      children: [
        //* Duty Legend Child
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            // decoration: BoxDecoration(color: Colors.red),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [customCircleShape(size: 16, color: Colors.cyan), SizedBox(width: 16), _buildTextAlignLeft(text: 'Piket')],
            ),
          ),
        ),
        //* Activity Legend Child
        Expanded(
          child: Container(
            // decoration: BoxDecoration(color: Colors.orange),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [customCircleShape(size: 16, color: Colors.orange), SizedBox(width: 16), _buildTextAlignLeft(text: 'Kegiatan')],
            ),
          ),
        ),
      ],
    );

/*
  * Build Calendar Tab Layout
*/
Widget _buildCalendarTabLayout({
  @required bool isDataLoaded,
  @required List<MemberActivity> memberDuties,
  @required List<MemberActivity> memberActivites,
}) =>
    DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            // decoration: BoxDecoration(color: Colors.green),
            child: TabBar(
              isScrollable: true,
              indicatorColor: AppColor.PRIMARY_COLOR,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
              labelColor: AppColor.PRIMARY_COLOR,
              tabs: [_buildDutyTap(memberDuties), _buildActivityTap(memberActivites)],
            ),
          ),
          //* View Pager Child
          Expanded(
            child: TabBarView(
              children: [
                _buildCalendarDutyViewPager(isDutiesLoaded: isDataLoaded, memberDuties: memberDuties),
                _buildCalendarActivtyViewPager(memberActivites: memberActivites, isDataLoaded: isDataLoaded),
              ],
            ),
          )
        ],
      ),
    );

/*
 * Build Duty Tab
*/
Widget _buildDutyTap(List<MemberActivity> memberDuties) => Tab(
      child: Row(
        children: [
          _buildTextAlignLeft(
            text: 'Piket',
            color: null,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(width: 8),
          Container(
            width: 21,
            height: 21,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.PRIMARY_COLOR,
            ),
            child: Center(
              child: Text(
                (memberDuties != null) ? memberDuties.length.toString() : '0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );

/*
 * Build Duty Tab
*/
Widget _buildActivityTap(List<MemberActivity> memberActivites) => Tab(
      child: Row(
        children: [
          _buildTextAlignLeft(
            text: 'Kegiatan',
            color: null,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(width: 8),
          Container(
            width: 21,
            height: 21,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.PRIMARY_COLOR,
            ),
            child: Center(
              child: Text(
                (memberActivites != null) ? memberActivites.length.toString() : '0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );

/*
 * Build View Pager for Duty Tabs
*/
Widget _buildCalendarDutyViewPager({bool isDutiesLoaded = false, List<MemberActivity> memberDuties}) => Container(
      width: double.infinity,
      child: setupDutyItem(
        memberDuties: memberDuties,
        isDataLoaded: isDutiesLoaded,
      ),
    );

Widget setupDutyItem({List<MemberActivity> memberDuties, bool isDataLoaded}) {
  if (isDataLoaded && (memberDuties ?? []).length == 0) {
    return Center(
      child: Text(
        'Tidak ada jadwal piket',
        style: TextStyle(fontSize: 17),
      ),
    );
  }

  return ListView.separated(
    separatorBuilder: (context, index) => Divider(
      color: AppColor.LINE_COLOR,
      height: 1,
      thickness: 1,
    ),
    itemCount: (isDataLoaded) ? memberDuties.length : 5,
    itemBuilder: (context, index) {
      if (isDataLoaded) {
        return _buildCalendarDutyItem(memberDuty: memberDuties[index]);
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: ShimmerWidget(),
      );
    },
  );
}

/*
 * Build View Pager for Activity Tabs
*/
Widget _buildCalendarActivtyViewPager({List<MemberActivity> memberActivites, bool isDataLoaded}) => Container(
      width: double.infinity,
      // decoration: BoxDecoration(color: Colors.red),
      child: setupActivityItem(memberActivities: memberActivites, isDataLoaded: isDataLoaded),
    );

Widget setupActivityItem({List<MemberActivity> memberActivities, bool isDataLoaded}) {
  if (isDataLoaded && (memberActivities ?? []).length == 0) {
    return Center(
      child: Text(
        'Tidak ada jadwal kegiatan',
        style: TextStyle(fontSize: 17),
      ),
    );
  }

  return ListView.separated(
    separatorBuilder: (context, index) => Divider(
      color: AppColor.LINE_COLOR,
      height: 1,
      thickness: 1,
    ),
    itemCount: (isDataLoaded) ? memberActivities.length : 5,
    itemBuilder: (context, index) {
      if (isDataLoaded) {
        inspect(memberActivities[index]);
        return _buildCalendarActivityItem(memberActivity: memberActivities[index]);
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: ShimmerWidget(),
      );
    },
  );
}
