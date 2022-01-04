part of 'widgets.dart';

class ChangeImageButtonWidget extends StatelessWidget {
  const ChangeImageButtonWidget({
    Key key,
    this.onPressed,
    this.context,
  }) : super(key: key);

  final void onPressed;
  final BuildContext context;
  @override
  Widget build(context) {
    return TextButton(
      onPressed: () => onPressed,
      child: Text(
        "Ganti Gambar",
        style: TextStyle(
            color: AppColor.PRIMARY_COLOR,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: "ProximaNova"),
      ),
    );
  }
}
