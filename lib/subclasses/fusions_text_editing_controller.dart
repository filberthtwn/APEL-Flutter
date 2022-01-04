import 'package:flutter/widgets.dart';

enum TextFieldEditingState {
  BEGIN,
  CHANGE,
}

class FusionsTextEditingController extends TextEditingController {
  String _oldInputText = '';

  TextFieldEditingState didTextFieldEditing({TextEditingController textEditingController}) {
    if ((this._oldInputText == '' && textEditingController.text == '') || this._oldInputText == textEditingController.text) {
      return TextFieldEditingState.BEGIN;
    }
    // print(this._oldInputText);
    this._oldInputText = textEditingController.text;
    // textEditingController.text

    return TextFieldEditingState.CHANGE;
  }
}
