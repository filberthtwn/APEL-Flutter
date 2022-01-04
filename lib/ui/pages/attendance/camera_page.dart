part of '../pages.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController controller;
  int currentCamera = 0;
  bool mounted = false;

  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    controller =
        CameraController(cameras[currentCamera], ResolutionPreset.medium);
    await controller.initialize();
    this.mounted = true;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<File> takePicture() async {
    // Directory root = await getTemporaryDirectory();
    // String directoryPath = '${root.path}/subditharda_apel';
    // await Directory(directoryPath).create(recursive: true);
    // String filePath = '$directoryPath/${DateTime.now()}.jpg';
    try {
      final image = await controller.takePicture();
      return File(image.path);
    } catch (e) {
      return null;
    }
  }

  Future switchCamera() async {
    currentCamera == 1 ? currentCamera = 0 : currentCamera = 1;
    var cameras = await availableCameras();
    if (controller != null) {
      await controller.dispose();
    }
    controller =
        CameraController(cameras[currentCamera], ResolutionPreset.medium);
    print('camera lenght: ' + cameras.length.toString());
    await controller.initialize();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: initializeCamera(),
        builder: (_, snapshot) => (snapshot.connectionState ==
                ConnectionState.done)
            ? Stack(
                children: [
                  Column(
                    children: [
                      //* Camera Preview
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.width *
                        //     controller.value.aspectRatio,
                        // width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: CameraPreview(controller),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      //* Camera Preview
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width *
                            controller.value.aspectRatio,
                      ),
                      //* Action Area
                      Container(
                        height: 70,
                        margin: EdgeInsets.only(
                            top: ((MediaQuery.of(context).size.height -
                                        MediaQuery.of(context).size.width *
                                            controller.value.aspectRatio) /
                                    2) -
                                45),
                        // color: Colors.blue,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!controller.value.isTakingPicture) {
                                    File result = await takePicture();
                                    Navigator.pop(context, result);
                                  }
                                },
                                child: Icon(
                                  Icons.circle,
                                  size: 50,
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(3),
                                    primary: Colors.grey[350]),
                              ),
                            ),
                            //* Switch Camera
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await switchCamera();
                                },
                                child: Icon(Icons.flip_camera_android_rounded),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(20),
                                  primary: Colors.transparent,
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )
            : Center(
                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
      ),
    );
  }
}
