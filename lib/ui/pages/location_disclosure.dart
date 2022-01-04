part of 'pages.dart';

class LocationDisclosure extends StatelessWidget {
  const LocationDisclosure({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Location location = new Location();
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SvgPicture.asset('assets/images/ic_location_pin.svg'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                "Gunakan lokasi anda",
                style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Text(
              // "APEL membutuhkan data lokasi anda untuk mendeteksi lokasi anda saat melakukan absensi",
              "APEL membutuhkan data lokasi anda untuk mendeteksi koordinat anda saat melakukan submit absensi. kami membutuhkan lokasi anda hanya saat aplikasi terbuka dan ketika melakukan absensi",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "ProximaNova",
                fontSize: 17,
              ),
            ),
            Spacer(),
            Image.asset("assets/images/maps-image.png"),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 55),
              child: Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Tolak",
                          style: TextStyle(
                            fontFamily: "ProximaNova",
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColor.PRIMARY_COLOR,
                          ))),
                  Spacer(),
                  TextButton(
                      onPressed: () async {
                        await location.requestPermission();
                        Navigator.pop(context);
                      },
                      child: Text("Izinkan",
                          style: TextStyle(
                            fontFamily: "ProximaNova",
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColor.PRIMARY_COLOR,
                          ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
