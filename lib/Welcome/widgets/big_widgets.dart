import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Auth_Profile_Logic/login.dart';
import 'package:competitivecodingarena/Welcome/styles/styles.dart';
import 'package:competitivecodingarena/Welcome/widgets/small_widgets.dart';
import 'dart:math' as math;

Widget buildAppBar(BuildContext context, Size size) {
  List<String> options = ['Explore', 'Product', 'Developer', 'Login'];
  return SliverAppBar(
    floating: true,
    pinned: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    expandedHeight: 80,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: false,
      titlePadding: EdgeInsets.only(left: size.width * 0.1, bottom: 16),
      title: Row(
        children: [
          Image.asset(
            "assets/images/logo.png",
            width: 40,
          ),
          const SizedBox(width: 10),
          const Text(
            'Competitive Coding Arena',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
    actions: [
      for (String option in options)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: TextButton(
              onPressed: () {
                if (option == "Login") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        size: size,
                      ),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                option,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      SizedBox(width: size.width * 0.1),
    ],
  );
}

Widget buildIntroSection(AnimationController controller1) {
  return SliverToBoxAdapter(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAnimatedImage(controller1, 'assets/images/data.png', 350),
            buildInfoContainer(
              'A New Way to Learn',
              'Competitive Coding Arena is the best platform to help you enhance your skills, expand your knowledge, and prepare for technical interviews.',
              'Get Started',
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildExploreSection(AnimationController controller2) {
  return SliverToBoxAdapter(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildInfoContainer(
              'Start Exploring',
              'Explore is a well-organized tool that helps you get the most out of Competitive Coding Arena by providing structure to guide your progress towards the next step in your programming career.',
              'Explore Courses',
              icon: Icons.school,
            ),
            _buildAnimatedImage(controller2, 'assets/images/course.png', 250),
          ],
        ),
      ),
    ),
  );
}

Widget buildWhycompetitivecodingarenaSection() {
  return SliverToBoxAdapter(
    child: Center(
      child: buildSectionContainer(
        'Why Competitive Coding Arena?',
        Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildFeatureCard(
                  icon: Icons.code,
                  title: 'Coding Skills',
                  description:
                      'Enhance your coding skills with our carefully curated problem set and solutions.',
                ),
                buildFeatureCard(
                  icon: Icons.people,
                  title: 'Interview Prep',
                  description:
                      'Prepare for technical interviews with real questions from top companies.',
                ),
                buildFeatureCard(
                  icon: Icons.leaderboard,
                  title: 'Community',
                  description:
                      'Join a global community of developers to learn and grow together.',
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildCompaniesSection() {
  return SliverToBoxAdapter(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100.0),
        child: buildSectionContainer(
          'Competitive Coding Arena for Companies',
          Column(
            children: [
              Text(
                'Streamline your technical hiring process with Competitive Coding Arena\'s powerful tools.',
                style: sectionDescriptionTextStyle,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: buttonStyle,
                child: Text('Learn More', style: buttonTextStyle),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildAnimatedImage(
    AnimationController controller, String assetPath, double width) {
  return AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      return Transform.translate(
        offset: Offset(0, 10 * math.sin(controller.value * 2 * math.pi)),
        child: child,
      );
    },
    child: Image.asset(assetPath, width: width),
  );
}
