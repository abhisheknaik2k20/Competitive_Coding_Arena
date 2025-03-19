import 'package:competitivecodingarena/Core_Project/Community/community.dart';
import 'package:competitivecodingarena/Stack_OverFlow/stack_overflow_screen.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/Contest/banner.dart';
import 'package:competitivecodingarena/Core_Project/Contest/roadmap.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/containers/ads_cal.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/containers/appbar.dart';

class LeetCodeProblemsetHomescreen extends StatefulWidget {
  final Size size;
  const LeetCodeProblemsetHomescreen({required this.size, super.key});

  @override
  State<LeetCodeProblemsetHomescreen> createState() =>
      _LeetCodeProblemsetHomescreenState();
}

class _LeetCodeProblemsetHomescreenState
    extends State<LeetCodeProblemsetHomescreen> {
  String selectedItem = "Problems";

  List<Widget> buildHeader() {
    return [
      HomeAppBar(
        setItem: setItem,
      ),
    ];
  }

  setItem(String item) {
    setState(() {
      selectedItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildCurrentScreen() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: Center(child: _getCurrentScreen()),
    );
  }

  Widget _getCurrentScreen() {
    switch (selectedItem) {
      case 'Problems':
        return AdsAndCalenderAndProblems(size: widget.size);
      case 'Contest':
        return ScreenBannerAndFeatured(size: widget.size);
      case 'Road-Map':
        return const DSARoadmapScreen();
      case 'Community':
        return CommunityScreen();
      default:
        return StackOverflowHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ...buildHeader(),
          SliverToBoxAdapter(
            child: _buildCurrentScreen(),
          ),
        ],
      ),
    );
  }
}
