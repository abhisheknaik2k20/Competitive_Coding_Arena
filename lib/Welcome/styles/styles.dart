import 'package:flutter/material.dart';

TextStyle appBarTextStyle = const TextStyle(
    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

TextStyle appBarOptionTextStyle =
    const TextStyle(color: Color.fromARGB(255, 231, 59, 116), fontSize: 16);

const TextStyle infoContainerTitleTextStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white);

TextStyle infoContainerDescriptionTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.white.withOpacity(0.7),
    fontWeight: FontWeight.bold);

const TextStyle sectionTitleTextStyle =
    TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white);

TextStyle sectionDescriptionTextStyle =
    TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.7));

TextStyle buttonTextStyle = const TextStyle(color: Colors.white, fontSize: 16);

const TextStyle featureCardTitleTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);

TextStyle featureCardDescriptionTextStyle =
    TextStyle(fontSize: 16, color: Colors.white);

BoxDecoration infoContainerDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.1).withOpacity(0.1),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    border: Border.all(color: Colors.white.withOpacity(0.1)),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5)
    ]);

BoxDecoration sectionContainerDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5)
    ]);

BoxDecoration featureCardDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    border: Border.all(color: Colors.white.withOpacity(0.2)),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5)
    ]);

const BoxDecoration iconDecoration = BoxDecoration(
    color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(15)));

const BoxDecoration logoDecoration = BoxDecoration(
    color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10)));

// Button Styles
final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    backgroundColor: Colors.blue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));
