part of '../../../pages.dart';

// ignore: must_be_immutable
class DocTraceTrackingPage extends StatefulWidget {
  List<DocHistory> _docHistories = [];
  List<ReportHistory> _reportHistories = [];

  DocTraceTrackingPage({List<DocHistory> docHistories, List<ReportHistory> reportHistories}) {
    this._docHistories = docHistories;
    this._reportHistories = reportHistories;
  }

  @override
  _DocTraceTrackingState createState() => _DocTraceTrackingState();
}

class _DocTraceTrackingState extends State<DocTraceTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: (widget._docHistories != null) ? 'Tracking Berkas' : 'Progress Perkara',
        showSearchBar: false,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // decoration: BoxDecoration(color: Colors.blue),
        child: ListView.builder(
          itemCount: (widget._docHistories != null) ? widget._docHistories.length : widget._reportHistories.length,
          itemBuilder: (context, index) {
            if (widget._docHistories != null) {
              return _buildDocTraceTrackingItem(
                index: index,
                docHistory: widget._docHistories[index],
                totalValue: widget._docHistories.length,
                context: context,
              );
            }
            return _buildDocTraceTrackingItem(
              index: index,
              reportHistory: widget._reportHistories[index],
              totalValue: widget._reportHistories.length,
              context: context,
            );
          },
        ),
      ),
    );
  }
}
