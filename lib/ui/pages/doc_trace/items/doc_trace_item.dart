part of '../../pages.dart';

Widget _buildDocTraceItem({@required Document document}) => Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDocDateText(datetime: document.date),
                _buildDocStatusText(status: document.status),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 8),
            child: _buildDocIdText(docNumber: document.docNumber),
          ),
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDocReportIdText(reportNumber: document.reportNumber),
                _buildDocTypeText(subject: document.subject),
              ],
            ),
          ),
        ],
      ),
    );

Widget _buildDocDateText({@required String datetime}) => _buildTextAlignLeft(
      text: datetime,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );

Widget _buildDocStatusText({@required String status}) => _buildTextAlignLeft(
      text: status,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AppColor.PRIMARY_COLOR,
    );

Widget _buildDocIdText({@required String docNumber}) => _buildTextAlignLeft(
      text: docNumber,
      fontSize: 17,
      fontWeight: FontWeight.w600,
    );

Widget _buildDocReportIdText({@required String reportNumber}) => _buildTextAlignLeft(
      text: reportNumber,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );

Widget _buildDocTypeText({@required String subject}) => _buildTextAlignLeft(
      text: subject,
      fontSize: 14,
    );
