part of 'widgets.dart';

Widget customTextFieldGroup({
  BuildContext context,
  String labelText,
  String placeholder,
  String value = '',
  bool isSecured = false,
  bool isEnabled = true,
  bool isDropdown = false,
  bool isDate = false,
  bool isTime = false,
  bool isTipe = false,
  TextEditingController controller,
  Widget inputView,
}) =>
    Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: _buildTextAlignLeft(
              text: labelText,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColor.TEXTFIELD_GROUP_LABEL_COLOR),
        ),
        Container(
          padding: EdgeInsets.only(top: 8),
          child: customTextField(
            context: context,
            value: value,
            isSecure: isSecured,
            isEnabled: isEnabled,
            isDropdown: isDropdown,
            placeholder: placeholder,
            inputView: inputView,
            isDate: isDate,
            isTime: isTime,
            isTipe: isTipe,
            controller: controller,
          ),
        )
      ],
    );

Widget customTextField({
  BuildContext context,
  String value,
  bool isSecure = false,
  bool isEnabled = true,
  String placeholder = '',
  bool isDropdown = false,
  Widget inputView,
  bool isDate = false,
  bool isTime = false,
  bool isTipe = false,
  TextEditingController controller,
}) =>
    TextField(
      readOnly: (isDate || isTime || isTipe) ? true : false,
      obscureText: isSecure,
      textAlignVertical: TextAlignVertical.center,
      enableInteractiveSelection: (inputView == null),
      onTap: () async {
        if (inputView != null) {
          FocusScope.of(context).requestFocus(new FocusNode());
          await showCupertinoModalPopup(
              context: context, builder: (context) => inputView);
        }
        if (isDate) {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(2018, 3, 5),
              maxTime: DateTime.now(), onChanged: (date) {
            print('change $date');
          }, onConfirm: (date) {
            controller.text = date.toString();
          }, currentTime: DateTime.now(), locale: LocaleType.en);
        } else if (isTime) {
          DatePicker.showTimePicker(
            context,
            showTitleActions: true,
            showSecondsColumn: false,
            currentTime: DateTime.now(),
            onChanged: (time) {
              print('change $time');
            },
            onConfirm: (time) {
              print('confirm $time');
              String formatedTime =
                  time.toString().split(" ")[1].substring(0, 5);
              controller.text = formatedTime;
            },
          );
        }
        //else if (isTipe) {
        //   WheelPickerWidget(contentList: this._genders, delegate: this);
        //   Picker(
        //     adapter: PickerDataAdapter<String>(
        //         pickerdata: ["Dinas Luar Kantor", "Masuk Kantor"]),
        //     changeToFirst: true,
        //     hideHeader: false,
        //     selectedTextStyle: TextStyle(color: Colors.blue),
        //     onConfirm: (picker, value) {
        //       print(value.toString());
        //       print(picker.adapter.text);
        //       controller.text = picker.adapter.text
        //           .substring(1, picker.adapter.text.length - 1);
        //     },
        //   ).showModal(context);
        //   print('modal tipe show');
        // }
      },
      controller: (controller == null)
          ? TextEditingController(
              text: value,
            )
          : controller,
      style: TextStyle(
        color:
            isEnabled ? Colors.black : AppColor.DISABLED_TEXTFIELD_TEXT_COLOR,
      ),
      decoration: InputDecoration(
        suffixIconConstraints: BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
        suffixIcon: isDropdown
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Transform.rotate(
                  angle: -90 * math.pi / 180,
                  child: Icon(Icons.chevron_left),
                ),
              )
            : null,
        contentPadding: EdgeInsets.only(left: 16, right: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: AppColor.DISABLED_TEXTFIELD_FILL_COLOR,
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: AppColor.DISABLED_TEXTFIELD_FILL_COLOR,
            width: 0.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: AppColor.DISABLED_TEXTFIELD_FILL_COLOR,
            width: 1,
          ),
        ),
        filled: !isEnabled,
        fillColor: AppColor.DISABLED_TEXTFIELD_FILL_COLOR,
        enabled: isEnabled,
        hintText: placeholder,
      ),
    );
_showPickerModal(BuildContext context, TextEditingController controller) async {
  final result = await Picker(
      adapter: PickerDataAdapter<String>(
          pickerdata: ["Dinas Luar Kantor", "Masuk Kantor"]),
      changeToFirst: true,
      hideHeader: false,
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (picker, value) {
        print(value.toString());
        print(picker.adapter.text);
        controller.text = value.toString();
      }).showModal(context);
  print("result: $result"); // ffoldKey.currentState);
}

Text _buildTextAlignLeft(
        {String text,
        double fontSize = 17,
        FontWeight fontWeight = FontWeight.normal,
        Color color = Colors.black}) =>
    Text(
      text,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
      softWrap: false,
      maxLines: 1,
      style:
          TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
    );

abstract class DatePickerDelegate {
  void didSelectDate(DateTime selectedDate);
}

// ignore: must_be_immutable
class DatePickerTextField extends StatefulWidget {
  DatePickerDelegate _delegate;
  String _labelText;
  String _value;

  DateTime selectedDate = DateTime.now();

  DatePickerTextField(
      {DatePickerDelegate delegate, String labelText, String value}) {
    this._delegate = delegate;
    this._labelText = labelText;
    this._value = value;
  }

  @override
  _DatePickerTextFieldState createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: _buildTextAlignLeft(
            text: widget._labelText,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColor.TEXTFIELD_GROUP_LABEL_COLOR,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 8),
          child: GestureDetector(
            onTap: () async {
              final DateTime picked = await showDatePicker(
                context: context,
                initialDate: widget.selectedDate,
                firstDate: DateTime(getLastHundredYear()),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != widget.selectedDate) {
                widget.selectedDate = picked;

                setState(() {
                  widget._value = DateFormatter.shared.formatDateTime(picked);
                });
                widget._delegate.didSelectDate(picked);
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColor.DISABLED_TEXTFIELD_FILL_COLOR,
                  width: 1,
                ),
              ),
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget._value),
                  ),
                  Transform.rotate(
                    angle: -90 * math.pi / 180,
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  int getLastHundredYear(){
    DateTime now = DateTime.now();
    DateTime lastHundredDate = DateTime(now.year-100, now.month, now.day);
    DateFormat formatter = DateFormat('yyyy');

    return int.parse(formatter.format(lastHundredDate));
  }
}
