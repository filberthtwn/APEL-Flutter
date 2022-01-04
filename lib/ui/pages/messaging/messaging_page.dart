part of '../pages.dart';

class MessagingPage extends StatefulWidget {
  Member _occupant;

  MessagingPage({@required occupant}) {
    _occupant = occupant;
  }

  @override
  _MessagingPageState createState() => _MessagingPageState(occupant: _occupant);
}

class _MessagingPageState extends State<MessagingPage> {
  final _scrollController = ScrollController();
  int _totalImage = 0;
  int _imageCounter = 0;
  bool _isSendingImage = false;
  Member _occupant;
  User _user = SharedPrefHelper.shared.user;
  List<String> _messages = [];
  final imagePicker = ImagePicker();

  _MessagingPageState({@required occupant}) {
    _occupant = occupant;
  }

  @override
  initState() {
    EasyLoading.show();
    Provider.of<MessageViewModel>(context, listen: false)
        .createRoom(receiverId: _occupant.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ApiResponse createRoomResp =
        Provider.of<MessageViewModel>(context).createRoomResp;
    ApiResponse getMessagesResp =
        Provider.of<MessageViewModel>(context).getMessagesResp;
    ApiResponse sendMessageResp =
        Provider.of<MessageViewModel>(context).sendMessageResp;

    if (createRoomResp != null) {
      if (!createRoomResp.success) {
        if (createRoomResp.message == ErrorMessage.CHAT_ROOM_ALREADY_EXISTS) {
          Provider.of<MessageViewModel>(context, listen: false)
              .getMessages(receiverId: _occupant.id);
        }
      } else {
        Provider.of<MessageViewModel>(context, listen: false)
            .getMessages(receiverId: _occupant.id);
      }
      Provider.of<MessageViewModel>(context, listen: false)
          .resetCreateRoomResp();
    }

    if (sendMessageResp != null) {
      if (sendMessageResp.success) {
        this._isSendingImage = false;

        Provider.of<MessageViewModel>(context, listen: false)
            .getMessages(receiverId: _occupant.id);
        Provider.of<MessageViewModel>(context, listen: false)
            .resetSendMessageResp();
      }
    }

    if (getMessagesResp != null && !_isSendingImage) {
      this._totalImage = getMessagesResp.data['fields']
          .where((e) => e['type']['stringValue'] == 'image')
          .length;
      if (_totalImage > 0 || _totalImage == 0) {
        if (_imageCounter <= _totalImage) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          EasyLoading.dismiss();
        }
      }
    }

    return WillPopScope(
      onWillPop: () {
        Provider.of<MessageViewModel>(context, listen: false).reset();
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MessagingAppBar(occupantName: _occupant.fullName),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  controller: this._scrollController,
                  itemCount: (getMessagesResp != null)
                      ? getMessagesResp.data["fields"].length
                      : 0,
                  itemBuilder: (context, index) {
                    final senderId = getMessagesResp.data["fields"][index]["sender_id"]["stringValue"];
                    final type = getMessagesResp.data["fields"][index]["type"]["stringValue"];

                    String message;
                    if (type == 'text'){
                      message = getMessagesResp.data["fields"][index]["text"]["stringValue"];
                    }

                    String fileUrl;
                    if (type == 'image'){
                      fileUrl = getMessagesResp.data["fields"][index]["files"]["stringValue"];
                    }


                    return Padding(
                      padding: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                          bottom: (index ==
                                  getMessagesResp.data["fields"].length - 1)
                              ? 16
                              : 0),
                      child: Align(
                        alignment: (senderId == _user.id)
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: (senderId == _user.id)
                                ? AppColor.MESSAGE_OCCUPANT_BUBBLE_COLOR
                                : AppColor.MESSAGE_USER_BUBBLE_COLOR,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: messageHandler(message, fileUrl, type, senderId),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              height: 75,
              // decoration: BoxDecoration(
              //   color: Colors.blue,
              // ),
              child: MessagingInput(
                onMessageSent: (message) {
                  setState(() {
                    Provider.of<MessageViewModel>(context, listen: false)
                        .sendMessage(
                            receiverId: _occupant.id,
                            message: message,
                            type: 'text');
                  });
                },
                onPickImage: () {
                  pickImage();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageHandler(String message, String imageUrl, String type, String senderId) {
    if (type == 'text') {
      return Text(
        message,
        style: TextStyle(
            color: (senderId == _user.id) ? Colors.white : Colors.black),
      );
    }
    final image = new Image(image: CachedNetworkImageProvider(imageUrl)); // I modified this line
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((info, call) {
          Timer(Duration(milliseconds: 100), () {
            if (_imageCounter < _totalImage) {
              _imageCounter++;

              if (_imageCounter == _totalImage) {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent);
              }
            }
            print(_scrollController.position.maxScrollExtent);
          });
        },
      ),
    );

    return image;
  }

  Future pickImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        // final imageBytes = File(pickedFile.path).readAsBytesSync();
        // final base64Image = base64Encode(imageBytes);

        this._isSendingImage = true;
        EasyLoading.show(status: 'Mengirim foto...');
        Provider.of<MessageViewModel>(context, listen: false).sendMessage(receiverId: _occupant.id, type: 'image', image: File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }
}

// ignore: must_be_immutable
class MessagingInput extends StatelessWidget {
  Function(String) _onMessageSent;
  Function _onPickImage;
  final _messageTextCon = TextEditingController();

  MessagingInput({@required onMessageSent, @required onPickImage}) {
    _onMessageSent = onMessageSent;
    _onPickImage = onPickImage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColor.LINE_COLOR),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            child: Container(
              width: 24,
              height: 24,
              child: SvgPicture.asset('assets/images/ic_attachment.svg'),
            ),
            onTap: () {
              this._onPickImage();
            },
          ),
          SizedBox(width: 24),
          Expanded(
            child: Container(
              child: TextFormField(
                controller: this._messageTextCon,
                style: TextStyle(decoration: TextDecoration.none),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Tulis pesan disini...',
                ),
              ),
            ),
          ),
          SizedBox(width: 24),
          GestureDetector(
            child: Container(
              width: 32,
              height: 32,
              child: SvgPicture.asset('assets/images/ic_send.svg'),
            ),
            onTap: () {
              final message = this._messageTextCon.text;
              if (message != '') {
                this._messageTextCon.text = '';
                this._onMessageSent(message);
              }
            },
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MessagingAppBar extends StatelessWidget implements PreferredSizeWidget {
  String _occupantName = '';

  MessagingAppBar({@required occupantName}) {
    _occupantName = occupantName;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      backgroundColor: Colors.white,
      title: Container(
        padding: new EdgeInsets.only(right: 24.0),
        child: Text(
          this._occupantName,
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      leading: IconButton(
        icon: new Icon(
          Icons.chevron_left,
          color: Colors.black,
          size: 32,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
