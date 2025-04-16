import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/Contest/contestclass.dart';
import 'package:competitivecodingarena/Core_Project/Contest/leaderboard.dart';
import 'package:competitivecodingarena/Core_Project/Contest/prev_contest.dart';
import 'package:competitivecodingarena/Core_Project/Contest/register.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:competitivecodingarena/ImageScr/contestscreen.dart';

class FeaturedContest extends StatefulWidget {
  final Size size;
  const FeaturedContest({required this.size, super.key});

  @override
  State<FeaturedContest> createState() => _FeaturedContestState();
}

class _FeaturedContestState extends State<FeaturedContest> {
  List<Contest> contests = [];

  Future<List<Contest>> fetchContestsFromFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot =
        await firestore.collection('contests').orderBy('Contest_id').get();
    return snapshot.docs.map((doc) => Contest.fromFirestore(doc)).toList();
  }

  void generateList() async {
    try {
      List<Contest> fetchedContests = await fetchContestsFromFirestore();
      if (mounted) setState(() => contests = fetchedContests);
    } catch (e) {
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) generateList();
  }

  @override
  Widget build(BuildContext context) => Center(
      child: SizedBox(
          width: widget.size.width * 0.5,
          child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text("Featured Content",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _buildFeaturedContests(context),
                    const SizedBox(height: 40),
                    _buildPastContestsAndRanking()
                  ]))));

  Widget _buildFeaturedContests(BuildContext context) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) => _buildContestItem(context, i)));

  Widget _buildContestItem(BuildContext context, int index) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisterScreen(
                    problem: problemexample[0], contest: contests[index]))),
            child: Container(
                clipBehavior: Clip.antiAlias,
                width: widget.size.width * 0.15,
                height: widget.size.height * 0.17,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(featured[index]['image']),
                        fit: BoxFit.fitHeight)))),
        Text("Contest 29$index", style: TextStyle(fontWeight: FontWeight.bold)),
        Row(children: [
          Icon(Icons.timer_outlined,
              size: 15,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.5)
                  : Colors.grey),
          const SizedBox(width: 5),
          Text("Online",
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Text("May 1, 2024",
              style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : Colors.grey,
                  fontWeight: FontWeight.bold))
        ])
      ]);

  Widget _buildPastContestsAndRanking() =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 3, child: _buildPastContests()),
        Expanded(flex: 2, child: _buildGlobalRanking())
      ]);

  Widget _buildPastContests() => Container(
      padding: const EdgeInsets.all(5),
      height: widget.size.height * 0.9,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Past Contests",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.6)
                    : Colors.grey[800])),
        const SizedBox(height: 5),
        PastContestsMenu(size: widget.size)
      ]));

  Widget _buildGlobalRanking() => Container(
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10)),
      height: widget.size.height * 0.85,
      padding: EdgeInsets.only(top: 20, right: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.network(
              'https://thisismybucketiambatman123456.s3.ap-south-1.amazonaws.com/DO_NOT_DELETE/career.png',
              width: 25),
          const SizedBox(width: 5),
          Text("Global Rankings",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20))
        ]),
        const SizedBox(height: 10),
        Categories(size: widget.size)
      ]));
}
