part of 'widgets.dart';

Widget customFooterContainerWithShadow({Widget child}) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 25,
            offset: Offset(0, -1),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: child,
    );

Widget customCircleShape({double size, Color color}) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );

// ignore: must_be_immutable
class QrCodeIconButtonWidget extends StatelessWidget {
  String _jsonData;

  QrCodeIconButtonWidget({@required jsonData}) {
    _jsonData = jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.qr_code_scanner,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            // fullscreenDialog: true,
            opaque: false,
            // shouldPresentInFullscreen: true
            pageBuilder: (context, animation, secondaryAnimation) => Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.50)),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: QrImage(
                          data: _jsonData,
                          version: QrVersions.auto,
                          size: 225,
                          embeddedImage: AssetImage('assets/images/APEL-logo.png'),
                          // embeddedImageStyle: QrEmbeddedImageStyle(
                          //   size: Size(25.5, 34.125),
                          // ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PaginationLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 24, bottom: 24),
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
