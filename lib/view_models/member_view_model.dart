import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:subditharda_apel/models/member_model.dart';

import '../api_service.dart';

class MemberViewModel with ChangeNotifier {
  static final shared = MemberViewModel();

  ApiResponse _apiResponse;
  List<Member> _members;
  List<MemberProfile> memberProfiles;
  List<List<Analytic>> _analytics;
  int _totalPage = 0;

  MemberProfile _memberProfile;
  List<Analytic> _memberAnalytics;

  Member member;

  String _errMsg;

  //* Getter
  ApiResponse get apiResponse => this._apiResponse;
  String get errorMsg => this._errMsg;
  int get totalPage => this._totalPage;
  List<Member> get members => this._members;
  List<List<Analytic>> get analytics => this._analytics;
  MemberProfile get memberProfile => this._memberProfile;
  List<Analytic> get memberAnalytics => this._memberAnalytics;


  MemberViewModel() {
    // this.prisoners = null;
    this._errMsg = null;
  }

  Future<void> getAllMember({@required String searchQuery, int page = 1}) async {
    //* Check if it's first load for pagination
    this._errMsg = null;
    log("Search Query");
    log(searchQuery);

    //get all members
    final apiServiceListMember = APIService(endPoint: '/api/mobile/v1/anggota/list', isPrivate: true);
    final responseListMember = await apiServiceListMember.get(query: {
      'keyword': searchQuery,
      'page': page.toString(),
    });
    final apiResponseListMember = APIHelper.shared.checkResponse(responseListMember);

    if (!apiResponseListMember.success) {
      _errMsg = apiResponseListMember.message;
      notifyListeners();
      return;
    }

    //get all members profile
    final members = List<Member>.from((responseListMember.data['data'] as List).map((e) => Member.fromJson(e)));
    _members = members;
  //   List<MemberProfile> memberProfiles = [];
  //   List<List<Analytic>> memberAnalytics = [];
  //   for (var member in members) {
  //     //get profile
  //     MemberProfile memberinfo = await getMemberProfile(member.id);
  //     log(memberinfo.point);
  //     memberProfiles.add(memberinfo);
  //     //get analytics
  //     String thisYear = DateTime.now().year.toString();
  //     List<Analytic> memberanalytic = await getMemberAnalytic(member.id, thisYear);
  //     memberAnalytics.add(memberanalytic);
  //   }
  //   //* Members handler for pagination
  //   if (page == 1) {
  //     this.members = members;
  //     this.memberProfiles = memberProfiles;
  //     this._analytics = memberAnalytics;
  //     this._totalPage = apiResponseListMember.data['last_page'];
  //   } else {
  //     this.members.addAll(members);
  //     this.memberProfiles.addAll(memberProfiles);
  //     this._analytics.addAll(memberAnalytics);
  //   }
  //   inspect(this.members);
  //   inspect(this.memberProfiles);
  //   inspect(this._analytics);
    notifyListeners();
  }

  Future<MemberProfile> getMemberProfile(String memberId) async {
    log("GET MEMBER PROFILE ID:");
    log(memberId);
    final apiServiceProfileMember = APIService(endPoint: '/api/mobile/v1/anggota/profile/' + memberId, isPrivate: true);
    final responseProfileMember = await apiServiceProfileMember.get(query: {});

    final apiResponseProfileMember = APIHelper.shared.checkResponse(responseProfileMember);

    if (!apiResponseProfileMember.success) {
      _errMsg = apiResponseProfileMember.message;
      notifyListeners();
      return null;
    }
    final MemberProfile memberProfile = MemberProfile.fromJson(apiResponseProfileMember.data);

    _memberProfile = memberProfile;
    notifyListeners();

    return memberProfile;
  }

  Future<List<Analytic>> getMemberAnalytic(String memberId, String year) async {
    final apiServiceMemberAnalytic = APIService(endPoint: '/api/mobile/v1/anggota/summary_report/' + memberId, isPrivate: true);
    final responseMemberAnalytic = await apiServiceMemberAnalytic.get(query: {'year': year});

    print("Data:");
    print(responseMemberAnalytic);
    final apiResponseMemberAnalytic = APIHelper.shared.checkResponse(responseMemberAnalytic);

    if (!apiResponseMemberAnalytic.success) {
      _errMsg = apiResponseMemberAnalytic.message;
      notifyListeners();
      return null;
    }
    final memberAnalytics = List<Analytic>.from((responseMemberAnalytic.data['data'] as List).map((e) => Analytic.fromJson(e)));

    _memberAnalytics = memberAnalytics;
    notifyListeners();

    return memberAnalytics;
  }

  Future<void> getAllMemberWithoutPagination() async {
    this._errMsg = null;

    final apiServiceListMember = APIService(endPoint: '/api/mobile/v1/anggota/all', isPrivate: true);
    final responseListMember = await apiServiceListMember.get(query: {});

    final apiResponseListMember = APIHelper.shared.checkResponse(responseListMember);
    if (!apiResponseListMember.success) {
      _errMsg = apiResponseListMember.message;
      notifyListeners();
      return;
    }

    final members = List<Member>.from((responseListMember.data['data'] as List).map((e) => Member.fromJson(e)));
    _members = members;

    notifyListeners();
  }

  void resetMembers(){
    this._members = null;
  }

  void reset() {
    this._memberProfile = null;
    this._memberAnalytics = null;
    this._errMsg = null;
  }
}
