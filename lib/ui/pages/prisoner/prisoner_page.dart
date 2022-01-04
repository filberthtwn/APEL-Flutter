part of '../pages.dart';

BuildContext
    contextOfFirst; // The global variable I used to store the context of FirstPage

class PrisonerPage extends StatefulWidget {
  @override
  _PrisonerState createState() => _PrisonerState();
}

class _PrisonerState extends State<PrisonerPage> {
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
    Provider.of<PrisonerViewModel>(context, listen: false).getAllPrisoner(
        searchQuery: this._searchQuery, page: this._currentPage);
  }

  void _scrollConListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        this._currentPage < _totalPage) {
      _currentPage++;
      this.setupData();
    }
  }

  void _searchContListener() {
    this._debouncer.run(() {
      final state = this
          ._searchCont
          .didTextFieldEditing(textEditingController: this._searchCont);
      if (state == TextFieldEditingState.BEGIN) {
        return;
      }

      //* Reset all variables value
      Provider.of<PrisonerViewModel>(context, listen: false).prisoners = null;

      this._currentPage = 1;
      this._searchQuery = this._searchCont.text;

      //* setState for showing shimmer loading
      setState(() {});
    });
  }

  @override
  deactivate() {
    Provider.of<PrisonerViewModel>(context, listen: false).reset();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    //* Bind model data from ViewModel
    final _prisonersProvider =
        Provider.of<PrisonerViewModel>(context).prisoners;
    if (_prisonersProvider != null) {
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
    this._totalPage = Provider.of<PrisonerViewModel>(context).totalPage;

    //* Bind errMsg data from ViewModel
    String _errMsg = Provider.of<PrisonerViewModel>(context).errorMsg;

    if (_errMsg != null) {
      LoadingWidget.shared.showError(_errMsg);
    }

    contextOfFirst = context;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBarWidget(
          showSearchBar: true,
          searchBarHint: 'Cari tahanan',
          title: 'Tahanan',
          searchCont: this._searchCont,
        ),
        body: ListView.separated(
          controller: this._scrollController,
          padding: EdgeInsets.only(top: 8),
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
            height: 1,
            indent: 24,
          ),
          itemCount: (this._isLoaded)
              ? _prisonersProvider.length +
                  ((this._currentPage < this._totalPage) ? 1 : 0)
              : 10,
          itemBuilder: (context, index) {
            if (!this._isLoaded && this._currentPage == 1) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ShimmerWidget(),
              );
            }

            if (index > (_prisonersProvider.length - 1)) {
              return PaginationLoadingWidget();
            }

            return Container(
                child: _buildPrisonerListTile(
                    context: context, prisoner: _prisonersProvider[index]));
          },
        ),
      ),
    );
  }
}

ClipOval _buildPrisonerImage(
        {@required double height,
        @required double width,
        @required String profilePictureUrl}) =>
    ClipOval(
      child: Image(
        height: height,
        width: width,
        fit: BoxFit.cover,
        image: (profilePictureUrl != null)
            ? NetworkImage('https://www.w3schools.com/w3css/img_lights.jpg')
            : AssetImage('assets/images/img_icon.jpg'),
      ),
    );

Text _buildTextAlignLeft({
  String text,
  double fontSize = 17,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  int maxLines = 1,
}) =>
    Text(
      text,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
      softWrap: false,
      maxLines: maxLines,
      style:
          TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
    );

Widget _buildPrisonerListTile(
        {BuildContext context, @required Prisoner prisoner}) =>
    ListTile(
      contentPadding: EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 24),
      leading: _buildPrisonerImage(
          height: 55, width: 55, profilePictureUrl: prisoner.profilePictureUrl),
      title: _buildTextAlignLeft(
        text: prisoner.fullName ?? '-',
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      subtitle: _buildTextAlignLeft(
          text: prisoner.reportNumber ?? '-',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColor.TEXT_LIGHT_MUTED_COLOR),
      onTap: () => showBarModalBottomSheet(
        context: context,
        builder: (context) => Container(
            padding: EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 32),
            child: Wrap(
              runSpacing: 16,
              children: [
                _prisonerDetailHeader(prisoner: prisoner),
                Container(
                    width: double.infinity,
                    child: customTextFieldGroup(
                      labelText: 'Mulai Ditahan',
                      value: DateFormatter.shared.formatString(
                          oldDateFormat: 'yyyy-MM-dd',
                          newDateFormat: 'dd MMMM yyyy',
                          dateString: prisoner.arrestedStartDate),
                      isSecured: false,
                      isEnabled: false,
                    )),
                Container(
                    width: double.infinity,
                    child: customTextFieldGroup(
                      labelText: 'Masa Habis Tahanan',
                      value: DateFormatter.shared.formatString(
                          oldDateFormat: 'yyyy-MM-dd',
                          newDateFormat: 'dd MMMM yyyy',
                          dateString: prisoner.arrestedEndDate),
                      isSecured: false,
                      isEnabled: false,
                    )),
                Container(
                  width: double.infinity,
                  child: customTextFieldGroup(
                    labelText: 'Status Penahanan',
                    value: prisoner.arrestedStatus,
                    isSecured: false,
                    isEnabled: false,
                  ),
                )
              ],
            )),
      ),
    );

Widget _prisonerDetailHeader({@required Prisoner prisoner}) => Container(
      height: 75,

      // decoration: BoxDecoration(color: Colors.red),
      child: Row(
        children: <Widget>[
          _buildPrisonerImage(
              height: 75.0,
              width: 75.0,
              profilePictureUrl: prisoner.profilePictureUrl),
          Expanded(
            child: Container(
              width: double.infinity,
              // decoration: BoxDecoration(color: Colors.blue),
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: _buildTextAlignLeft(
                      text: prisoner.reportNumber,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  _buildTextAlignLeft(
                      text: prisoner.fullName,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                  SizedBox(height: 4),
                  _buildTextAlignLeft(
                      text: prisoner.gender,
                      fontSize: 14,
                      color: AppColor.TEXT_LIGHT_MUTED_COLOR),
                ],
              ),
            ),
          ),
          // _apelTextField(false),
        ],
      ),
    );
