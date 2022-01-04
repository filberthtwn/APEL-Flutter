part of 'widgets.dart';

abstract class WheelPickerDelegate {
  void didSelectItem(int index, WheelPickerWidget pickerView, BuildContext context);
}

// ignore: must_be_immutable
class WheelPickerWidget extends StatelessWidget {
  List<String> contentList;
  final WheelPickerDelegate delegate;
  int _selectedIndex = 0;

  WheelPickerWidget({@required this.contentList, @required this.delegate});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        height: 225,
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      this.delegate.didSelectItem(this._selectedIndex, this, context);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Done',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 175,
              child: CupertinoPicker.builder(
                itemExtent: 48,
                scrollController: FixedExtentScrollController(initialItem: this._selectedIndex),
                backgroundColor: Color.fromRGBO(210, 213, 218, 1),
                onSelectedItemChanged: (int value) {
                  this._selectedIndex = value;
                },
                childCount: this.contentList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      this.contentList[index],
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _selectedNumber(BuildContext context) async {
  int number = await showCupertinoModalPopup(
    context: context,
    builder: (context) => Container(
      height: 250,
      child: CupertinoPicker.builder(
        itemExtent: 48,
        // magnification: 1.5,
        backgroundColor: Color.fromRGBO(210, 213, 218, 1),
        onSelectedItemChanged: (int value) {
          print(value);
          // _controller.text = (value + 1).toString();
        },
        childCount: 5,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "TextWidget",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          );
        },
      ),
    ),
  );
}

Widget _showPickerView(BuildContext context) => Container(
      height: 100,
      width: double.infinity,
      child: CupertinoPicker(
        magnification: 1.5,
        backgroundColor: Colors.red,
        itemExtent: 50,
        onSelectedItemChanged: (int value) {
          print(value);
        },
        children: [
          Text(
            "TextWidget",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );

// PickerController pickerController =
//     PickerController(count: 1, selectedItems: [5]);

// PickerViewPopup.showMode(
//     PickerShowMode.BottomSheet, // AlertDialog or BottomSheet
//     controller: pickerController,
//     context: context,
//     title: Text(
//       'AlertDialogPicker',
//       style: TextStyle(fontSize: 14),
//     ),
//     cancel: Text(
//       'Cancel',
//       style: TextStyle(color: Colors.red),
//     ),
//     onCancel: () {
//       Scaffold.of(context)
//           .showSnackBar(SnackBar(content: Text('AlertDialogPicker.cancel')));
//     },
//     confirm: Text(
//       'confirm',
//       style: TextStyle(color: Colors.blue),
//     ),
//     onConfirm: (controller) {
//       List<int> selectedItems = [];
//       selectedItems.add(controller.selectedRowAt(section: 0));
//       // selectedItems.add(controller.selectedRowAt(section: 1));
//       // selectedItems.add(controller.selectedRowAt(section: 2));

//       Scaffold.of(context).showSnackBar(SnackBar(
//           content: Text('AlertDialogPicker.selected:$selectedItems')));
//     },
//     builder: (context, popup) {
//       return Container(
//         height: 200,
//         child: popup,
//       );
//     },
//     itemExtent: 40,
//     numberofRowsAtSection: (section) {
//       return 10;
//     },
//     itemBuilder: (section, row) {
//       return Text(
//         '$row',
//         style: TextStyle(fontSize: 12),
//       );
//     });
// }

// class PickerViewWidget extends StatefulWidget {
//   @override
//   _PickerViewWidgetState createState() => _PickerViewWidgetState();

//   const PickerViewWidget({
//     Key key,
//     this.title = '',
//     this.searchBarHint = '',
//     this.showSearchBar = false,
//     this.actions,
//   }) : super(key: key);

//   final String title;
//   final bool showSearchBar;
//   final String searchBarHint;
//   final List<Widget> actions;

//   @override
//   Size get preferredSize => new Size.fromHeight(kToolbarHeight + 43);
// }

// class _PickerViewWidgetState extends State<AppBarWidget> {
//   @override
//   AppBar build(BuildContext context) {
//     return _showPicker(context);
//   }
// }

// Widget _buildAppbarWidget(
//         {BuildContext context,
//         String title,
//         List<Widget> actions,
//         bool showSearchBar,
//         String searchBarHint = ''}) =>
//     AppBar(
//       backgroundColor: Colors.white,
//       centerTitle: true,
//       title: Text(
//         title,
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 17,
//         ),
//       ),
//       leading: IconButton(
//         icon: new Icon(
//           Icons.chevron_left,
//           color: Colors.black,
//           size: 32,
//         ),
//         onPressed: () => Navigator.of(context).pop(),
//       ),
//       bottom: !showSearchBar
//           ? null
//           : PreferredSize(
//               preferredSize: Size.fromHeight(43),
//               child: Padding(
//                 padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
//                 child: Container(
//                   width: double.infinity,
//                   height: 35,
//                   child: _buildSearchBar(searchBarHint),
//                 ),
//               ),
//             ),
//       actions: actions,
//     );

// Widget _buildSearchBar(String placeholder) => TextField(
//       controller: TextEditingController(),
//       style: TextStyle(color: Colors.black),
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.zero,
//         prefixIconConstraints: BoxConstraints(
//           minWidth: 24,
//           minHeight: 24,
//         ),
//         prefixIcon: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8),
//           child: Icon(Icons.search),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(6.0),
//           ),
//           borderSide: BorderSide(
//             color: AppColor.DISABLED_TEXTFIELD_FILL_COLOR,
//             width: 1,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(6.0),
//           ),
//           borderSide: BorderSide(
//             color: AppColor.DISABLED_TEXTFIELD_FILL_COLOR,
//             width: 1,
//           ),
//         ),
//         hintText: placeholder,
//       ),
//     );
