part of 'widgets.dart';

class CustomButtonWidget extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final VoidCallback pressHandler;

  const CustomButtonWidget({
    Key key,
    this.title = 'Button',
    this.backgroundColor = AppColor.PRIMARY_BTN_COLOR,
    this.pressHandler,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: TextButton(
        child: Text(
          title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        ),
        onPressed: pressHandler,
      ),
    );
  }
}

class CustomButtonWithImageWidget extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final VoidCallback pressHandler;
  final Icon icon;
  final Color textColor;
  final BorderSide border;

  const CustomButtonWithImageWidget({
    Key key,
    this.title = 'Button',
    this.backgroundColor = AppColor.PRIMARY_BTN_COLOR,
    this.pressHandler,
    this.icon,
    this.textColor,
    this.border,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: TextButton(
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 24,
                width: 24,
                child: Center(
                  child: Icon(
                    Icons.content_copy,
                    color: textColor,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: border,
            ),
          ),
          // backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        ),
        onPressed: pressHandler,
      ),
    );
  }
}

// Widget customButton({
//   String title = 'Button',
//   Color backgroundColor = AppColor.PRIMARY_BTN_COLOR,
//   Function pressHandler,
// }) =>
//     SizedBox(
//       height: 55,
//       width: double.infinity,
//       child: TextButton(
//         child: Text(
//           title,
//           style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white),
//         ),
//         style: ButtonStyle(
//           shape: MaterialStateProperty.all(
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           ),
//           backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
//         ),
//         onPressed: pressHandler,
//       ),
//     );
