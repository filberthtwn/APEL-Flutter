part of '../../../pages.dart';

Widget _buildDocTraceDetailReportedItem({@required Defendant defendant}) => Container(
      width: double.infinity,
      // decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: _buildTextAlignLeft(
        text: defendant.fullName,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
