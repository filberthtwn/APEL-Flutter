part of '../../../pages.dart';

Widget _buildDocTraceDetailMemberItem({@required Member member}) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    child: Wrap(
      direction: Axis.vertical,
      spacing: 4,
      children: [
        _buildTextAlignLeft(
          text: '986080164',
          fontSize: 17,
          fontWeight: FontWeight.normal,
        ),
        _buildTextAlignLeft(
          text: member.fullName,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ],
    ));
