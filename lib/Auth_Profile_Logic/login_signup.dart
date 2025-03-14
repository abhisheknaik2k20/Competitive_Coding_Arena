import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/containers/homescreen.dart';
import 'package:competitivecodingarena/Snackbars&Pbars/snackbars.dart';
import 'package:competitivecodingarena/Auth_Profile_Logic/VerifyMail/verifyMail.dart';
import 'package:competitivecodingarena/Welcome/welcome.dart';

Future<String?> generateTokenForUser() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BGxdz3CJNo8eROmc5hd7PBQ6AreBbQ4w4SKU5OEIrIwOymU6bloDleVFBbULqlF11wtFy7BdXt0CzIskUnB7tVQ");
    return token;
  } catch (exception) {
    print(exception);
    return null;
  }
}

Future<void> updatetoken(String token, User user) async {
  try {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    await userDoc.update({
      'token': token,
    });
  } catch (exception) {
    // ignore: avoid_print
    print(exception);
  }
}

Future<void> saveUserDataToFirestore(User user, {String? name}) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final docSnapshot = await userDoc.get();
  final String? token = await generateTokenForUser();
  if (!docSnapshot.exists) {
    await userDoc.set({
      'email': user.email,
      'name': name ?? user.displayName ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
      'roadmap': null,
      'token': token,
      'isPremium': false,
    });
  } else {
    await userDoc.update({
      'lastLogin': FieldValue.serverTimestamp(),
      'token': token,
    });
  }
}

void loginLogic(
  BuildContext context,
  String email,
  String password,
) async {
  bool isLoginSuccessful = false;
  showCircularbar(context);
  try {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    await saveUserDataToFirestore(userCredential.user!);
    isLoginSuccessful = true;
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.code);
  }
  Navigator.of(context).pop();
  if (isLoginSuccessful) {
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => LeetCodeProblemsetHomescreen(
                size: MediaQuery.of(context).size)),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const VerifyMail()));
    }
  }
}

void signUpLogic(
  BuildContext context,
  String email,
  String password,
  String name,
) async {
  showCircularbar(context);
  bool isSignupSuccessful = false;
  try {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user!.updateDisplayName(name);
    await userCredential.user!.updatePassword(password);
    await userCredential.user!.sendEmailVerification();
    await saveUserDataToFirestore(userCredential.user!, name: name);
    isSignupSuccessful = true;
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.code);
  }
  Navigator.of(context).pop();
  if (isSignupSuccessful) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const VerifyMail()));
  }
}

void logoutLogic(BuildContext context) async {
  bool isLoginOutSuccessful = false;
  showCircularbar(context);
  try {
    await FirebaseAuth.instance.signOut();
    isLoginOutSuccessful = true;
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.code);
  }
  Navigator.of(context).pop();
  if (isLoginOutSuccessful) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (Route<dynamic> route) => false,
    );
  }
}

Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
  try {
    showCircularbar(context);
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithPopup(googleAuthProvider);
    await saveUserDataToFirestore(userCredential.user!);
    Navigator.of(context).pop();
    return userCredential;
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.message!);
    return null;
  }
}

Future<UserCredential?> gitHubSignIn(BuildContext context) async {
  try {
    final githubAuthProvider = GithubAuthProvider();
    githubAuthProvider.addScope('read:user');
    githubAuthProvider.addScope('user:email');
    githubAuthProvider.setCustomParameters({
      'allow_signup': 'true',
    });
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(githubAuthProvider);
      await saveUserDataToFirestore(userCredential.user!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  } catch (error) {
    showSnackBar(context, error.toString());
  }
  return null;
}
