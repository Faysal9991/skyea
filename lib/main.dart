import 'dart:io';

import 'package:doyel_live/app/modules/auth/controllers/auth_controller.dart';
import 'package:doyel_live/app/modules/live_streaming/controllers/live_streaming_controller.dart';
import 'package:doyel_live/app/modules/messenger/controllers/messenger_controller.dart';
import 'package:doyel_live/app/utils/firebase_stuffs/fcm_notifications.dart';
import 'package:doyel_live/app/utils/firebase_stuffs/notification_message.dart';
import 'package:doyel_live/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app/routes/app_pages.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

@pragma('vm:entry-point')
Future<void> messageHandler(RemoteMessage message) async {
  NotificationMessage notificationMessage = NotificationMessage.fromJson(
    message.data,
  );
  messageNotification(
    notificationMessage.data!.title,
    notificationMessage.data!.message,
    notificationMessage,
  );
}

Future<void> _secureScreen() async {
  if (Platform.isAndroid) {
    await FlutterWindowManagerPlus.addFlags(
      FlutterWindowManagerPlus.FLAG_KEEP_SCREEN_ON,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

 await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  await googleSignIn.initialize(
    serverClientId:
        '327249087442-8e6lbgaf7al6aqsd8pk7rve117pvncp8.apps.googleusercontent.com',
        
  );

  await notificationInitialization();
  // FCM Background
  FirebaseMessaging.onBackgroundMessage(messageHandler);
  // FCM Foreground
  firebaseMessagingListener();

  Get.put(AuthController());
  Get.put(MessengerController());
  Get.put(LiveStreamingController());
  // Disable screenshot and screen recording
  _secureScreen();
  // Override the ssl certificate requirements
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    GetMaterialApp(
      title: "Sky Live",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
  useMaterial3: true,

  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: primaryColor,
    onPrimary: Colors.white,

    secondary: secondaryColor,
    onSecondary: Colors.white,

    tertiary: tertiaryColor,
    onTertiary: Colors.white,

    background: backgroundColor,
    onBackground: Colors.white,

    surface: surfaceColor,
    onSurface: Colors.white,

    error: Colors.redAccent,
    onError: Colors.white,
  ),

  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  fontFamily: 'Roboto',
  visualDensity: VisualDensity.adaptivePlatformDensity,

  // Optional: clean app bar & button styles
  appBarTheme: AppBarTheme(
    backgroundColor: surfaceColor,
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      elevation: 4,
    ),
  ),

  cardTheme: CardThemeData(
    color: surfaceColor,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 3,
    shadowColor: Colors.black54,
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
  ),
)
    ),
  );
}

const primaryColor   = Color(0xFFF7374F);   // Vibrant Pink-Red
const secondaryColor = Color(0xFF88304E);   // Deep Maroon
const tertiaryColor  = Color(0xFF522546);   // Dark Purple
const surfaceColor   = Color(0xFF2C2C2C);   // Dark Surface
const backgroundColor = Color(0xFF1E1E1E);  // Slightly lighter than pure black for depth
const goldAccent     = Color(0xFFFFD700);   