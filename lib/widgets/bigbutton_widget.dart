part of 'widgets.dart';

class BigButtonWidget extends StatelessWidget {
  const BigButtonWidget({
    Key key,
    this.text = "",
    this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 366,
      height: 55,
      child: ElevatedButton(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "ProximaNova",
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(primary: AppColor.PRIMARY_COLOR),
        onPressed: onPressed,
      ),
    );
  }
}
