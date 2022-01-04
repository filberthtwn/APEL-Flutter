//* unused import
// import 'package:subditharda_apel/api_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingWidget {
  static final shared = LoadingWidget();

  Future showSuccess(String msg) async {
    EasyLoading.showSuccess(msg, duration: Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2), () {
      return;
    });
  }

  Future showError(String errMsg) async {
    EasyLoading.showError(errMsg, duration: Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2), () {
      return;
    });
  }
}
