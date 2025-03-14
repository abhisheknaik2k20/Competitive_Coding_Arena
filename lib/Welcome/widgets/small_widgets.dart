import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Welcome/styles/styles.dart';

Widget buildLogo() {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: logoDecoration,
    child: const Icon(Icons.code, color: Colors.white, size: 28),
  );
}

Widget buildInfoContainer(String title, String description, String buttonText,
    {IconData? icon}) {
  return Container(
    width: 500,
    padding: const EdgeInsets.all(20),
    decoration: infoContainerDecoration,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: infoContainerTitleTextStyle,
            ),
            if (icon != null) ...[
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: iconDecoration,
                child: Icon(icon, size: 30, color: Colors.white),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
        Text(
          description,
          style: infoContainerDescriptionTextStyle,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {},
          style: buttonStyle,
          child: Text(buttonText, style: buttonTextStyle),
        ),
      ],
    ),
  );
}

Widget buildFeatureCard({
  required IconData icon,
  required String title,
  required String description,
}) {
  return Container(
    width: 300,
    padding: const EdgeInsets.all(20),
    decoration: featureCardDecoration,
    child: Column(
      children: [
        Icon(icon, color: Colors.blue[300], size: 50),
        const SizedBox(height: 10),
        Text(
          title,
          style: featureCardTitleTextStyle,
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: featureCardDescriptionTextStyle,
        ),
      ],
    ),
  );
}

Widget buildSectionContainer(String title, Widget content) {
  return Container(
    width: 1000,
    padding: const EdgeInsets.all(20),
    decoration: sectionContainerDecoration,
    child: Column(
      children: [
        Text(
          title,
          style: sectionTitleTextStyle,
        ),
        content,
      ],
    ),
  );
}
