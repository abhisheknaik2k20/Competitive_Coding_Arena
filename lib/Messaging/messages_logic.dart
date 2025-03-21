import 'dart:convert';
import 'package:competitivecodingarena/API_KEYS/api.dart';
import 'package:competitivecodingarena/Auth_Profile_Logic/login_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  static Future<String> getAccessToken() async {
    final serviceAccountJSON = ApiKeys().serviceJson;
    List<String> scopes = ApiKeys().scopes;
    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJSON), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJSON),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  static sendNotification(
      {required String token,
      required String title,
      required String body}) async {
    final String serverKey = await getAccessToken();
    String endPointFirebaseCloudMessaging = ApiKeys().firebasendpoint;
    final Map<String, dynamic> message = {
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
      }
    };
    final http.Response response = await http.post(
        Uri.parse(endPointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey'
        },
        body: jsonEncode(message));
    if (response.statusCode == 200) {
      print("Notification Sent Successfully");
    } else {
      print("Failed to send notification");
    }
  }
}

Future<void> requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  try {
    NotificationSettings settings = await messaging
        .requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        )
        .timeout(const Duration(seconds: 5));

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await generateTokenForUser();
      token != null ? print("Token Generated") : print("Token Not Generated");
      if (token != null && FirebaseAuth.instance.currentUser != null) {
        await updatetoken(token, FirebaseAuth.instance.currentUser!);
      }
    }
    _configureMessageListeners();
  } catch (e) {
    print('Notification permission request failed: $e');
  }
}

void _configureMessageListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    compute(_handleForegroundMessage, message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleMessageNavigation(message);
  });
}

void _handleForegroundMessage(RemoteMessage message) {
  print('Received foreground message: ${message.notification?.title}');
}

void _handleMessageNavigation(RemoteMessage message) {
  print('Message opened app: ${message.notification?.title}');
}
