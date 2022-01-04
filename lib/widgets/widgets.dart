//* unused import
// import 'dart:html';
// import 'package:intl/intl.dart';
// import 'package:subditharda_apel/constants/app_strings.dart';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;
import 'package:subditharda_apel/constants/app_colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:subditharda_apel/helpers/date_format_helper.dart';
import 'package:subditharda_apel/models/member_model.dart';
import 'package:subditharda_apel/view_models/member_view_model.dart';

part 'appbar_widget.dart';

part 'text_field_widget.dart';
part 'picker_view_widget.dart';
part 'buttons_widget.dart';
part 'components_widget.dart';
part 'image_widget.dart';

part 'textfield_widget.dart';
part 'bigbutton_widget.dart';
part 'button_change_image_widget.dart';

part 'grouped_stacked_bar_chart_widget.dart';

part 'police_detail_modal_display.dart';
part 'shimmer_widget.dart';

part 'police_member_listtile_widget.dart';
