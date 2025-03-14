import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// TextStyles
TextStyle titleTextStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );

TextStyle subtitleTextStyle(BuildContext context) => TextStyle(
      fontSize: 10,
    );

TextStyle labelTextStyle(BuildContext context) => TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );

TextStyle progressTextStyle(BuildContext context) => TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

// Decorations
BoxDecoration imageContainerDecoration(String imageUrl, BuildContext context) =>
    BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
        image: CachedNetworkImageProvider(imageUrl),
        fit: BoxFit.fitHeight,
      ),
    );

BoxDecoration containerDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.blue.withOpacity(0.5)
          : Colors.white.withOpacity(0.1),
      borderRadius: const BorderRadius.all(Radius.circular(5)),
    );

BoxDecoration calendarDecoration(BuildContext context) => BoxDecoration(
    color: Theme.of(context).brightness == Brightness.light
        ? Colors.grey.withOpacity(0.3)
        : Colors.white.withOpacity(0.1),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    border: Border.all(color: Colors.deepPurple));

BoxDecoration ongoingPlanDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.blue.withOpacity(0.6)
          : Colors.lightBlue.withOpacity(0.2),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    );

// Icon Styles
IconData calendarIcon = Icons.calendar_today;
IconData progressIcon = Icons.trending_up;

// Button Styles
ButtonStyle buttonStyle(BuildContext context) => ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );

ButtonStyle buttonStyle2() => ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
