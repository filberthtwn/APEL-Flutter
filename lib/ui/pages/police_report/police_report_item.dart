part of '../pages.dart';

Widget _buildPoliceReportItem({@required PoliceReport policeReport}) => Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          Container(
            // decoration: BoxDecoration(color: Colors.red),
            // padding: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: _buildTextAlignLeft(
                      text: policeReport.reportNumber,
                      maxLines: 2,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(color: AppColor.PRIMARY_COLOR, borderRadius: BorderRadius.circular(30)),
                  child: _buildTextAlignLeft(
                    text: policeReport.status ?? 'Baru',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                _buildReportLocText(
                  subRegion: policeReport.subLocation,
                  region: policeReport.location,
                ),
                SizedBox(width: 8),
                _buildReportDateText(policeReport.date),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                _buildTextAlignLeft(text: 'Pelapor:', fontSize: 14, fontWeight: FontWeight.bold),
                SizedBox(width: 4),
                Expanded(
                  child: _buildTextAlignLeft(
                    text: policeReport.accuserName ?? 'TEST',
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                _buildTextAlignLeft(text: 'Terlapor:', fontSize: 14, fontWeight: FontWeight.bold),
                SizedBox(width: 4),
                Expanded(
                  child: _buildTextAlignLeft(
                    text: policeReport.defendantName ?? '-',
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildTextAlignLeft(text: 'Penyidik:', fontSize: 14, fontWeight: FontWeight.bold),
                      SizedBox(width: 4),
                      Expanded(
                        child: _buildTextAlignLeft(
                          text: policeReport.investigatorName,
                          maxLines: 1,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: policeReport.isAttention,
                  child: Row(
                    children: [
                      _buildTextAlignLeft(
                        text: 'Atensi (${policeReport.attention})',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

Widget _buildReportLocText({String region, String subRegion}) => Row(
      children: [
        Icon(
          Icons.location_on,
          size: 17,
        ),
        SizedBox(width: 4),
        _buildTextAlignLeft(
          text: '${subRegion ?? '-'}, ${region ?? '-'}',
          fontSize: 14,
        ),
      ],
    );

Widget _buildReportDateText(String date) => Row(
      children: [
        Icon(
          Icons.access_time,
          size: 17,
        ),
        SizedBox(width: 4),
        _buildTextAlignLeft(
          text: DateFormatter.shared.formatString(oldDateFormat: 'yyyy-MM-dd', newDateFormat: 'dd MMM yyyy', dateString: date),
          fontSize: 14,
        ),
      ],
    );
