part of '../pages.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordCon = TextEditingController();
  final _newPasswordCon = TextEditingController();
  final _confirmPasswordCon = TextEditingController();

  @override
  dispose() {
    Provider.of<AuthViewModel>(context, listen: false).reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final successMsg = Provider.of<AuthViewModel>(context).successMsg;
    final errMsg = Provider.of<AuthViewModel>(context).errorMsg;

    if (successMsg != null) {
      LoadingWidget.shared.showSuccess(successMsg);
      Navigator.of(context).pop();
    }

    if (errMsg != null) {
      LoadingWidget.shared.showError(errMsg);
      Provider.of<AuthViewModel>(context, listen: false).reset();
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          appBar: AppBarWidget(
            title: "Ganti Password",
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Wrap(
                runSpacing: 24,
                children: [
                  customTextFieldGroup(
                    labelText: "Password Lama",
                    placeholder: "Masukkan password lama",
                    isSecured: true,
                    controller: this._oldPasswordCon,
                  ),
                  customTextFieldGroup(
                    labelText: "Password Baru",
                    placeholder: "Masukkan password baru",
                    isSecured: true,
                    controller: this._newPasswordCon,
                  ),
                  customTextFieldGroup(
                    labelText: "Konfirmasi Password",
                    placeholder: "Konfirmasi password baru",
                    isSecured: true,
                    controller: this._confirmPasswordCon,
                  ),
                  CustomButtonWidget(
                    title: 'Simpan',
                    pressHandler: () {
                      if (this._oldPasswordCon.text.isEmpty || this._newPasswordCon.text.isEmpty || this._confirmPasswordCon.text.isEmpty) {
                        LoadingWidget.shared.showError("Please fill the blanks");
                        return;
                      }

                      if (this._newPasswordCon.text != this._confirmPasswordCon.text) {
                        LoadingWidget.shared.showError("New password not match");
                        return;
                      }

                      EasyLoading.show();
                      Provider.of<AuthViewModel>(context, listen: false).changePassword(oldPassword: this._oldPasswordCon.text, newPassword: this._newPasswordCon.text);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
