part of 'widgets.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {Key key,
      this.header = '',
      this.texthint = '',
      this.obscureText = false,
      this.prefix})
      : super(key: key);

  final String header;
  final String texthint;
  final bool obscureText;
  final Icon prefix;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
              fontFamily: "ProximaNova",
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[700]),
        ),
        SizedBox(
          height: 8,
        ),
        TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: texthint,
              prefixIcon: prefix,
              hintStyle: TextStyle(color: Colors.grey[400])),
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
