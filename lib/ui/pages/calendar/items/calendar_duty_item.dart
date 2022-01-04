part of '../../pages.dart';

Widget _buildCalendarDutyItem({MemberActivity memberDuty}) => Container(
      width: double.infinity,
      // decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          buildCircleImage(
            height: 75,
            width: 75,
            imagePath: memberDuty.profilePicture,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Container(
              // decoration: BoxDecoration(color: Colors.blue),
              child: Wrap(
                runSpacing: 8,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTextAlignLeft(
                        text: memberDuty.dutyType.toUpperCase(),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      _buildTextAlignLeft(
                        text: DateFormatter.shared.formatString(oldDateFormat: 'yyyy-MM-dd', newDateFormat: 'dd MMM yyyy HH:mm', dateString: memberDuty.date),
                        fontSize: 14,
                        color: AppColor.TEXT_LIGHT_MUTED_COLOR,
                      ),
                    ],
                  ),
                  _buildTextAlignLeft(
                    text: memberDuty.investigatorName,
                    maxLines: 2,
                    fontWeight: FontWeight.w500,
                  ),
                  _buildTextAlignLeft(
                    text: memberDuty.phoneNumber,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
