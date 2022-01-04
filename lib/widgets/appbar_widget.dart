part of 'widgets.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();

  const AppBarWidget({
    Key key,
    this.title = '',
    this.searchBarHint = '',
    this.showSearchBar = false,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.searchCont,
  }) : super(key: key);

  final bool automaticallyImplyLeading;
  final String title;
  final bool showSearchBar;
  final String searchBarHint;
  final List<Widget> actions;
  final TextEditingController searchCont;

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight + (showSearchBar ? 43 : 0));
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildAppbarWidget(
      context: context,
      title: widget.title,
      actions: widget.actions,
      showSearchBar: widget.showSearchBar,
      searchBarHint: widget.searchBarHint,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      searchCont: widget.searchCont,
    );
  }
}

Widget _buildAppbarWidget({BuildContext context, String title, List<Widget> actions, bool showSearchBar, bool automaticallyImplyLeading, String searchBarHint = '', TextEditingController searchCont}) => AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Colors.white,
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: !automaticallyImplyLeading
          ? null
          : IconButton(
              icon: new Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 32,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
      bottom: !showSearchBar
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(43),
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Container(
                  width: double.infinity,
                  height: 35,
                  child: _buildSearchBar(
                    placeholder: searchBarHint,
                    searchCont: searchCont,
                  ),
                ),
              ),
            ),
      actions: actions,
    );

Widget _buildSearchBar({String placeholder, TextEditingController searchCont}) => TextField(
      controller: searchCont,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        prefixIconConstraints: BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.search),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
          borderSide: BorderSide(
            color: AppColor.DISABLED_TEXTFIELD_FILL_COLOR,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
          borderSide: BorderSide(
            color: AppColor.DISABLED_TEXTFIELD_FILL_COLOR,
            width: 1,
          ),
        ),
        hintText: placeholder,
      ),
    );
