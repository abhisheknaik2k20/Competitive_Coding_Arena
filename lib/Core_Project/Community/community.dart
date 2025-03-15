import 'package:competitivecodingarena/Core_Project/Community/map_screen.dart';
import 'package:competitivecodingarena/Core_Project/Community/search_screen.dart';
import 'package:competitivecodingarena/Core_Project/Community/skill_cluster.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreen();
}

class _CommunityScreen extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: height * 0.6,
                width: width * 0.48,
                decoration: BoxDecoration(
                    border: Border.all(width: 5, color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
                child: MapScreen(),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 5),
                    borderRadius: BorderRadius.circular(10)),
                height: height * 0.6,
                width: width * 0.5,
                child: SearchScreen(),
              ),
            ],
          ),
          SkillClusteringScreen()
        ],
      ),
    );
  }
}
