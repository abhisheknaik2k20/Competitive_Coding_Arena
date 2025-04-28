import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:competitivecodingarena/Core_Project/Contest/contestclass.dart';

class PastContestsMenu extends StatefulWidget {
  final Size size;
  const PastContestsMenu({required this.size, super.key});

  @override
  State<PastContestsMenu> createState() => _PastContestsMenuState();
}

class _PastContestsMenuState extends State<PastContestsMenu> {
  int selectednum = 1;
  late ScrollController sc;
  // ignore: unused_field
  bool _isLoading = true;

  List<Contest> contests = [];

  Future<List<Contest>> fetchContestsFromFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot =
        await firestore.collection('contests').orderBy('Contest_id').get();
    return snapshot.docs.map((doc) => Contest.fromFirestore(doc)).toList();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      sc = ScrollController();
      generateList();
    }
  }

  void generateList() async {
    try {
      List<Contest> fetchedContests = await fetchContestsFromFirestore();
      if (mounted) {
        setState(() {
          contests = fetchedContests;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    sc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.height * 0.85,
      child: Column(
        children: [
          SizedBox(
              height: widget.size.height * 0.78,
              child: WindowsScrollbar(
                controller: sc,
                thickness: 16,
                buttonSize: 20,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView.builder(
                    controller: sc,
                    itemCount: contests.length,
                    itemBuilder: (context, index) {
                      return ContestCard(contest: contests[index]);
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class ContestCard extends StatelessWidget {
  final Contest contest;
  const ContestCard({super.key, required this.contest});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = contest.start.toDate();
    final isUpcoming = startDate.isAfter(now);
    final isPast = startDate.isBefore(
      now.subtract(
        const Duration(hours: 2),
      ),
    );
    final statusColor = isUpcoming
        ? Colors.green.shade400
        : isPast
            ? Colors.amber.shade400
            : Colors.red.shade400;
    final statusText = isUpcoming
        ? "Upcoming"
        : isPast
            ? "Ended"
            : "Live";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey[900],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Contest Image with indicator dot
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                          "https://assets.leetcode.com/contest/weekly-contest-290/card_img_1654267980.png",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                // Contest details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Contest #${contest.Contest_id}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.computer,
                                  size: 12,
                                  color: Colors.purple.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Virtual",
                                  style: TextStyle(
                                    color: Colors.purple.shade700,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Date and time
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMMM d, yyyy')
                                .format(contest.start.toDate()),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Status indicator
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 16,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.people,
                            size: 14,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "128 participants",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WindowsScrollbar extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final double thickness;
  final double buttonSize;

  const WindowsScrollbar({
    super.key,
    required this.child,
    required this.controller,
    this.thickness = 16.0,
    this.buttonSize = 20.0,
  });

  @override
  State<WindowsScrollbar> createState() => _WindowsScrollbarState();
}

class _WindowsScrollbarState extends State<WindowsScrollbar> {
  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      trackRadius: Radius.circular(widget.thickness / 4),
      thumbColor: Colors.blue[600],
      trackColor: Colors.grey.withOpacity(0.3),
      controller: widget.controller,
      thickness: widget.thickness * 0.5,
      radius: Radius.circular(widget.thickness / 4),
      thumbVisibility: true,
      trackVisibility: true,
      child: widget.child,
    );
  }
}
