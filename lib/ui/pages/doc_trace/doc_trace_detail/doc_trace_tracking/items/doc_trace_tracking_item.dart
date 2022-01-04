part of '../../../../pages.dart';

Widget _buildDocTraceTrackingItem({
  DocHistory docHistory,
  ReportHistory reportHistory,
  int index,
  int totalValue,
  BuildContext context,
}) =>
    Container(
      width: double.infinity,
      // decoration: BoxDecoration(color: Colors.green),
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: IntrinsicHeight(
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(top: index == 0 ? 16 : 0, bottom: 24),
              // decoration: BoxDecoration(color: Colors.blue),
              constraints: new BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextAlignLeft(
                    text: DateFormatter.shared.formatString(oldDateFormat: (docHistory != null) ? 'yyyy-MM-ddTHH:mm:ss' : 'yyyy-MM-dd HH:mm:ss', newDateFormat: 'dd MMM yyyy', dateString: (docHistory != null) ? docHistory.createdAt : reportHistory.createdAt),
                  ),
                  _buildTextAlignLeft(
                      text: DateFormatter.shared.formatString(
                    oldDateFormat: (docHistory != null) ? 'yyyy-MM-ddTHH:mm:ss' : 'yyyy-MM-dd HH:mm:ss',
                    newDateFormat: 'HH:mm',
                    dateString: (docHistory != null) ? docHistory.createdAt : reportHistory.createdAt,
                  )),
                ],
              ),
            ),
            SizedBox(width: 24),
            Container(
              padding: EdgeInsets.only(top: index == 0 ? 16 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 21,
                    height: 21,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: (index % 2 == 0) ? AppColor.PRIMARY_COLOR : AppColor.SECONDARY_COLOR),
                  ),
                  if (index < totalValue - 1)
                    Expanded(
                      child: Container(
                        width: 1,
                        decoration: BoxDecoration(
                          color: AppColor.LINE_DARK_COLOR,
                        ),
                      ),
                    )
                ],
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.only(top: index == 0 ? 16 : 0),
                // decoration: BoxDecoration(color: Colors.red),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: _buildTextAlignLeft(
                        text: (docHistory != null) ? docHistory.status : reportHistory.status,
                        fontWeight: FontWeight.bold,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _buildTextAlignLeft(
                        text: (docHistory != null) ? docHistory.description : parse(reportHistory.description).getElementsByTagName('p')[0].text,
                        maxLines: 100,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
