part of 'pages.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> implements WheelPickerDelegate, DatePickerDelegate {
  final _user = SharedPrefHelper.shared.user;
  final _genders = ["Laki - Laki", "Perempuan"];
  TextEditingController _fullNameCon, _nrpCon, _emailCon, _genderCon;

  File _image;
  final picker = ImagePicker();
  String _birthdate;

  @override
  initState() {
    this._fullNameCon = TextEditingController(text: this._user.fullName);
    this._nrpCon = TextEditingController(text: this._user.nrpNumber);
    this._emailCon = TextEditingController(text: this._user.email);
    this._genderCon = TextEditingController(text: this._user.gender);
    this._birthdate = this._user.birthdate;

    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void didSelectItem(int index, WheelPickerWidget pickerView, BuildContext context) {
    setState(() {
      this._genderCon.text = this._genders[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = Provider.of<UserViewModel>(context).isSuccess;
    final user = Provider.of<UserViewModel>(context).user;

    if (isSuccess) {
      Provider.of<UserViewModel>(context).getUserDetail();
    }

    if (user != null) {
      LoadingWidget.shared.showSuccess('User berhasil diupdate');
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: "Edit Profile",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  this.getImage();
                },
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: ClipOval(
                        child: (this._image != null)
                            ? Image.file(
                                this._image,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                this._user.profilePictureUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    ChangeImageButtonWidget(),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                runSpacing: 24,
                children: [
                  customTextFieldGroup(
                    labelText: "Nama Lengkap",
                    placeholder: "e.g. John Doe",
                    controller: this._fullNameCon,
                  ),
                  customTextFieldGroup(
                    labelText: "NRP",
                    placeholder: "e.g. 123456789",
                    controller: this._nrpCon,
                  ),
                  customTextFieldGroup(
                    labelText: "Email",
                    placeholder: "e.g. johndoe@gmail.com",
                    controller: this._emailCon,
                  ),
                  customTextFieldGroup(
                    context: context,
                    labelText: "Jenis Kelamin",
                    isDropdown: true,
                    controller: this._genderCon,
                    inputView: WheelPickerWidget(contentList: this._genders, delegate: this),
                  ),
                  DatePickerTextField(
                    delegate: this,
                    labelText: "Tanggal Lahir",
                    value: this._birthdate,
                  )
                ],
              ),
              SizedBox(height: 24),
              BigButtonWidget(
                text: "Simpan",
                onPressed: () {
                  EasyLoading.show();
                  Provider.of<UserViewModel>(context, listen: false).updateUser(
                    fullName: this._fullNameCon.text,
                    nrpNumber: this._nrpCon.text,
                    email: this._emailCon.text,
                    gender: this._genderCon.text,
                    phoneNumber: '',
                    birthdate: this._birthdate,
                    image: _image,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didSelectDate(DateTime selectedDate) {
    final selectedDateStr = DateFormatter.shared.formatDateTime(selectedDate);
    this._birthdate = selectedDateStr;
  }
}
