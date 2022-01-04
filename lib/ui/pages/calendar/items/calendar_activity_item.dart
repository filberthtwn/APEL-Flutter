part of '../../pages.dart';

Widget _buildCalendarActivityItem({@required MemberActivity memberActivity}) => Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextAlignLeft(
            text: memberActivity.reportCode,
            fontSize: 14,
          ),
          SizedBox(height: 4),
          _buildActivityNameText(memberActivity.title),
          SizedBox(height: 16),
          Row(
            children: [
              buildCircleImage(
                height: 75,
                width: 75,
                imagePath: memberActivity.profilePicture,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  // decoration: BoxDecoration(color: Colors.blue),
                  child: Wrap(
                    runSpacing: 4,
                    children: [
                      _buildTextAlignLeft(
                        text: DateFormatter.shared.formatString(oldDateFormat: 'yyyy-MM-dd HH:mm:ss', newDateFormat: 'dd MMM yyyy HH:mm', dateString: memberActivity.date),
                        fontSize: 12,
                      ),
                      _buildActivityUserFullNameText(memberActivity.investigatorName),
                      _buildTextAlignLeft(
                        text: memberActivity.phoneNumber,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Container(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildActivityNameText('Perihal: '),
              _buildTextAlignLeft(
                text: memberActivity.concern,
                fontSize: 17,
              ),
            ]),
          ),
          SizedBox(height: 8),
          Container(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildActivityNameText('Keterangan: '),
              _buildTextAlignLeft(
                text: memberActivity.description,
                fontSize: 17,
              ),
            ]),
          ),
        ],
      ),
    );

Widget _buildActivityNameText(String title) => _buildTextAlignLeft(
      text: title,
      fontSize: 17,
      maxLines: 2,
      fontWeight: FontWeight.bold,
    );

// ignore: invalid_required_positional_param
Widget _buildActivityUserFullNameText(@required String investigatorName) => _buildTextAlignLeft(
      text: investigatorName,
      maxLines: 2,
      fontWeight: FontWeight.w500,
    );
