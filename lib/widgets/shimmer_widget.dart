part of 'widgets.dart';

class ShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Shimmer.fromColors(
        baseColor: AppColor.SHIMMER_BASE_COLOR,
        highlightColor: AppColor.SHIMMER_HIGHLIGHT_COLOR,
        child: Row(
          children: [
            Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 32,
                      width: constraints.maxWidth * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 32,
                      width: constraints.maxWidth * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerBannerWidget extends StatelessWidget {
  final int index;

  ShimmerBannerWidget({this.index});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.SHIMMER_BASE_COLOR,
      highlightColor: AppColor.SHIMMER_HIGHLIGHT_COLOR,
      child: Container(
        height: 150,
        width: 300,
        // margin: (index == 0) ? EdgeInsets.only(left: 24, right: 24) : EdgeInsets.only(right: 24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
