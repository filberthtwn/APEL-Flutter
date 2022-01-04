//* unused import
// import 'dart:html';
// import 'dart:ffi';
// import 'package:geolocator/geolocator.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:subditharda_apel/models/attention_model.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:here_sdk/core.dart';
// import 'package:flutter_map/plugin_api.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:ffi';
import 'dart:io';

// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shimmer/shimmer.dart';
import 'package:subditharda_apel/api_service.dart';
import 'package:subditharda_apel/constants/constants.dart';
import 'package:subditharda_apel/constants/errorMsg.dart';
import 'package:subditharda_apel/helpers/date_format_helper.dart';
import 'package:subditharda_apel/helpers/parser_helper.dart';
import 'package:subditharda_apel/helpers/shared_pref_helper.dart';
import 'package:subditharda_apel/main.dart';
import 'package:subditharda_apel/models/accuser_model.dart';
import 'package:subditharda_apel/models/attendance_model.dart';
import 'package:subditharda_apel/models/case_progress_model.dart';
import 'package:subditharda_apel/models/defendant_model.dart';
import 'package:subditharda_apel/models/doc_history_model.dart';
import 'package:subditharda_apel/models/doc_trace_model.dart';
import 'package:subditharda_apel/models/member_activity_model.dart';
import 'package:subditharda_apel/models/member_model.dart';
import 'package:subditharda_apel/models/notification_model.dart';
import 'package:subditharda_apel/models/police_report_model.dart';
import 'package:subditharda_apel/models/prisoner_model.dart';
import 'package:subditharda_apel/models/region_model.dart';
import 'package:subditharda_apel/models/report_history_model.dart';
import 'package:subditharda_apel/models/subregion_model.dart';
import 'package:subditharda_apel/models/unit_model.dart';
import 'package:subditharda_apel/models/user_model.dart';
import 'package:subditharda_apel/subclasses/fusions_text_editing_controller.dart';
import 'package:subditharda_apel/utils/debouncer.dart';
import 'package:subditharda_apel/view_models/attendance_view_model.dart';
import 'package:subditharda_apel/view_models/auth_view_model.dart';
import 'package:subditharda_apel/view_models/banner_view_model.dart';
import 'package:subditharda_apel/view_models/calendar_view_model.dart';
import 'package:subditharda_apel/view_models/doc_trace_view_model.dart';
import 'package:subditharda_apel/view_models/member_view_model.dart';
import 'package:subditharda_apel/view_models/message_view_model.dart';
import 'package:subditharda_apel/view_models/notification_view_model.dart';
import 'package:subditharda_apel/view_models/police_report_view_model.dart';
import 'package:subditharda_apel/view_models/prisoner_view_model.dart';
import 'package:subditharda_apel/view_models/user_view_model.dart';
import 'package:subditharda_apel/widgets/loading_widget.dart';
import 'package:subditharda_apel/widgets/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:subditharda_apel/constants/app_colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:terbilang/terbilang.dart';
import 'package:cached_network_image/cached_network_image.dart';

// import 'package:here_sdk/mapview.dart';

// import 'package:here_sdk/core.dart';
// import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:latlong/latlong.dart';
part 'sandbox_page.dart';
part 'crime_map_page.dart';
part 'prisoner/prisoner_page.dart';
part 'police_report/police_report_item.dart';
part 'police_report/police_report_page.dart';
part 'police_report/police_report_detail/police_report_detail_page.dart';

part 'scan_qr/scan_qr_page.dart';

part 'doc_trace/items/doc_trace_item.dart';
part 'doc_trace/doc_trace_page.dart';

part 'doc_trace/doc_trace_detail/items/doc_trace_detail_reported_item.dart';
part 'doc_trace/doc_trace_detail/items/doc_trace_detail_reporter_item.dart';
part 'doc_trace/doc_trace_detail/items/doc_trace_detail_member_item.dart';
part 'doc_trace/doc_trace_detail/doc_trace_detail_page.dart';

part 'doc_trace/doc_trace_detail/doc_trace_tracking/items/doc_trace_tracking_item.dart';
part 'doc_trace/doc_trace_detail/doc_trace_tracking/doc_trace_tracking_page.dart';

part 'calendar/calendar_page.dart';
part 'calendar/items/calendar_duty_item.dart';
part 'calendar/items/calendar_activity_item.dart';

part 'police_member/police_member_page.dart';

part 'attendance/attendance_page.dart';
part 'attendance/attendance_detail_page.dart';
part 'attendance/attendance_create_page.dart';
part 'attendance/camera_page.dart';

part 'home_page.dart';
part 'login_page.dart';
part 'account_page.dart';
part 'timeline_page.dart';
part 'edit_profile_page.dart';
part 'change_password/change_password_page.dart';
part 'notification_page.dart';

part 'messaging/messaging_page.dart';
part 'location_disclosure.dart';

const Color primaryColor = const Color.fromARGB(100, 0, 61, 105);
const Color secondaryColor = const Color.fromRGBO(187, 57, 40, 100);
const Color alternativeColor = const Color.fromRGBO(255, 129, 13, 100);
