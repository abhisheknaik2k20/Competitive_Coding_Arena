import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/Stack_OverFlow/COMMAN_SCREENS/preview_submission.dart';
import 'package:competitivecodingarena/Stack_OverFlow/COMMAN_SCREENS/submission_class.dart';
import 'package:flutter/material.dart';

class LiveSubmissions extends StatefulWidget {
  final String docref;
  final double width;
  const LiveSubmissions({required this.docref, required this.width, super.key});
  @override
  State<LiveSubmissions> createState() => _LiveSubmissionsState();
}

class _LiveSubmissionsState extends State<LiveSubmissions> {
  String _filterStatus = "All";
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width * 0.3,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppColors().gray)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildHeader(),
          _buildFilterBar(),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('stack_overflow_problems')
                      .doc(widget.docref)
                      .collection('submissions')
                      .orderBy('time_stamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text("Error: ${snapshot.error}",
                              style: const TextStyle(
                                  color: Colors.red, fontFamily: 'Roboto')));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState();
                    }
                    List<Submission> submissions = snapshot.data!.docs
                        .map((doc) => Submission.fromFirestore(doc))
                        .toList();
                    final filteredSubmissions = submissions
                        .where((s) =>
                            _filterStatus == "All" || s.status == _filterStatus)
                        .toList();
                    return filteredSubmissions.isEmpty
                        ? _buildEmptyState()
                        : _buildSubmissionsList(filteredSubmissions);
                  }))
        ]));
  }

  Widget _buildHeader() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors().lightGray,
        border: Border(bottom: BorderSide(color: AppColors().gray)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text("Live Submissions",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: 'Roboto')),
        _buildTagBadge("Problem")
      ]));

  Widget _buildFilterBar() => Padding(
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        Expanded(
            child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: "Status",
                    labelStyle: const TextStyle(
                        color: Color(0xFF6A737C),
                        fontSize: 13,
                        fontFamily: 'Roboto'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(color: AppColors().gray)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(color: AppColors.linkColor))),
                value: _filterStatus,
                items: statuses
                    .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status,
                            style: const TextStyle(
                                fontSize: 13, fontFamily: 'Roboto'))))
                    .toList(),
                onChanged: (value) {
                  if (mounted && value != null) {
                    setState(() => _filterStatus = value);
                  }
                })),
        const SizedBox(width: 8),
      ]));

  Widget _buildLoadingIndicator() => Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors().orange)));

  Widget _buildEmptyState() => const Center(
      child: Text("No submissions match the current filters",
          style: TextStyle(
              color: Color(0xFF6A737C),
              fontStyle: FontStyle.italic,
              fontFamily: 'Roboto')));

  Image _getImage(Submission sub) {
    if (sub.imageUrl != null) {
      return Image.network(sub.imageUrl!);
    }
    return Image.asset('assets/avatars/${sub.username.hashCode % 15}.jpg',
        fit: BoxFit.cover, width: 60, height: 60);
  }

  Widget _buildSubmissionsList(List<Submission> submissions) =>
      ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: submissions.length,
          itemBuilder: (context, index) {
            final submission = submissions[index];
            final isEven = index % 2 == 0;
            return Column(children: [
              ListTile(
                  tileColor: isEven ? Colors.white : AppColors().lightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  contentPadding: const EdgeInsets.all(12),
                  onTap: () =>
                      _viewSubmissionCode(submission, _getImage(submission)),
                  title: _buildUserRow(submission, _getImage(submission)),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildStatusRow(submission),
                        const SizedBox(height: 4),
                        _buildResourceUsage(submission),
                        _buildTagsRow(submission)
                      ])),
              if (index < submissions.length - 1)
                Divider(color: AppColors().gray, height: 1)
            ]);
          });

  Widget _buildUserRow(Submission submission, Image image) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          CircleAvatar(
              radius: 30,
              backgroundColor: Colors.primaries[
                  submission.username.hashCode % Colors.primaries.length],
              child: ClipOval(child: image)),
          const SizedBox(width: 6),
          Text(submission.username,
              style: const TextStyle(
                  color: AppColors.linkColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  fontFamily: 'Roboto'))
        ]),
        Text(getRelativeTime(submission.time_stamp),
            style: const TextStyle(
                color: Color(0xFF6A737C), fontSize: 11, fontFamily: 'Roboto'))
      ]);

  Widget _buildStatusRow(Submission submission) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _buildTagBadge(submission.language),
        getStatusBadge(submission.status)
      ]);

  Widget _buildResourceUsage(Submission submission) => Text(
      "${submission.executionTimeMs} ms, ${submission.memoryUsageKb / 1024} MB",
      style: const TextStyle(
          color: Color(0xFF6A737C),
          fontSize: 11,
          fontStyle: FontStyle.italic,
          fontFamily: 'Roboto'));

  Widget _buildTagsRow(Submission submission) => Wrap(
      children: submission.tags.map((tag) => TagBadge(label: tag)).toList());

  Widget _buildTagBadge(String label) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: AppColors().tagBackground,
          borderRadius: BorderRadius.circular(3)),
      child: Text(label,
          style: TextStyle(
              color: AppColors.tagText, fontSize: 11, fontFamily: 'Roboto')));

  String getRelativeTime(Timestamp timestamp) {
    DateTime postDate = timestamp.toDate();
    Duration diff = DateTime.now().difference(postDate);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
    } else if (diff.inDays < 30) {
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
    } else if (diff.inDays < 365) {
      return "${(diff.inDays / 30).floor()} month${(diff.inDays / 30).floor() > 1 ? 's' : ''} ago";
    } else {
      return "${(diff.inDays / 365).floor()} year${(diff.inDays / 365).floor() > 1 ? 's' : ''} ago";
    }
  }

  void _viewSubmissionCode(Submission submission, Image image) {
    showDialog(
        context: context,
        builder: (context) => DialogWindow(
            width: widget.width, submission: submission, image: image));
  }

  Widget getStatusBadge(String status) {
    Color badgeColor;
    IconData icon;
    switch (status) {
      case "Accepted":
        badgeColor = Color(0xFF48A868);
        icon = Icons.check_circle;
        break;
      case "Wrong Answer":
        badgeColor = Color(0xFFD1383D);
        icon = Icons.close;
        break;
      case "Time Limit Exceeded":
        badgeColor = Color(0xFFFF9800);
        icon = Icons.timer_off;
        break;
      case "Runtime Error":
        badgeColor = Color(0xFF9C27B0);
        icon = Icons.error;
        break;
      case "Compilation Error":
        badgeColor = Colors.blue;
        icon = Icons.code_off;
        break;
      default:
        badgeColor = Color(0xFF6A737C);
        icon = Icons.question_mark;
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: badgeColor)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 12, color: badgeColor),
          SizedBox(width: 4),
          Text(status,
              style: TextStyle(
                  color: badgeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  fontFamily: 'Roboto'))
        ]));
  }
}
