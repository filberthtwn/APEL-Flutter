part of '../../../pages.dart';

Widget _buildDocTraceDetailReporterItem({@required Accuser accuser}) => Container(
      width: double.infinity,
      // decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: _buildTextAlignLeft(
        text: accuser.fullName,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
